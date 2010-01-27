Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51401.mail.re2.yahoo.com ([206.190.38.180]:21622 "HELO
	web51401.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755417Ab0A0PvI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 10:51:08 -0500
Message-ID: <941694.35079.qm@web51401.mail.re2.yahoo.com>
Date: Wed, 27 Jan 2010 07:51:06 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: [PATCH] cfg80211: fix wext-compat for setting rate to 'auto'
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,
thanks for the quick response. The patch works fine for me. Feel free to add a

Tested-by: "Joerg Pommnitz" <pommnitz@yahoo.com>

-- 
Regards
       Joerg


--- John W. Linville <linville@tuxdriver.com> schrieb am Mi, 27.1.2010:

> Von: John W. Linville <linville@tuxdriver.com>
> Betreff: [PATCH] cfg80211: fix wext-compat for setting rate to 'auto'
> An: linux-wireless@vger.kernel.org
> CC: "Joerg Pommnitz" <pommnitz@yahoo.com>, "John W. Linville" <linville@tuxdriver.com>
> Datum: Mittwoch, 27. Januar 2010, 15:44
> Signed-off-by: John W. Linville
> <linville@tuxdriver.com>
> ---
> Haven't had a chance to test yet, but I suspect this fixes
> the issue...?
> 
>  net/wireless/wext-compat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/wext-compat.c
> b/net/wireless/wext-compat.c
> index 966d2f0..b17eeae 100644
> --- a/net/wireless/wext-compat.c
> +++ b/net/wireless/wext-compat.c
> @@ -1214,7 +1214,7 @@ int cfg80211_wext_siwrate(struct
> net_device *dev,
>  
>      memset(&mask, 0, sizeof(mask));
>      fixed = 0;
> -    maxrate = 0;
> +    maxrate = (u32)-1;
>  
>      if (rate->value < 0) {
>          /* nothing */
> -- 
> 1.6.2.5
> 
>


__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
