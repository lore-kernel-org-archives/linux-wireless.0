Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp07.msg.oleane.net ([62.161.4.7]:54514 "EHLO
        smtp07.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751513AbdAYSUh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 13:20:37 -0500
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Vasanthakumar Thiagarajan'" <vthiagar@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>
References: <1485343870-23601-1-git-send-email-vthiagar@qti.qualcomm.com> <1485343870-23601-3-git-send-email-vthiagar@qti.qualcomm.com>
In-Reply-To: <1485343870-23601-3-git-send-email-vthiagar@qti.qualcomm.com>
Subject: RE: [RFC 2/3] cfg80211: Disallow moving out of operating DFS channel in non-ETSI
Date: Wed, 25 Jan 2017 19:20:31 +0100
Message-ID: <014301d27737$b693eca0$23bbc5e0$@acksys.fr> (sfid-20170125_192040_109942_1BE23184)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Message d'origine-----
> De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] De la part de Vasanthakumar Thiagarajan
> Envoyé : mercredi 25 janvier 2017 12:31
> À : johannes@sipsolutions.net
> Cc : linux-wireless@vger.kernel.org; Vasanthakumar Thiagarajan
> Objet : [RFC 2/3] cfg80211: Disallow moving out of operating DFS channel
> in non-ETSI
> 
> For non-ETSI regulatory domain, CAC result on DFS channel may not be valid
> once moving out of that channel (as done during remain-on-channel,
> scannning and off-channel tx).
> Running CAC on an operating DFS channel after every off-channel operation
> will only add complexity and disturb the current link. Better do not allow
> any off-channel switch from a DFS operating channel in non-ETSI domain.
> 

Moving out should be forbidden only to "master" devices i.e. AP, mesh,
ad-hoc.
"Slave" devices i.e. client stations, are not responsible for detecting
radars, hence, they can do an off-channel scan and go back to a "DFS
operating channel" without waiting for CAC.

It looks like your patch would forbid multichannel scan ?



> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> ---
>  net/wireless/nl80211.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c index
> 63dfa60..c614af4 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -6506,6 +6506,17 @@ static int nl80211_parse_random_mac(struct nlattr
> **attrs,
>  	return 0;
>  }
> 
> +static bool cfg80211_off_channel_oper_allowed(struct wireless_dev
> +*wdev) {
> +	if (!cfg80211_beaconing_iface_active(wdev))
> +		return true;
> +
> +	if (!(wdev->chandef.chan->flags & IEEE80211_CHAN_RADAR))
> +		return true;
> +
> +	return regulatory_pre_cac_allowed(wdev->wiphy);
> +}
> +
>  static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info
> *info)  {
>  	struct cfg80211_registered_device *rdev = info->user_ptr[0]; @@ -
> 6631,6 +6642,21 @@ static int nl80211_trigger_scan(struct sk_buff *skb,
> struct genl_info *info)
> 
>  	request->n_channels = i;
> 
> +	if (!cfg80211_off_channel_oper_allowed(wdev)) {
> +		struct ieee80211_channel *chan;
> +
> +		if (request->n_channels != 1) {
> +			err = -EBUSY;
> +			goto out_free;
> +		}
> +
> +		chan = request->channels[0];
> +		if (chan->center_freq != wdev->chandef.chan->center_freq) {
> +			err = -EBUSY;
> +			goto out_free;
> +		}
> +	}
> +
>  	i = 0;
>  	if (n_ssids) {
>  		nla_for_each_nested(attr, info-
> >attrs[NL80211_ATTR_SCAN_SSIDS], tmp) { @@ -9053,6 +9079,7 @@ static int
> nl80211_remain_on_channel(struct sk_buff *skb,
>  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>  	struct wireless_dev *wdev = info->user_ptr[1];
>  	struct cfg80211_chan_def chandef;
> +	const struct cfg80211_chan_def *compat_chandef;
>  	struct sk_buff *msg;
>  	void *hdr;
>  	u64 cookie;
> @@ -9081,6 +9108,14 @@ static int nl80211_remain_on_channel(struct sk_buff
> *skb,
>  	if (err)
>  		return err;
> 
> +	if (!(cfg80211_off_channel_oper_allowed(wdev) ||
> +	      cfg80211_chandef_identical(&wdev->chandef, &chandef))) {
> +		compat_chandef = cfg80211_chandef_compatible(&wdev->chandef,
> +							     &chandef);
> +		if (compat_chandef != &chandef)
> +			return -EBUSY;
> +	}
> +
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
>  		return -ENOMEM;
> @@ -9256,6 +9291,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb,
> struct genl_info *info)
>  	if (!chandef.chan && params.offchan)
>  		return -EINVAL;
> 
> +	if (params.offchan && !cfg80211_off_channel_oper_allowed(wdev))
> +		return -EBUSY;
> +
>  	params.buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
>  	params.len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
> 
> --
> 1.9.1
