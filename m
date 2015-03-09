Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147AbbCIRB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 13:01:56 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH v2 0/1] New driver: rtl8723au (mac80211)
Date: Mon,  9 Mar 2015 13:00:52 -0400
Message-Id: <1425920453-25099-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20150309_180201_277617_5854D43E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This is a new driver for the rtl8723au which was written from scratch,
to utilize the Linux mac80211 stack.

This has been a pet project for me for some time I finally feel it
is stable enough to submit. I have used it for a while without any
serious issues.

I started working on cleaning up the vendor provided driver in
staging/rtl8723au over a year ago. After spending 6 months on it, it
became obvious to me that it was a rather hopeless task, and I started
writing this driver from scratch. I do not have any specs for the
chip, so everything is based on knowledge I obtained from dissecting
the vendor driver.

Special thanks to Larry Finger for help with the original rtl8723au
driver, and Johannes Berg for answering all my silly questions about
802.11 innards and the mac80211 stack. Had I known then what I know
today about 802.11, I probably would never have so mad as to start
this project in the first place!

v2 of the patch fixes the endian problem reported by Joe Perches, and
adds a module debug parameter so one doesn't have to recompile the
driver to change the debug mask (I was convinced I had that as a
module parameter already). The latter was suggested by Larry Finger.

In addition I fixed up a few cases of trailing whitespaces, a few
indentation issues, and a few workarounds to reduce the scriptkiddies
complaining about checkpatch warnings. I did run checkpatch on this
one, and there are zero legitimate warnings left that needs to be
dealt with.

There are still some debug portions and code that is #if 0'ed out. I
prefer to keep this in place for now as some of it is meant to be
enabled later, and other portions I use to match up tables and code to
the vendor driver when trying to trace issues when debugging.

Cheers,
Jes


Jes Sorensen (1):
  New driver: rtl8723au (mac80211)

 MAINTAINERS                          |    9 +
 drivers/net/wireless/Kconfig         |   19 +
 drivers/net/wireless/Makefile        |    2 +
 drivers/net/wireless/rtl8xxxu.c      | 4502 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtl8xxxu.h      |  494 ++++
 drivers/net/wireless/rtl8xxxu_regs.h |  940 +++++++
 6 files changed, 5966 insertions(+)
 create mode 100644 drivers/net/wireless/rtl8xxxu.c
 create mode 100644 drivers/net/wireless/rtl8xxxu.h
 create mode 100644 drivers/net/wireless/rtl8xxxu_regs.h

-- 
2.1.0

