Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:41158 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab1GMBc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 21:32:57 -0400
Subject: [PATCH 00/24] ath6kl cleaned up driver
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, gregkh@suse.de, error27@gmail.com
Date: Wed, 13 Jul 2011 04:32:44 +0300
Message-ID: <20110713013023.8517.15940.stgit@localhost6.localdomain6> (sfid-20110713_033300_460336_D99D5333)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

last May we started working on cleaning up ath6kl driver which is
currently in staging. The work has happened in a separate
ath6kl-cleanup tree:

http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl-cleanup.git;a=summary

After over 1100 (!) patches we have now reached a state where I would
like to start discussing about pushing the driver to the wireless
trees and replacing the staging driver.

The driver is now a lot smaller and looks like a proper Linux driver.
For example, I'm now a lot more comfortable working with this driver
than the staging driver. The size of the driver (measured with simple
wc -l) dropped from 49 kLOC to 19 kLOC and the number of the .c and .h
files dropped from 107 to 23. Most importantly the number of
subdirectories reduced from 26 to zero :)

There are two remaining checkpatch warnings in the driver which we
decided to omit for now:

drivers/net/wireless/ath/ath6kl/debug.c:31: 
  WARNING: printk() should include KERN_ facility level
drivers/net/wireless/ath/ath6kl/sdio.c:527: 
  WARNING: msleep < 20ms can sleep for up to 20ms; 
  see Documentation/timers/timers-howto.txt

The driver has endian annotations for all the hardware specific
structures and there are no sparse errors. Unfortunately I don't have
any big endian hardware to test that but we are trying find something.

We have been testing the driver both on x86 and arm platforms. The
code is also compiled with sparc and parisc cross compilers.

Notable missing features compared to the current staging driver are:

o HCI over SDIO support
o nl80211 testmode
o firmware logging

Testmode and firmware logging will be added soon. HCI over SDIO
support will be more difficult as the HCI driver needs to share code
with the wifi driver. This is something we need to research more.

Even we have done a lot of cleanup, it's still not fully finished. The
todo list is available here:

http://wireless.kernel.org/en/users/Drivers/ath6kl/todo

The most important tasks left are:

o proper review of locking (currently 13 spin locks and one semaphore)
o excessive use of void pointers

But I think these cleanups can happen in wireless-testing tree as
well. There is no need to keep the driver out-of-tree anymore as the
changes should be pretty small compared to the changes we had until
now.

Also I want to point out the changes I did for signed endian support.
As I wasn't able to find any support for signed endian annotations I
decided to follow what NTFS has done and added my own. Grep for sle16
and sle32, especially from wmi.h.

Various people have been working on the cleanup, the hall of
fame based on number of patches is:

   532  Vasanthakumar Thiagarajan
   354  Raja Mani
   224  Kalle Valo
    16  Vivek Natarajan
    12  Suraj Sumangala
     2  Jouni Malinen

I'm sending the patch in multiple emails, one file per message, to
make it easier to review. During the final inclusion I can send the
driver as one patch (if that's preferred).

Please review and comment.

Kalle

---

Kalle Valo (24):
      ath6kl: add bmi.c
      ath6kl: add bmi.h
      ath6kl: add cfg80211.c
      ath6kl: add cfg80211.h
      ath6kl: add common.h
      ath6kl: add core.h
      ath6kl: add debug.c
      ath6kl: add debug.h
      ath6kl: add hif-ops.h
      ath6kl: add hif.h
      ath6kl: add htc.c
      ath6kl: add htc.h
      ath6kl: add htc_hif.c
      ath6kl: add htc_hif.h
      ath6kl: add ieee80211.h
      ath6kl: add init.c
      ath6kl: add main.c
      ath6kl: add node.c
      ath6kl: add sdio.c
      ath6kl: add target.h
      ath6kl: add txrx.c
      ath6kl: add wmi.c
      ath6kl: add wmi.h
      ath6kl: add Kconfig and Makefile


 drivers/net/wireless/ath/Kconfig            |    1 
 drivers/net/wireless/ath/Makefile           |    1 
 drivers/net/wireless/ath/ath6kl/Kconfig     |   17 
 drivers/net/wireless/ath/ath6kl/Makefile    |   35 
 drivers/net/wireless/ath/ath6kl/bmi.c       |  692 ++++++
 drivers/net/wireless/ath/ath6kl/bmi.h       |  250 ++
 drivers/net/wireless/ath/ath6kl/cfg80211.c  | 1641 +++++++++++++++
 drivers/net/wireless/ath/ath6kl/cfg80211.h  |   39 
 drivers/net/wireless/ath/ath6kl/common.h    |  163 +
 drivers/net/wireless/ath/ath6kl/core.h      |  518 +++++
 drivers/net/wireless/ath/ath6kl/debug.c     |  151 +
 drivers/net/wireless/ath/ath6kl/debug.h     |  103 +
 drivers/net/wireless/ath/ath6kl/hif-ops.h   |   67 +
 drivers/net/wireless/ath/ath6kl/hif.h       |  214 ++
 drivers/net/wireless/ath/ath6kl/htc.c       | 2506 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/htc.h       |  592 +++++
 drivers/net/wireless/ath/ath6kl/htc_hif.c   |  813 +++++++
 drivers/net/wireless/ath/ath6kl/htc_hif.h   |  112 +
 drivers/net/wireless/ath/ath6kl/ieee80211.h |  158 +
 drivers/net/wireless/ath/ath6kl/init.c      | 1315 ++++++++++++
 drivers/net/wireless/ath/ath6kl/main.c      | 1337 ++++++++++++
 drivers/net/wireless/ath/ath6kl/node.c      |  239 ++
 drivers/net/wireless/ath/ath6kl/sdio.c      |  857 ++++++++
 drivers/net/wireless/ath/ath6kl/target.h    |  331 +++
 drivers/net/wireless/ath/ath6kl/txrx.c      | 1471 +++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c       | 2969 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h       | 2049 +++++++++++++++++++
 27 files changed, 18641 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath6kl/Makefile
 create mode 100644 drivers/net/wireless/ath/ath6kl/bmi.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/bmi.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/cfg80211.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/cfg80211.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/common.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/core.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/debug.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/debug.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/hif-ops.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/hif.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_hif.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_hif.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/ieee80211.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/init.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/main.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/node.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/sdio.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/target.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/txrx.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/wmi.h

