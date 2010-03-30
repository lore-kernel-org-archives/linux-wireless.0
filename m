Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:47101 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0C3PX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 11:23:58 -0400
Received: by iwn12 with SMTP id 12so1407483iwn.21
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 08:23:55 -0700 (PDT)
Message-ID: <4BB21787.4040501@lwfinger.net>
Date: Tue, 30 Mar 2010 10:23:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Your netbook
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

If possible, I would like you to do one more test on that troublesome netbook.
Please build a kernel with CONFIG_MMIOTRACE=y and build the Broadcom wl driver
for it. Starting with wl unloaded, issue the following commands (as root):

echo 10000 > /sys/kernel/debug/tracing/buffer_size_kb
echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
cat /sys/kernel/debug/tracing/trace_pipe > wl_dump.txt &
modprobe -v wl

After the wireless network device gets created, etc., then

echo nop > /sys/kernel/debug/tracing/current_tracer
sleep 1
killproc cat

and send me the file wl_dump.txt. With it, I will be able to see if the Broadcom
driver is actually finding an SPROM that b43 is missing.

Thanks,

Larry


