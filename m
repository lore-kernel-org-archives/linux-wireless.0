Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3197 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399Ab2FARxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 13:53:07 -0400
From: "Brett Rudley" <brudley@broadcom.com>
To: "Seth Forshee" <seth.forshee@canonical.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: "Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: RE: [PATCH 05/10] brcm80211: smac: remove DFS channels from
 5GHz band
Date: Fri, 1 Jun 2012 17:52:55 +0000
Message-ID: <2D7FF7D769509245B7AD0DB511D0FD3A17AB30@SJEXCHMB09.corp.ad.broadcom.com> (sfid-20120601_195313_051851_1BC3A475)
References: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
 <1338567336-12076-6-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1338567336-12076-6-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Not quite understanding this. Why does a STA need radar detection when the NO_IBSS flag is set?

Thanks
Brett

> -----Original Message-----
> From: Seth Forshee [mailto:seth.forshee@canonical.com]
> Sent: Friday, June 01, 2012 9:16 AM
> To: Arend Van Spriel; linux-wireless@vger.kernel.org
> Cc: Brett Rudley; Roland Vossen; Franky (Zhenhui) Lin; Kan Yan; Pieter-
> Paul Giesberts; John W. Linville
> Subject: [PATCH 05/10] brcm80211: smac: remove DFS channels from 5GHz
> band
> 
> brcmsmac doesn't currently support DFS or radar detection. Until it does
> we need to avoid using DFS channels, so for now remove them from the
> list of supported channels in the 5GHZ band.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   48 --------------
> ------
>  1 file changed, 48 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index 50f92a0..d2c0903 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -130,54 +130,6 @@ static struct ieee80211_channel
> brcms_5ghz_nphy_chantable[] = {
>  	CHAN5GHZ(40, IEEE80211_CHAN_NO_HT40PLUS),
>  	CHAN5GHZ(44, IEEE80211_CHAN_NO_HT40MINUS),
>  	CHAN5GHZ(48, IEEE80211_CHAN_NO_HT40PLUS),
> -	/* UNII-2 */
> -	CHAN5GHZ(52,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN |
> IEEE80211_CHAN_NO_HT40MINUS),
> -	CHAN5GHZ(56,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
> -	CHAN5GHZ(60,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN |
> IEEE80211_CHAN_NO_HT40MINUS),
> -	CHAN5GHZ(64,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
> -	/* MID */
> -	CHAN5GHZ(100,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN |
> IEEE80211_CHAN_NO_HT40MINUS),
> -	CHAN5GHZ(104,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
> -	CHAN5GHZ(108,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN |
> IEEE80211_CHAN_NO_HT40MINUS),
> -	CHAN5GHZ(112,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
> -	CHAN5GHZ(116,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN |
> IEEE80211_CHAN_NO_HT40MINUS),
> -	CHAN5GHZ(120,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
> -	CHAN5GHZ(124,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN |
> IEEE80211_CHAN_NO_HT40MINUS),
> -	CHAN5GHZ(128,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
> -	CHAN5GHZ(132,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN |
> IEEE80211_CHAN_NO_HT40MINUS),
> -	CHAN5GHZ(136,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
> -	CHAN5GHZ(140,
> -		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
> -		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS |
> -		 IEEE80211_CHAN_NO_HT40MINUS),
>  	/* UNII-3 */
>  	CHAN5GHZ(149, IEEE80211_CHAN_NO_HT40MINUS),
>  	CHAN5GHZ(153, IEEE80211_CHAN_NO_HT40PLUS),
> --
> 1.7.9.5
> 


