Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC51C282D8
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 01:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E76872148D
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 01:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfBBBR5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 20:17:57 -0500
Received: from relaygw2-20.mclink.it ([195.78.211.234]:48828 "EHLO
        relaygw2-20.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfBBBR5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 20:17:57 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2019 20:17:56 EST
Received: from smtpoutgw2.mclink.it ([172.24.30.42] verified)
  by relaygw2-20.mclink.it (CommuniGate Pro SMTP 6.0.4)
  with ESMTP id 144375177 for linux-wireless@vger.kernel.org; Sat, 02 Feb 2019 02:02:53 +0100
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BPCwCi61Rc/0WQy9VkHQEBHwUBDAGBS?=
 =?us-ascii?q?IICgVgShCqIeZAolRyBZw2HfiM4EgEDAQECAQECbSiFdEhKIQIRAYQDggUBqHC?=
 =?us-ascii?q?BL4oSEw+MV4FAP4N1hRcLWoI8glcComcJgTNAglGCAIwLkkCbe4FdISiBLk2DY?=
 =?us-ascii?q?IInF44fQYsPgksBAQ?=
Received: from adsl203-144-069.mclink.it (HELO afrodite.mst.cosmic-odyssey.net) ([213.203.144.69])
  by smtpoutgw2.mclink.it with ESMTP/TLS/AES256-GCM-SHA384; 02 Feb 2019 02:02:52 +0100
From:   Francesco Napoleoni <fnapoleoni@mclink.it>
To:     linux-wireless@vger.kernel.org
Subject: Compilation error in rtl8821ce driver and possible fix
Date:   Sat, 02 Feb 2019 02:02:46 +0100
Message-ID: <4491429.ZAENLmHWg6@afrodite.mst.cosmic-odyssey.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2183160.Dm167zZcW2"
Content-Transfer-Encoding: 7Bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart2183160.Dm167zZcW2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Hi

A few days ago I downloaded rtl8821ce wireless network driver from endlessm/
linux repository (master branch), and I managed to build module for kernel=
=20
4.19.16 on my Linux laptop, a HP 15-DB0035NL with an AMD Ryzen 5 2500U CPU.

When upgrading to kernel 4.20.5 I could not build the module anymore, the=20
compilation stopped with an error about the use of get_monotonic_boottime()=
=20
function, which apparently was deprecated and has been removed.

I=E2=80=99m no expert in kernel development, however I discovered that such=
 function=20
has been superseded by ktime_get_boottime_ts64(), and so I tried to use it =
in=20
place of get_monotonic_boottime(). The resulting code compiled correctly, a=
nd=20
the module seems to load and work without problem.

The code I changed is in the rtl8821ce/os_dep/linux/ioctl_cfg80211.c (lines=
=20
338-339), you can find a patchfile attached here.

Sorry for any mistake I may have done in this report, this is the first tim=
e I=20
do such a thing.

greetings
=46rancesco Napoleoni

--nextPart2183160.Dm167zZcW2
Content-Disposition: attachment; filename="ioctl_cfg80211.c.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="ioctl_cfg80211.c.patch"

--- ioctl_cfg80211.c.old	2019-02-02 01:15:41.407123709 +0100
+++ ioctl_cfg80211.c	2019-02-02 01:16:18.459536625 +0100
@@ -335,8 +335,8 @@
 static u64 rtw_get_systime_us(void)
 {
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 39))
-	struct timespec ts;
-	get_monotonic_boottime(&ts);
+	struct timespec64 ts;
+	ktime_get_boottime_ts64(&ts);
 	return ((u64)ts.tv_sec * 1000000) + ts.tv_nsec / 1000;
 #else
 	struct timeval tv;

--nextPart2183160.Dm167zZcW2--



