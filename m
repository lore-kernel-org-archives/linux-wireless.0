Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imr-ma06.mx.aol.com ([64.12.78.142]:58890 "EHLO
	imr-ma06.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZHBIbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 04:31:15 -0400
Message-ID: <4A754D31.7010709@netscape.net>
Date: Sun, 02 Aug 2009 02:24:17 -0600
From: Patrick Simmons <linuxrocks123@netscape.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	linux-wireless@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de
Subject: Re: [PATCH] Fix SPARC64 unaligned access in zd_mac_rx
References: <1249029583.29587.46.camel@johannes.local>	 <20090731.222350.254918321.davem@davemloft.net>	 <200908011240.17229.mb@bu3sch.de>	 <20090801.091207.217317135.davem@davemloft.net>	 <4A74EEB2.6040400@netscape.net> <1249199441.2007.7.camel@johannes.local>
In-Reply-To: <1249199441.2007.7.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Now the code is completely incorrect -- you're now loading the lower 16
> bits of the 'buffer' _pointer_ into the variable as an unaligned load.
>
> It really needs to be
>
> fc = get_unaligned((__le16 *)buffer);
>
> I think.
>
> johannes
>   

It does look wrong, now that I look at it further, but I'm pretty sure 
that what was happening was that only the lower 8 bits of the 
dereferenced value were being accessed.  What's odd is that it works on 
my machine, though.  Whatever.  Your version is clearer, in any case.

What follows is hopefully the last version of this patch.

Signed-off-by: Patrick Simmons <linuxrocks123@netscape.net>

--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -694,7 +694,7 @@
                        && !mac->pass_ctrl)
                return 0;
 
-       fc = *(__le16 *)buffer;
+       fc = get_unaligned((__le16*)buffer);
        need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
 
        skb = dev_alloc_skb(length + (need_padding ? 2 : 0));

--Patrick

