Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51073 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab1DXUms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 16:42:48 -0400
Received: by qyg14 with SMTP id 14so919659qyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 13:42:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303672484.14128.2.camel@maxim-laptop>
References: <BANLkTikBEs7aWZR+UovtpwYVPJfZjHEhgw@mail.gmail.com>
 <1303632949.3795.7.camel@jlt3.sipsolutions.net> <1303672484.14128.2.camel@maxim-laptop>
From: Matteo Croce <matteo@openwrt.org>
Date: Sun, 24 Apr 2011 22:42:07 +0200
Message-ID: <BANLkTikWr0xsOcrKAGF4EVF02Ji=7s3vHg@mail.gmail.com> (sfid-20110424_224251_796630_8990D743)
Subject: Re: [PATCH v2] 802.11n frame injection
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/24 Maxim Levitsky <maximlevitsky@gmail.com>:
> On Sun, 2011-04-24 at 10:15 +0200, Johannes Berg wrote:
>> On Fri, 2011-04-22 at 18:34 +0200, Matteo Croce wrote:
>> > This patch allows to set the tx rate and retries when injecting,
>> > and report correct MCS information on received frames.
>>
>> This description is wrong. It doesn't touch rx.c, does it?
>
> It does appear to touch radiotap processing, and I bet the developer
> tested this, but other than that don't know.
>
>>
>> johannes
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Best regards,
>        Maxim Levitsky
>
> Visit my blog: http://maximlevitsky.wordpress.com
> Warning: Above blog contains rants.
>
>

The old patch added RX processing but now all it's merged in mainline
and the only piece left in rx.c was:

--- a/net/mac80211/rx.c	2011-04-21 19:08:26.253148959 +0200
+++ b/net/mac80211/rx.c	2011-04-22 11:56:24.257134886 +0200
@@ -195,6 +195,7 @@
 	put_unaligned_le16(rx_flags, pos);
 	pos += 2;

+	/* IEEE80211_RADIOTAP_RATE_MCS */
 	if (status->flag & RX_FLAG_HT) {
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
 		*pos++ = IEEE80211_RADIOTAP_MCS_HAVE_MCS |


so I decided to remove this chunk, but I forget the original description

-- 
Matteo Croce
OpenWrt Developer
 _______                     ________        __
|       |.-----.-----.-----.|  |  |  |.----.|  |_
|   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
|_______||   __|_____|__|__||________||__|  |____|
         |__| W I R E L E S S   F R E E D O M
ATTITUDE ADJUSTMENT (bleeding edge) --------------
 * 1/4 oz Vodka      Pour all ingredents into mixing
 * 1/4 oz Gin        tin with ice, strain into glass.
 * 1/4 oz Amaretto
 * 1/4 oz Triple sec
 * 1/4 oz Peach schnapps
 * 1/4 oz Sour mix
 * 1 splash Cranberry juice
-----------------------------------------------------
