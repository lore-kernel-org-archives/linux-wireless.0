Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23681 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab2ENRgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 13:36:24 -0400
Date: Mon, 14 May 2012 10:36:21 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: enable enhanced bmiss detection
Message-ID: <20120514173621.GA3705@pista> (sfid-20120514_193628_281919_D4407F97)
References: <1336778089-11473-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <4FB0A931.80309@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FB0A931.80309@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Thanks for your comments, v2 coming shortly.

Thomas

On Mon, May 14, 2012 at 09:41:53AM +0300, Kalle Valo wrote:
> On 05/12/2012 02:14 AM, Thomas Pedersen wrote:
> > Enable enhanced bmiss detection if the firmware supports it. This
> > feature is only enabled on some firmwares since it comes with a power
> > cost.
> > 
> > Also add a few missing command ids to keep the enums straight.
> > 
> > Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
> 
> [...]
> 
> > @@ -1512,6 +1513,8 @@ static int ath6kl_cfg80211_change_iface(struct >
> wiphy *wiphy,
> > 		}
> > 	}
> >
> > +	ath6kl_sta_bmiss_enhance(vif, false);
> 
> A comment why you disable the feature is good to have. I'm sure there's
> a good reason :)
> 
> > +void ath6kl_sta_bmiss_enhance(struct ath6kl_vif *vif, bool enable)
> > +{
> 
> Please cfg80211 prefix, eg. ath6kl_cfg80211_bmiss_enhance() or something
> like that.
> 
> > +	int err;
> > +
> > +	if (WARN_ON(!test_bit(WMI_READY, &vif->ar->flag)))
> > +		return;
> > +
> > +	if (vif->nw_type == INFRA_NETWORK &&
> > +	    test_bit(ATH6KL_FW_CAPABILITY_BMISS_ENHANCE,
> > +		     vif->ar->fw_capabilities)) {
> 
> Less indentation:
> 
> if (vif->nw_type != INFRA_NETWORK)
> 	return;
> 
> if (!test_bit(ATH6KL_FW_CAPABILITY_BMISS_ENHANCE,
> 		     vif->ar->fw_capabilities))
> 	return;
> 
> 
> > +		ath6kl_dbg(ATH6KL_DBG_TRC, enable ? "enable fw bmiss enhance\n"
> > +						  : "");
> 
> ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s fw bmiss enhance\n",
> 		enable ? "enable" : "disable");
> 
> 
> > +		err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
> > +						       vif->fw_vif_idx, enable);
> > +		if (err)
> > +			ath6kl_dbg(ATH6KL_DBG_TRC,
> > +				   "failed to %s enhanced bmiss detection: %d\n",
> > +				   enable ? "set" : "disable",
> > +				   err);
> 
> Use WLAN_CFG here as well.
> 
> Kalle
