Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:31051 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZGYQJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 12:09:34 -0400
Received: by fg-out-1718.google.com with SMTP id e21so600927fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 09:09:34 -0700 (PDT)
Subject: Re: [PATCH] nl80211: add missing parameter clearing
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1248533676.19945.2.camel@johannes.local>
References: <1248533676.19945.2.camel@johannes.local>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 19:09:28 +0300
Message-Id: <1248538168.5338.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-07-25 at 16:54 +0200, Johannes Berg wrote:
> Jouni and Maxim reported an oops when using wpa_supplicant -Dnl80211,
> which seems to be due to random data being contained in the crypto
> settings for the assoc() command. This seems to be due to the missing
> memset here, so add it -- it's certainly missing but I'm not 100%
> certain that it will fix the problem.
Indeed this fixes it.
Although the NM still reports zero as signal level, and I see 

[  417.210115] No probe response from AP 00:1b:9e:d8:77:02 after 200ms,
disconnecting.
[  419.363655] wlan0: direct probe to AP 00:1b:9e:d8:77:02 (try 1)
[  419.369285] wlan0 direct probe responded
[  419.369292] wlan0: authenticate with AP 00:1b:9e:d8:77:02 (try 1)
[  419.371189] wlan0: authenticated
[  419.371513] wlan0: associate with AP 00:1b:9e:d8:77:02 (try 1)
[  419.374094] wlan0: RX AssocResp from 00:1b:9e:d8:77:02 (capab=0x411
status=0 aid=3)

Although it isn't visible any more.

Did wext compatibility layer got partially removed?
iwconfig does show now much

The last use of it, is to set tx power and bitrate, as this doesn't seem
to be implemented in iw.


Also NM applet doesn't show my network as connected. When I attempted to
connect it freezed the system.

Best regards,
	Maxim  Levitsky



> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/wireless/nl80211.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- wireless-testing.orig/net/wireless/nl80211.c	2009-07-25 16:50:39.000000000 +0200
> +++ wireless-testing/net/wireless/nl80211.c	2009-07-25 16:51:00.000000000 +0200
> @@ -3385,6 +3385,8 @@ static int nl80211_crypto_settings(struc
>  				   struct cfg80211_crypto_settings *settings,
>  				   int cipher_limit)
>  {
> +	memset(settings, 0, sizeof(*settings));
> +
>  	settings->control_port = info->attrs[NL80211_ATTR_CONTROL_PORT];
>  
>  	if (info->attrs[NL80211_ATTR_CIPHER_SUITES_PAIRWISE]) {
> 
> 

