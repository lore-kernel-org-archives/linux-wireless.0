Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34894 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab0C2XBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 19:01:31 -0400
Received: by mail-pw0-f46.google.com with SMTP id 5so7149816pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 16:01:31 -0700 (PDT)
Message-ID: <4BB13147.9020002@lwfinger.net>
Date: Mon, 29 Mar 2010 18:01:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
References: <4BB0FD96.5020402@lwfinger.net> <4BB10110.9090202@googlemail.com> <20100329194745.GH4984@tuxdriver.com> <4BB10A0F.1030608@lwfinger.net> <20100329204822.GL4984@tuxdriver.com> <20100329205558.GM4984@tuxdriver.com> <4BB11B8E.1020506@lwfinger.net> <4BB12148.7080309@googlemail.com>
In-Reply-To: <4BB12148.7080309@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

René and John,

What output does this patch yield?


Index: wireless-testing/drivers/ssb/sprom.c
===================================================================
--- wireless-testing.orig/drivers/ssb/sprom.c
+++ wireless-testing/drivers/ssb/sprom.c
@@ -182,6 +182,11 @@ bool ssb_is_sprom_available(struct ssb_b
 	if (bus->chipco.dev->id.revision < 11)
 		return true;

+	printk(KERN_INFO "ssb: chip_id 0x%x, status 0x%x\n", bus->chip_id,
+			  bus->chipco.status);
+	printk(KERN_INFO "ssb: cc rev 0x%x, cc capab 0x%x\n",
+			  bus->chipco.dev->id.revision,
+			  bus->chipco.capabilities);
 	switch (bus->chip_id) {
 	case 0x4312:
 		return SSB_CHIPCO_CHST_4312_SPROM_PRESENT(bus->chipco.status);


