Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbbCWUZF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 16:25:05 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net
Subject: [PATCH v3 0/1] New driver: rtl8723au (mac80211)
Date: Mon, 23 Mar 2015 16:24:59 -0400
Message-Id: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20150323_212516_965203_312F2FF0)
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

v2 fixes an endian problem reported by Joe Perches, and adds a module
debug parameter so one doesn't have to recompile the driver to change
the debug mask (I was convinced I had that as a module parameter
already). The latter was suggested by Larry Finger.

v3 resolves the issues and suggestions provided by Johannes Berg to
the v2 patch. Discussing with Johannes we agreed it was cleaner to
keep the flow folling the BSS_CHANGED events rather than sticking it
into sta_state(). In addition I fixed cleaned up a couple of other
parts of the code.

There are still some debug portions and code that is #if 0'ed out. I
prefer to keep this in place for now as some of it is meant to be
enabled later, and other portions I use to match up tables and code to
the vendor driver when trying to trace issues when debugging.

The code is still work in progress, in particular I want to get AMPDU
for TX going, but it will be a little while before I get time to
address that.

Cheers,
Jes


Jes Sorensen (1):
  New driver: rtl8723au (mac80211)

 MAINTAINERS                          |    8 +
 drivers/net/wireless/Kconfig         |   19 +
 drivers/net/wireless/Makefile        |    2 +
 drivers/net/wireless/rtl8xxxu.c      | 4500 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtl8xxxu.h      |  497 ++++
 drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++
 6 files changed, 5967 insertions(+)
 create mode 100644 drivers/net/wireless/rtl8xxxu.c
 create mode 100644 drivers/net/wireless/rtl8xxxu.h
 create mode 100644 drivers/net/wireless/rtl8xxxu_regs.h

-- 
2.1.0

