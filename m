Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11271 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbbIHB0S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 21:26:18 -0400
From: David Lin <dlin@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>
Subject: RE: [PATCH v6] Add new mac80211 driver mwlwifi.
Date: Tue, 8 Sep 2015 01:26:11 +0000
Message-ID: <526ab21624124a8492548e3299c59ea4@SC-EXCH02.marvell.com> (sfid-20150908_032622_438505_CA4B4B6B)
References: <20456de5ab0b43b69441b19abb282c31@SC-EXCH02.marvell.com>
 <877fo2cn1l.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877fo2cn1l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Kalle Valo <kvalo@codeaurora.org> writes:
> 
> David Lin <dlin@marvell.com> writes:
> 
> > The Linux driver for WRT1900AC. The work was initially developed as
> > part of openwrt effort and maintained on https://github.com/kaloz/mwlwifi.
> >
> > This is still work in progress, with 8864 chipset more mature and
> > tested, while 8897 for the similar use case is added recently.
> >
> > Signed-off-by: David Lin <dlin@marvell.com>
> 
> [...]
> 
> > +static void mwl_reg_notifier(struct wiphy *wiphy,
> > +			     struct regulatory_request *request) { #ifdef CONFIG_OF
> > +	struct ieee80211_hw *hw;
> > +	struct mwl_priv *priv;
> > +	struct property *prop;
> > +	struct property *fcc_prop = NULL;
> > +	struct property *etsi_prop = NULL;
> > +	struct property *specific_prop = NULL;
> > +	u32 prop_value;
> > +	int i, j, k;
> > +
> > +	hw = (struct ieee80211_hw *)wiphy_priv(wiphy);
> > +	priv = hw->priv;
> > +
> > +	if (priv->pwr_node) {
> > +		for_each_property_of_node(priv->pwr_node, prop) {
> > +			if (strcmp(prop->name, "FCC") == 0)
> > +				fcc_prop = prop;
> > +			if (strcmp(prop->name, "ETSI") == 0)
> > +				etsi_prop = prop;
> > +			if ((prop->name[0] == request->alpha2[0]) &&
> > +			    (prop->name[1] == request->alpha2[1]))
> > +				specific_prop = prop;
> > +		}
> > +
> > +		prop = NULL;
> > +
> > +		if (specific_prop) {
> > +			prop = specific_prop;
> > +		} else {
> > +			if (request->dfs_region == NL80211_DFS_ETSI)
> > +				prop = etsi_prop;
> > +			else
> > +				prop = fcc_prop;
> > +		}
> > +
> > +		if (prop) {
> > +			/* Reset the whole table */
> > +			for (i = 0; i < SYSADPT_MAX_NUM_CHANNELS; i++)
> > +				memset(&priv->tx_pwr_tbl[i], 0,
> > +				       sizeof(struct mwl_tx_pwr_tbl));
> > +
> > +			/* Load related power table */
> > +			i = 0;
> > +			j = 0;
> > +			while (i < prop->length) {
> > +				prop_value =
> > +					be32_to_cpu(*(__be32 *)
> > +						    (prop->value + i));
> > +				priv->tx_pwr_tbl[j].channel = prop_value;
> > +				i += 4;
> > +				prop_value =
> > +					be32_to_cpu(*(__be32 *)
> > +						    (prop->value + i));
> > +				priv->tx_pwr_tbl[j].setcap = prop_value;
> > +				i += 4;
> > +				for (k = 0; k < SYSADPT_TX_POWER_LEVEL_TOTAL;
> > +				     k++) {
> > +					prop_value =
> > +						be32_to_cpu(*(__be32 *)
> > +							    (prop->value + i));
> > +					priv->tx_pwr_tbl[j].tx_power[k] =
> > +						prop_value;
> > +					i += 4;
> > +				}
> > +				prop_value =
> > +					be32_to_cpu(*(__be32 *)
> > +						    (prop->value + i));
> > +				priv->tx_pwr_tbl[j].cdd =
> > +					(prop_value == 0) ? false : true;
> > +				i += 4;
> > +				prop_value =
> > +					be32_to_cpu(*(__be32 *)
> > +						    (prop->value + i));
> > +				priv->tx_pwr_tbl[j].txantenna2 = prop_value;
> > +				i += 4;
> > +				j++;
> > +			}
> > +
> > +			/* Dump loaded power tabel */
> > +			wiphy_info(hw->wiphy, "%s: %s\n", dev_name(&wiphy->dev),
> > +				   prop->name);
> > +			for (i = 0; i < SYSADPT_MAX_NUM_CHANNELS; i++) {
> > +				struct mwl_tx_pwr_tbl *pwr_tbl;
> > +				char disp_buf[64];
> > +				char *disp_ptr;
> > +
> > +				pwr_tbl = &priv->tx_pwr_tbl[i];
> > +				if (pwr_tbl->channel == 0)
> > +					break;
> > +				wiphy_info(hw->wiphy,
> > +					   "Channel: %d: 0x%x 0x%x 0x%x\n",
> > +					   pwr_tbl->channel,
> > +					   pwr_tbl->setcap,
> > +					   pwr_tbl->cdd,
> > +					   pwr_tbl->txantenna2);
> > +				disp_ptr = disp_buf;
> > +				for (j = 0; j < SYSADPT_TX_POWER_LEVEL_TOTAL;
> > +				     j++) {
> > +					disp_ptr +=
> > +						sprintf(disp_ptr, "%x ",
> > +							pwr_tbl->tx_power[j]);
> > +				}
> > +				wiphy_info(hw->wiphy, "%s\n", disp_buf);
> > +			}
> > +		}
> > +	}
> > +#endif
> > +}
> > +
> > +static void mwl_process_of_dts(struct mwl_priv *priv) { #ifdef
> > +CONFIG_OF
> > +	struct property *prop;
> > +	u32 prop_value;
> > +
> > +	priv->dt_node =
> > +		of_find_node_by_name(pci_bus_to_OF_node(priv->pdev->bus),
> > +				     "mwlwifi");
> > +	if (!priv->dt_node)
> > +		return;
> > +
> > +	/* look for all matching property names */
> > +	for_each_property_of_node(priv->dt_node, prop) {
> > +		if (strcmp(prop->name, "marvell,2ghz") == 0)
> > +			priv->disable_2g = true;
> > +		if (strcmp(prop->name, "marvell,5ghz") == 0)
> > +			priv->disable_5g = true;
> > +		if (strcmp(prop->name, "marvell,chainmask") == 0) {
> > +			prop_value = be32_to_cpu(*((__be32 *)prop->value));
> > +			if (prop_value == 2)
> > +				priv->antenna_tx = ANTENNA_TX_2;
> > +
> > +			prop_value = be32_to_cpu(*((__be32 *)
> > +						 (prop->value + 4)));
> > +			if (prop_value == 2)
> > +				priv->antenna_rx = ANTENNA_RX_2;
> > +		}
> > +	}
> > +
> > +	priv->pwr_node = of_find_node_by_name(priv->dt_node,
> > +					      "marvell,powertable");
> > +#endif
> > +}
> 
> The device tree bindings need a proper document in
> Documentation/devicetree/bindings and reviewed by the device tree folks.
> That might take some time as I suspect having something like regdomain in DT
> will be problematic, so I recommend to take this out from initial submission
> and resend later once properly acked by the device tree maintainers.
> 
> --
> Kalle Valo

Yes. I will remove them for next patch.

Thanks,
David
