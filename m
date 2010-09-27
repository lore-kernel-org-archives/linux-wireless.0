Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38734 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0I0Ph2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 11:37:28 -0400
Received: by fxm3 with SMTP id 3so1914793fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 08:37:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: A few questions about modifications in carl9170
Date: Mon, 27 Sep 2010 17:37:16 +0200
Cc: linux-wireless@vger.kernel.org
References: <20100927132957.GA2977@qubit.lri.fr>
In-Reply-To: <20100927132957.GA2977@qubit.lri.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009271737.16603.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Monday 27 September 2010 15:29:57 Ignacy Gawedzki wrote:
> It's been now some time since I started hacking on drivers for the AR9170
> chipset based cards.  I initially wanted to enable wireless link capacity
> estimation (in terms of attainable throughput), based on the measurement of
> data frame service time.  In other words, I wanted to measure the time it
> takes the card to fully process each frame it receives from upper layers, from
> the instant it first considers the frame for transmission until the instant
> when the frame is considered processed (reception of ACK for unicast or end of
> transmission for multicast).
Sounds familiar, David H. Lynch Jr. <dhlii@dlasys.net> wanted to do the same,
on the same hardware with same software kit. But as far as I know he abandoned
the project because the hardware does support the RT interrupts he was
hoping for. 

> What I ended up doing was to modify the carl9170 firmware to enable the card
> itself to do the measurement and report that value back along the TX status.
> 
> The most important question is about struct carl9170_tx_status.  Is it safe to
> simply add a u32 duration field and update the CARL9170_TX_STATUS_SIZE to 6?
sure, I've just tested (on top of 1.8.8.2)

---
diff --git a/include/shared/fwcmd.h b/include/shared/fwcmd.h
index d4a4e1d..d7caa33 100644
--- a/include/shared/fwcmd.h
+++ b/include/shared/fwcmd.h
@@ -215,6 +215,8 @@ struct carl9170_tx_status {
 	u8 rix:2;
 	u8 tries:3;
 	u8 success:1;
+
+	u32 test;
 } __packed;
 struct _carl9170_tx_status {
 	/*
@@ -223,8 +225,10 @@ struct _carl9170_tx_status {
 
 	u8 cookie;
 	u8 info;
+
+	u32 test;
 } __packed;
-#define CARL9170_TX_STATUS_SIZE		2
+#define CARL9170_TX_STATUS_SIZE		6
 
 #define	CARL9170_RSP_TX_STATUS_NUM	(CARL9170_MAX_CMD_PAYLOAD_LEN /	\
 					 sizeof(struct _carl9170_tx_status))
---
without any problems. The device was able to connect and send a few gigs.
Maybe you should be a bit more "precise" about your changes ;).

> After quite some testing, it appears that as soon as I change the size of that
> struct, I start getting things like this (on any recent kernel with recent
> driver+firmware):
> 
> usb 1-1: no command feedback received (-110).
> carl9170 cmd: 08 01 00 00 f0 36 1c 00 00 24 00 00 .....6...$..
> usb 1-1: restart device (6)
> ieee80211 phy0: writing reg 0x1c36f0 (val 0x2400) failed (-110)
> usb 1-1: device restarted successfully.
too bad. The firmware obviously crashed but without any hints to
why...

> ------------[ cut here ]------------
> WARNING: at /build/buildd/linux-2.6.35/kernel/workqueue.c:495 flush_cpu_workqueue+0x7a/0x80()
> ...
> Modules linked in: carl9170 mac80211 led_class ath cfg80211 compat ...
> Call Trace:
> [<c014a812>] warn_slowpath_common+0x72/0xa0
> [<c016199a>] ? flush_cpu_workqueue+0x7a/0x80
> [<c016199a>] ? flush_cpu_workqueue+0x7a/0x80
> [<c014a862>] warn_slowpath_null+0x22/0x30
> [<c016199a>] flush_cpu_workqueue+0x7a/0x80
> [<c01620ee>] flush_workqueue+0x3e/0x60
> [<db90f699>] ieee80211_restart_hw+0x19/0x80 [mac80211]
> [<db872d92>] carl9170_restart_work+0xc2/0x150 [carl9170]
> [<c016155e>] run_workqueue+0x8e/0x150
> [<db872cd0>] ? carl9170_restart_work+0x0/0x150 [carl9170]
> [<c01616a4>] worker_thread+0x84/0xe0
> [<c0165920>] ? autoremove_wake_function+0x0/0x50
> [<c0161620>] ? worker_thread+0x0/0xe0
> [<c01654f4>] kthread+0x74/0x80
> [<c0165480>] ? kthread+0x0/0x80
> [<c010363e>] kernel_thread_helper+0x6/0x10
> --[ end trace 163c2ca4bc44c139 ]---
> 
> At first glance, it seems to be the result of a reentrant call of
> flush_workqueue.
Wait, wait wait 2.6.35? Every kernel before 2.6.35.2 (and a few other
-stable release) have a serious threading-bug in the usb subsystem.
I strongly recommend that you update your code-base to the
latest wireless-testing.

(Haven't seen the WARN before, kernel/workqueue.c code has changed a lot
and flush_cpu_workqueue is no more...)

Best regards,
	Christian
