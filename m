Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36546 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab0JAXNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 19:13:36 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 16:13:27 -0700
Date: Fri, 1 Oct 2010 16:13:33 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>, <devel@linuxdriverproject.org>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>
Subject: [PATCH 0/1] staging: good bye otus
Message-ID: <20101001231333.GA1847@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the otus drivers. This patch was based
on linux-next.git. The patch is likely too big for
linux-wireless to parse so you can download the
patch from this URL:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/staging/0001-staging-remove-the-Atheros-otus-vendor-driver.patch.gz
sha1sum: a354e487f83ab31e1d153d7fcbd27a8dc20d0ff4

Luis R. Rodriguez (1):
  staging: remove the Atheros otus vendor driver

 drivers/staging/Kconfig                        |    2 -
 drivers/staging/Makefile                       |    1 -
 drivers/staging/otus/80211core/amsdu.c         |  129 -
 drivers/staging/otus/80211core/cagg.c          | 3621 ---------------
 drivers/staging/otus/80211core/cagg.h          |  435 --
 drivers/staging/otus/80211core/ccmd.c          | 1766 -------
 drivers/staging/otus/80211core/cfunc.c         | 1226 -----
 drivers/staging/otus/80211core/cfunc.h         |  449 --
 drivers/staging/otus/80211core/chb.c           |  200 -
 drivers/staging/otus/80211core/cic.c           |  499 --
 drivers/staging/otus/80211core/cinit.c         | 1912 --------
 drivers/staging/otus/80211core/cmm.c           | 2183 ---------
 drivers/staging/otus/80211core/cmmap.c         | 2435 ----------
 drivers/staging/otus/80211core/cmmsta.c        | 5817 ------------------------
 drivers/staging/otus/80211core/coid.c          | 2696 -----------
 drivers/staging/otus/80211core/cprecomp.h      |   32 -
 drivers/staging/otus/80211core/cpsmgr.c        |  730 ---
 drivers/staging/otus/80211core/cscanmgr.c      |  533 ---
 drivers/staging/otus/80211core/ctkip.c         |  599 ---
 drivers/staging/otus/80211core/ctxrx.c         | 4115 -----------------
 drivers/staging/otus/80211core/cwep.c          |  299 --
 drivers/staging/otus/80211core/cwm.c           |  131 -
 drivers/staging/otus/80211core/cwm.h           |   45 -
 drivers/staging/otus/80211core/freqctrl.c      |  259 --
 drivers/staging/otus/80211core/ledmgr.c        |  556 ---
 drivers/staging/otus/80211core/performance.c   |  431 --
 drivers/staging/otus/80211core/performance.h   |   97 -
 drivers/staging/otus/80211core/pub_usb.h       |  102 -
 drivers/staging/otus/80211core/pub_zfi.h       |  820 ----
 drivers/staging/otus/80211core/pub_zfw.h       |   93 -
 drivers/staging/otus/80211core/queue.c         |  304 --
 drivers/staging/otus/80211core/queue.h         |   37 -
 drivers/staging/otus/80211core/ratectrl.c      |  867 ----
 drivers/staging/otus/80211core/ratectrl.h      |   37 -
 drivers/staging/otus/80211core/struct.h        | 1315 ------
 drivers/staging/otus/80211core/wlan.h          |  595 ---
 drivers/staging/otus/Kconfig                   |   34 -
 drivers/staging/otus/Makefile                  |   67 -
 drivers/staging/otus/TODO                      |    8 -
 drivers/staging/otus/apdbg.c                   |  379 --
 drivers/staging/otus/athr_common.h             |  141 -
 drivers/staging/otus/hal/hpDKfwu.c             |  832 ----
 drivers/staging/otus/hal/hpani.c               |  721 ---
 drivers/staging/otus/hal/hpani.h               |  419 --
 drivers/staging/otus/hal/hpfw2.c               | 1018 -----
 drivers/staging/otus/hal/hpfwbu.c              | 5269 ---------------------
 drivers/staging/otus/hal/hpfwspiu.c            |  655 ---
 drivers/staging/otus/hal/hpfwu.c               | 1017 -----
 drivers/staging/otus/hal/hpfwu.c.drv_ba_resend |  742 ---
 drivers/staging/otus/hal/hpfwu_2k.c            | 1016 -----
 drivers/staging/otus/hal/hpfwu_BA.c            |  874 ----
 drivers/staging/otus/hal/hpfwu_FB50_mdk.c      |  721 ---
 drivers/staging/otus/hal/hpfwu_OTUS_RC.c       |  715 ---
 drivers/staging/otus/hal/hpfwu_txstream.c      | 1017 -----
 drivers/staging/otus/hal/hpfwuinit.c           |  240 -
 drivers/staging/otus/hal/hpmain.c              | 4672 -------------------
 drivers/staging/otus/hal/hpreg.c               | 2270 ---------
 drivers/staging/otus/hal/hpreg.h               |  524 ---
 drivers/staging/otus/hal/hprw.c                | 1568 -------
 drivers/staging/otus/hal/hpusb.c               | 1589 -------
 drivers/staging/otus/hal/hpusb.h               |  437 --
 drivers/staging/otus/hal/otus.ini              |  414 --
 drivers/staging/otus/ioctl.c                   | 2753 -----------
 drivers/staging/otus/oal_dt.h                  |   60 -
 drivers/staging/otus/oal_marc.h                |  143 -
 drivers/staging/otus/usbdrv.c                  | 1143 -----
 drivers/staging/otus/usbdrv.h                  |  245 -
 drivers/staging/otus/wrap_buf.c                |  111 -
 drivers/staging/otus/wrap_dbg.c                |   95 -
 drivers/staging/otus/wrap_ev.c                 |  285 --
 drivers/staging/otus/wrap_mem.c                |  105 -
 drivers/staging/otus/wrap_mis.c                |  103 -
 drivers/staging/otus/wrap_pkt.c                |  147 -
 drivers/staging/otus/wrap_sec.c                |  125 -
 drivers/staging/otus/wrap_usb.c                |  187 -
 drivers/staging/otus/wwrap.c                   | 1048 -----
 drivers/staging/otus/zdcompat.h                |   45 -
 drivers/staging/otus/zdusb.c                   |  226 -
 drivers/staging/otus/zdusb.h                   |   47 -
 79 files changed, 0 insertions(+), 69595 deletions(-)
 delete mode 100644 drivers/staging/otus/80211core/amsdu.c
 delete mode 100644 drivers/staging/otus/80211core/cagg.c
 delete mode 100644 drivers/staging/otus/80211core/cagg.h
 delete mode 100644 drivers/staging/otus/80211core/ccmd.c
 delete mode 100644 drivers/staging/otus/80211core/cfunc.c
 delete mode 100644 drivers/staging/otus/80211core/cfunc.h
 delete mode 100644 drivers/staging/otus/80211core/chb.c
 delete mode 100644 drivers/staging/otus/80211core/cic.c
 delete mode 100644 drivers/staging/otus/80211core/cinit.c
 delete mode 100644 drivers/staging/otus/80211core/cmm.c
 delete mode 100644 drivers/staging/otus/80211core/cmmap.c
 delete mode 100644 drivers/staging/otus/80211core/cmmsta.c
 delete mode 100644 drivers/staging/otus/80211core/coid.c
 delete mode 100644 drivers/staging/otus/80211core/cprecomp.h
 delete mode 100644 drivers/staging/otus/80211core/cpsmgr.c
 delete mode 100644 drivers/staging/otus/80211core/cscanmgr.c
 delete mode 100644 drivers/staging/otus/80211core/ctkip.c
 delete mode 100644 drivers/staging/otus/80211core/ctxrx.c
 delete mode 100644 drivers/staging/otus/80211core/cwep.c
 delete mode 100644 drivers/staging/otus/80211core/cwm.c
 delete mode 100644 drivers/staging/otus/80211core/cwm.h
 delete mode 100644 drivers/staging/otus/80211core/freqctrl.c
 delete mode 100644 drivers/staging/otus/80211core/ledmgr.c
 delete mode 100644 drivers/staging/otus/80211core/performance.c
 delete mode 100644 drivers/staging/otus/80211core/performance.h
 delete mode 100644 drivers/staging/otus/80211core/pub_usb.h
 delete mode 100644 drivers/staging/otus/80211core/pub_zfi.h
 delete mode 100644 drivers/staging/otus/80211core/pub_zfw.h
 delete mode 100644 drivers/staging/otus/80211core/queue.c
 delete mode 100644 drivers/staging/otus/80211core/queue.h
 delete mode 100644 drivers/staging/otus/80211core/ratectrl.c
 delete mode 100644 drivers/staging/otus/80211core/ratectrl.h
 delete mode 100644 drivers/staging/otus/80211core/struct.h
 delete mode 100644 drivers/staging/otus/80211core/wlan.h
 delete mode 100644 drivers/staging/otus/Kconfig
 delete mode 100644 drivers/staging/otus/Makefile
 delete mode 100644 drivers/staging/otus/TODO
 delete mode 100644 drivers/staging/otus/apdbg.c
 delete mode 100644 drivers/staging/otus/athr_common.h
 delete mode 100644 drivers/staging/otus/hal/hpDKfwu.c
 delete mode 100644 drivers/staging/otus/hal/hpani.c
 delete mode 100644 drivers/staging/otus/hal/hpani.h
 delete mode 100644 drivers/staging/otus/hal/hpfw2.c
 delete mode 100644 drivers/staging/otus/hal/hpfwbu.c
 delete mode 100644 drivers/staging/otus/hal/hpfwspiu.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu.c.drv_ba_resend
 delete mode 100644 drivers/staging/otus/hal/hpfwu_2k.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu_BA.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu_FB50_mdk.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu_OTUS_RC.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu_txstream.c
 delete mode 100644 drivers/staging/otus/hal/hpfwuinit.c
 delete mode 100644 drivers/staging/otus/hal/hpmain.c
 delete mode 100644 drivers/staging/otus/hal/hpreg.c
 delete mode 100644 drivers/staging/otus/hal/hpreg.h
 delete mode 100644 drivers/staging/otus/hal/hprw.c
 delete mode 100644 drivers/staging/otus/hal/hpusb.c
 delete mode 100644 drivers/staging/otus/hal/hpusb.h
 delete mode 100644 drivers/staging/otus/hal/otus.ini
 delete mode 100644 drivers/staging/otus/ioctl.c
 delete mode 100644 drivers/staging/otus/oal_dt.h
 delete mode 100644 drivers/staging/otus/oal_marc.h
 delete mode 100644 drivers/staging/otus/usbdrv.c
 delete mode 100644 drivers/staging/otus/usbdrv.h
 delete mode 100644 drivers/staging/otus/wrap_buf.c
 delete mode 100644 drivers/staging/otus/wrap_dbg.c
 delete mode 100644 drivers/staging/otus/wrap_ev.c
 delete mode 100644 drivers/staging/otus/wrap_mem.c
 delete mode 100644 drivers/staging/otus/wrap_mis.c
 delete mode 100644 drivers/staging/otus/wrap_pkt.c
 delete mode 100644 drivers/staging/otus/wrap_sec.c
 delete mode 100644 drivers/staging/otus/wrap_usb.c
 delete mode 100644 drivers/staging/otus/wwrap.c
 delete mode 100644 drivers/staging/otus/zdcompat.h
 delete mode 100644 drivers/staging/otus/zdusb.c
 delete mode 100644 drivers/staging/otus/zdusb.h

