Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:18847 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757602Ab0IHHFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 03:05:02 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0737259498
	for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2010 16:05:00 +0900 (JST)
Subject: [PATCH 0/8] ath: Move key cache functions to ath common
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Wed, 08 Sep 2010 16:04:28 +0900
Message-ID: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following series moves the key cache management functions from ath9k to
the common ath/key.c so we can also use them from ath5k. Both ath5k and
ath9k are changed to use the common key functions.

This is necessary since HW encryption in ath5k was broken for AP mode and
software encryption was enabled as a workaround (in "ath5k: temporarily
disable crypto for AP mode", 65b5a69860ed3bc4224368b804d381cd9cafa90a).
Using software encryption has a performance impact, which we would like to
avoid, especially on embedded boards, which is where AP configurations are
most common. On embedded AP boards we definetly want to make use of the
chipsets HW encryption.

The symptom of the broken HW encryption was that when two clients connected
to one AP with WPA (AES or TKIP) as soon as the second client connected, the
first one was not able to send or receive packets.

Rather than trying to fix the ath5k implementation, i think it makes more
sense to share this code between ath5k and ath9k.

This series was tested with ath5k (AR5414) in AP and station mode and with
ath9k 9160 in AP mode, both with TKIP and AES. ath9k_htc was compile tested
only.

bruno

---

Bruno Randolf (8):
      ath: Copy cryptographic capability flags into ath
      ath: Copy key cache management functions from ath9k to ath
      ath5k: Use common ath key management functions
      ath5k: Remove old ath5k key handling functions
      ath/ath9k: Replace common->splitmic with a flag
      ath5k: Use common crypt capabilities flags
      ath9k: Use common ath key management functions
      ath9k: Use common crypt capabilities flags


 drivers/net/wireless/ath/Makefile             |    3
 drivers/net/wireless/ath/ath.h                |   39 ++
 drivers/net/wireless/ath/ath5k/ath5k.h        |    7
 drivers/net/wireless/ath/ath5k/attach.c       |   13 -
 drivers/net/wireless/ath/ath5k/base.c         |   35 +-
 drivers/net/wireless/ath/ath5k/pcu.c          |  191 --------
 drivers/net/wireless/ath/ath5k/reg.h          |   42 --
 drivers/net/wireless/ath/ath9k/common.c       |  270 ------------
 drivers/net/wireless/ath/ath9k/common.h       |    6
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4
 drivers/net/wireless/ath/ath9k/hw.c           |  288 -------------
 drivers/net/wireless/ath/ath9k/hw.h           |   46 +-
 drivers/net/wireless/ath/ath9k/init.c         |    6
 drivers/net/wireless/ath/ath9k/mac.h          |   21 -
 drivers/net/wireless/ath/ath9k/main.c         |    4
 drivers/net/wireless/ath/ath9k/phy.h          |    3
 drivers/net/wireless/ath/key.c                |  568
+++++++++++++++++++++++++
 drivers/net/wireless/ath/reg.h                |   23 +
 19 files changed, 686 insertions(+), 885 deletions(-)
 create mode 100644 drivers/net/wireless/ath/key.c

--
