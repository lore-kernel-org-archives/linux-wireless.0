Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46726 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935299AbcKOJGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 04:06:19 -0500
Message-ID: <1479200773.12007.13.camel@sipsolutions.net> (sfid-20161115_100628_313395_F0EA1D02)
Subject: Re: [PATCH V3] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org
Cc: btherthala@quantenna.com, hwang@quantenna.com,
        smaksimenko@quantenna.com, dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 15 Nov 2016 10:06:13 +0100
In-Reply-To: <1478700000-11624-2-git-send-email-igor.mitsyanko.os@quantenna.com>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
         <1478700000-11624-2-git-send-email-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-11-09 at 17:00 +0300, igor.mitsyanko.os@quantenna.com
wrote:

> +static int
> +qtnf_change_virtual_intf(struct wiphy *wiphy,
> +			 struct net_device *dev,
> +			 enum nl80211_iftype type, u32 *flags,
> +			 struct vif_params *params)
> +{
> +	struct qtnf_vif *vif;
> +	u8 *mac_addr;
> +
> +	vif = qtnf_netdev_get_priv(dev);
> +
> +	if (params)
> +		mac_addr = params->macaddr;
> +	else
> +		mac_addr = NULL;
> +
> +	if (qtnf_cmd_send_change_intf_type(vif, type, mac_addr)) {
> +		pr_err("failed to change interface type\n");
> +		return -EFAULT;
> +	}
> +
> +	vif->wdev.iftype = type;
> +	return 0;
> +}

Do you really support arbitrary type changes?

You might even have to handle ongoing scans, etc.

> +	/* Clear the vif in mac */

"mac"? Maybe you mean cfg80211?

> +	vif->netdev->ieee80211_ptr = NULL;
> +	vif->netdev = NULL;
> +	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
> +	eth_zero_addr(vif->mac_addr);
> +
> +	return 0;
> +}

But I'm not sure this makes sense? You're not actually deleting the
interface here, so why sever all the links/clear all the data?


> +/* concatenate all the beacon IEs into one buffer
> + * Take IEs from head, tail and beacon_ies fields of
cfg80211_beacon_data
> + * and append it to provided buffer.
> + * Checks total IE buf length to be <= than IEEE80211_MAX_DATA_LEN.
> + * Checks IE buffers to be valid, so that resulting buffer
> + * should be a valid IE buffer with length <=
IEEE80211_MAX_DATA_LEN.
> + */

I'm not sure this is right - beacon_ies is head+tail already, I think?

> +static int
> +qtnf_dump_station(struct wiphy *wiphy, struct net_device *dev,
> +		  int idx, u8 *mac, struct station_info *sinfo)
> +{
> +	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
> +	const struct qtnf_sta_node *sta_node;
> +	int ret;
> +
> +	sta_node = qtnf_sta_list_lookup_index(&vif->sta_list, idx);
> +
> +	if (unlikely(!sta_node))
> +		return -ENOENT;
> +
> +	ether_addr_copy(mac, sta_node->mac_addr);
> +
> +	ret = qtnf_cmd_get_sta_info(vif, sta_node->mac_addr, sinfo);
> +
> +	if (unlikely(ret == -ENOENT)) {
> +		sinfo->filled = 0;
> +		ret = 0;
> +	}

This case seems slightly odd - what does it mean that the station
existed, but getting the information returned -ENOENT? Is that because
it's racy, somehow? If so, wouldn't it be better to take this as an
indication that the station doesn't exist, and skip this entry entirely
or something?

> +	/* nofity cfg80211 */

typo :)

> +	while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
> +		tlv_type = le16_to_cpu(tlv->type);
> +		tlv_value_len = le16_to_cpu(tlv->len);
> +		tlv_full_len = tlv_value_len + sizeof(struct
qlink_tlv_hdr);
> +
> +		if (tlv_full_len > payload_len) {
> +			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
> +				tlv_type, tlv_value_len);
> +			return -EINVAL;
> +		}
> +
> +		if (tlv_type == QTN_TLV_ID_IE_SET) {
> +			ies = tlv->val;
> +			ies_len = tlv_value_len;
> +		}
> +
> +		payload_len -= tlv_full_len;
> +		tlv = (struct qlink_tlv_hdr *)(tlv->val +
tlv_value_len);
> +	}
> +
> +	if (payload_len) {
> +		pr_warn("malformed IEs buf; bytes left: %zu\n",
payload_len);
> +		return -EINVAL;
> +	}

