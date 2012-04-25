Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3714 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab2DYOIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 10:08:34 -0400
Message-ID: <4F980551.3070204@broadcom.com> (sfid-20120425_160838_369019_6F1DCB68)
Date: Wed, 25 Apr 2012 16:08:17 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Rajkumar Manoharan" <rmanohar@qca.qualcomm.com>
cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: fix rate control update on 2040 bss change
References: <1335358909-24905-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1335358909-24905-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2012 03:01 PM, Rajkumar Manoharan wrote:
> The rate control updatation never be called on 2040 BSS change.

'updatation' == typo?

> The station should update its rate control on receiving beacon
> with different HT mode in the HT operation IE. Not doing so,
> leads to sending frames with higher(ht40) rates whereas AP is
> running in lower mode (ht20).
>
> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> ---
>   net/mac80211/mlme.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c8836fa..56128d3 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -210,7 +210,7 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
>   		disable_40 = true;
>
>   	if (sta&&  (!reconfig ||
> -		    (disable_40 != !!(sta->sta.ht_cap.cap&
> +		    (disable_40 == !!(sta->sta.ht_cap.cap&
>   					IEEE80211_HT_CAP_SUP_WIDTH_20_40)))) {
>
>   		if (disable_40)


