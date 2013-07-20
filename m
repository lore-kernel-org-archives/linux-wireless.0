Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54948 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3GTTO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 15:14:27 -0400
Received: by mail-oa0-f48.google.com with SMTP id f4so7517745oah.35
        for <linux-wireless@vger.kernel.org>; Sat, 20 Jul 2013 12:14:27 -0700 (PDT)
Message-ID: <51EAE191.90401@lwfinger.net> (sfid-20130720_211431_317764_07614A18)
Date: Sat, 20 Jul 2013 14:14:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: thomas@fjellstrom.ca
CC: linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: wil6210 driver compilation failure
References: <6363399.uASIm9rubl@balsa>
In-Reply-To: <6363399.uASIm9rubl@balsa>
Content-Type: multipart/mixed;
 boundary="------------030605010201080004040401"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030605010201080004040401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

On 07/20/2013 01:37 PM, Thomas Fjellstrom wrote:
> Hi,
>
> Recently while trying to figure out a separate issue, I did a
> make allmodconfig and a make oldconfig with debian's default config on
> the 3.10.1 kernel, and debian's config with 3.10.0.
>
> It failed in the wil6210 driver.
>
> The system it failed on is running a fresh install of Debian Sid, with gcc
> 4.8.1.
>
> This is the error I got:
>
>    CC [M]  drivers/net/wireless/ath/wil6210/debugfs.o
> drivers/net/wireless/ath/wil6210/debugfs.c: In function âwil_print_ringâ:
> drivers/net/wireless/ath/wil6210/debugfs.c:163:11: error: pointer targets in passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-Werror=pointer-sign]
>             false);
>             ^
> In file included from include/linux/kernel.h:13:0,
>                   from include/linux/cache.h:4,
>                   from include/linux/time.h:4,
>                   from include/linux/stat.h:18,
>                   from include/linux/module.h:10,
>                   from drivers/net/wireless/ath/wil6210/debugfs.c:17:
> include/linux/printk.h:361:13: note: expected âchar *â but argument is of type âunsigned char *â
>   extern void hex_dump_to_buffer(const void *buf, size_t len,
>               ^
> drivers/net/wireless/ath/wil6210/debugfs.c: In function âwil_txdesc_debugfs_showâ:
> drivers/net/wireless/ath/wil6210/debugfs.c:429:10: error: pointer targets in passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-Werror=pointer-sign]
>            sizeof(printbuf), false);
>            ^
> In file included from include/linux/kernel.h:13:0,
>                   from include/linux/cache.h:4,
>                   from include/linux/time.h:4,
>                   from include/linux/stat.h:18,
>                   from include/linux/module.h:10,
>                   from drivers/net/wireless/ath/wil6210/debugfs.c:17:
> include/linux/printk.h:361:13: note: expected âchar *â but argument is of type âunsigned char *â
>   extern void hex_dump_to_buffer(const void *buf, size_t len,
>               ^
> cc1: all warnings being treated as errors
> make[5]: *** [drivers/net/wireless/ath/wil6210/debugfs.o] Error 1
> make[4]: *** [drivers/net/wireless/ath/wil6210] Error 2
> make[3]: *** [drivers/net/wireless/ath] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
>
> please excuse the mangled quotes, fresh install and I negelected to set up
> the locale properly. It's fixed now, but it seems I need to restart X for it to
> notice.

This error should be fixed by the attached patch. Please test.

Note that my system did not issue a warning for this "problem". It seems we have 
different warnings turned on in the compiler.

Larry



--------------030605010201080004040401
Content-Type: text/plain; charset=UTF-8;
 name="wil6210_compile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wil6210_compile"

Index: linux-2.6/drivers/net/wireless/ath/wil6210/debugfs.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/ath/wil6210/debugfs.c
+++ linux-2.6/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -145,7 +145,7 @@ static void wil_print_ring(struct seq_fi
 				   le16_to_cpu(hdr.type), hdr.flags);
 			if (len <= MAX_MBOXITEM_SIZE) {
 				int n = 0;
-				unsigned char printbuf[16 * 3 + 2];
+				char printbuf[16 * 3 + 2];
 				unsigned char databuf[MAX_MBOXITEM_SIZE];
 				void __iomem *src = wmi_buffer(wil, d.addr) +
 					sizeof(struct wil6210_mbox_hdr);

--------------030605010201080004040401--