Don't you mean "malformed TLVs buf"? It's obviously similar, but you
refer to this encoding as TLV, not IE.

Maybe you should ignore it too, since it's a firmware bug?

> +	qdev_vif = netdev_priv(dev);
> +	*((unsigned long *)qdev_vif) = (unsigned long)vif;

This seems very strange - why unsigned long, rather than void? I mean

 *(void **)qdev_vif = vif;

> +static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv)
> +{
> +	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
> +	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
> +	const struct qtnf_shm_ipc_int ipc_int = {
qtnf_ipc_gen_ep_int, priv };
> +	const struct qtnf_shm_ipc_rx_callback rx_callback = {
> +					qtnf_pcie_control_rx_callbac
k, priv };

If those are const, why not also static? In fact, it seems they really
should be, since they're registered below?

> +static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
> +{
> +	unsigned long vaddr;
> +	dma_addr_t paddr;
> +	int len;
> +
> +	len = priv->tx_bd_num * sizeof(struct qtnf_tx_bd) +
> +		priv->rx_bd_num * sizeof(struct qtnf_rx_bd);
> +
> +	vaddr = (unsigned long)dmam_alloc_coherent(&priv->pdev->dev,
> +						   len, &paddr,
GFP_KERNEL);
> +	if (!vaddr)
> +		return -ENOMEM;
> +
> +	/* tx bd */
> +
> +	memset((void *)vaddr, 0, len);

Those unsigned long/void * casts look strange too. Why not use a "void
*vaddr" to start with?

> +	priv->bd_table_vaddr = vaddr;

Maybe need a cast here, if that variable is needed at all (identical to
tx_bd_vbase), or make that struct member also void *?

> +	priv->bd_table_paddr = paddr;
> +	priv->bd_table_len = len;
> +
> +	priv->tx_bd_vbase = (struct qtnf_tx_bd *)vaddr;

Don't even need that cast then.

> +	priv->tx_bd_pbase = paddr;
> +
> +	pr_debug("TX descriptor table: vaddr=0x%p paddr=%pad\n",
> +		 (void *)vaddr, &paddr);
> +
> +	priv->tx_bd_reclaim_start = 0;
> +	priv->tx_bd_index = 0;
> +	priv->tx_queue_len = 0;
> +
> +	/* rx bd */
> +
> +	vaddr += priv->tx_bd_num * sizeof(struct qtnf_tx_bd);

Here you can do something like

 vaddr = ((struct qtnf_tx_bd)vaddr) + priv->tx_bd_num;

> +	paddr += priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
> +
> +	priv->rx_bd_vbase = (struct qtnf_rx_bd *)vaddr;

no need for the cast here then.

> +	priv->rx_bd_pbase = paddr;
> +
> +	writel(QTN_HOST_LO32(paddr),
> +	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
> +	writel(QTN_HOST_HI32(paddr),
> +	       PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
> +	writel(priv->rx_bd_num | (sizeof(struct qtnf_rx_bd)) << 16,
> +	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
> +
> +	priv->hw_txproc_wr_ptr = priv->rx_bd_num -
rx_bd_reserved_param;
> +
> +	writel(priv->hw_txproc_wr_ptr,
> +	       PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
> +
> +	pr_debug("RX descriptor table: vaddr=0x%p paddr=%pad\n",
> +		 (void *)vaddr, &paddr);

Nor here.

On the whole, it probably doesn't really matter (I'd let Kalle decide I
guess). Just looks odd to me.

> +	/* sync up all descriptor updates before passing them to EP
*/
> +	wmb();

I think you need dma_wmb()?


So I mostly looked at the cfg80211 bits, obviously - the other comments
were just in passing.

I also didn't review the flows - some of these things are tricky (e.g.
are there races between userspace asking to disconnect, and disconnect
notification, and similar). Maybe it helps anyway :)

johannes
