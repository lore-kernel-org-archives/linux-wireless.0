Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36006 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbcETHmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 03:42:47 -0400
Received: by mail-pf0-f169.google.com with SMTP id c189so40004678pfb.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2016 00:42:46 -0700 (PDT)
Subject: Re: [PATCH 4.8 2/2] brcmfmac: support get_channel cfg80211 callback
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1463655770-22467-1-git-send-email-zajec5@gmail.com>
 <1463655770-22467-2-git-send-email-zajec5@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <48f4f8c9-b4a3-66f9-b4a5-640778ac8e79@broadcom.com> (sfid-20160520_094307_450952_0BE88AC2)
Date: Fri, 20 May 2016 09:42:37 +0200
MIME-Version: 1.0
In-Reply-To: <1463655770-22467-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-5-2016 13:02, Rafał Miłecki wrote:
> This is important for brcmfmac as the firmware may pick different
> channel than requested. This has been tested with BCM4366B1 (in D-Link
> DIR-885L).

Can you elaborate? Is this for AP or STA mode?

> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 59 ++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 597495d..4fb9e3a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -4892,6 +4892,64 @@ exit:
>  	return err;
>  }
>  
> +static int brcmf_cfg80211_get_channel(struct wiphy *wiphy,
> +				      struct wireless_dev *wdev,
> +				      struct cfg80211_chan_def *chandef)
> +{
> +	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
> +	struct net_device *ndev = wdev->netdev;
> +	struct brcmf_if *ifp = netdev_priv(ndev);

Can this operation be done on a P2P_DEVICE interface, ie. wdev->netdev
== NULL?

> +	struct brcmu_chan ch;
> +	enum nl80211_band band = 0;
> +	enum nl80211_chan_width width = 0;
> +	u32 chanspec;
> +	int freq, err;
> +
> +	err = brcmf_fil_iovar_int_get(ifp, "chanspec", &chanspec);
> +	if (err) {
> +		brcmf_err("chanspec failed (%d)\n", err);
> +		return err;
> +	}
> +
> +	ch.chspec = chanspec;
> +	cfg->d11inf.decchspec(&ch);
> +
> +	switch (ch.band) {
> +	case BRCMU_CHAN_BAND_2G:
> +		band = NL80211_BAND_2GHZ;
> +		break;
> +	case BRCMU_CHAN_BAND_5G:
> +		band = NL80211_BAND_5GHZ;
> +		break;
> +	}
> +
> +	switch (ch.bw) {
> +	case BRCMU_CHAN_BW_80:
> +		width = NL80211_CHAN_WIDTH_80;
> +		break;
> +	case BRCMU_CHAN_BW_40:
> +		width = NL80211_CHAN_WIDTH_40;
> +		break;
> +	case BRCMU_CHAN_BW_20:
> +		width = NL80211_CHAN_WIDTH_20;
> +		break;
> +	case BRCMU_CHAN_BW_80P80:
> +		width = NL80211_CHAN_WIDTH_80P80;
> +		break;

Not much sense to support this given that center_freq2 is set to zero below.

Regards,
Arend

> +	case BRCMU_CHAN_BW_160:
> +		width = NL80211_CHAN_WIDTH_160;
> +		break;
> +	}
> +
> +	freq = ieee80211_channel_to_frequency(ch.control_ch_num, band);
> +	chandef->chan = ieee80211_get_channel(wiphy, freq);
> +	chandef->width = width;
> +	chandef->center_freq1 = ieee80211_channel_to_frequency(ch.chnum, band);
> +	chandef->center_freq2 = 0;
> +
> +	return 0;
> +}
> +
>  static int brcmf_cfg80211_crit_proto_start(struct wiphy *wiphy,
>  					   struct wireless_dev *wdev,
>  					   enum nl80211_crit_proto_id proto,
> @@ -5054,6 +5112,7 @@ static struct cfg80211_ops brcmf_cfg80211_ops = {
>  	.mgmt_tx = brcmf_cfg80211_mgmt_tx,
>  	.remain_on_channel = brcmf_p2p_remain_on_channel,
>  	.cancel_remain_on_channel = brcmf_cfg80211_cancel_remain_on_channel,
> +	.get_channel = brcmf_cfg80211_get_channel,
>  	.start_p2p_device = brcmf_p2p_start_device,
>  	.stop_p2p_device = brcmf_p2p_stop_device,
>  	.crit_proto_start = brcmf_cfg80211_crit_proto_start,
> 
