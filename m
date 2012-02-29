Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40101 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab2B2RS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:18:27 -0500
Subject: [PATCH 00/12] ath6kl: checkpatch fixes
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:18:18 +0200
Message-ID: <20120229171525.24264.22062.stgit@localhost6.localdomain6> (sfid-20120229_181830_752738_30E844AD)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are quite a few checkpatch fixes and other cleanups.

Especially I would like to people review these two macros, they ended up
a bit too clever and I'm sure there are issues:

#define ath6kl_bmi_write_hi32(ar, item, val)				\
	({								\
		u32 addr;						\
		__le32 v;						\
									\
		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
		v = cpu_to_le32(val);					\
		ath6kl_bmi_write(ar, addr, (u8 *) &v, sizeof(v));	\
	})

#define ath6kl_bmi_read_hi32(ar, item, val)				\
	({								\
		u32 addr, *check_type = val;				\
		__le32 tmp;						\
		int ret;						\
									\
		(void) (check_type == val);				\
		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
		ret = ath6kl_bmi_read(ar, addr, (u8 *) &tmp, 4);	\
		*val = le32_to_cpu(tmp);				\
		ret;							\
	})

---

Kalle Valo (12):
      ath6kl: fix pointer style
      ath6kl: fix checkpatch error with EPSTAT() macro
      ath6kl: alignment should match open parenthesis
      ath6kl: logical continuations should be on the previous line
      ath6kl: remove multiple assignments
      ath6kl: add ath6kl_bmi_write_hi32()
      ath6kl: add ath6kl_bmi_read_hi32()
      ath6kl: fix error handling ath6kl_target_config_wlan_params()
      ath6kl: fix open paranthesis alignment in ath6kl_cfg80211_connect()
      ath6kl: document all spinlocks
      ath6kl: fix too long lines
      ath6kl: make ath6kl_bmi_[read|write]_hi32() endian safe


 drivers/net/wireless/ath/ath6kl/bmi.c      |    6 -
 drivers/net/wireless/ath/ath6kl/bmi.h      |   23 +++
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   46 ++++--
 drivers/net/wireless/ath/ath6kl/core.c     |    6 -
 drivers/net/wireless/ath/ath6kl/core.h     |   25 +++
 drivers/net/wireless/ath/ath6kl/debug.c    |   58 ++++----
 drivers/net/wireless/ath/ath6kl/hif.c      |    6 -
 drivers/net/wireless/ath/ath6kl/hif.h      |    1 
 drivers/net/wireless/ath/ath6kl/htc.c      |  105 +++++++-------
 drivers/net/wireless/ath/ath6kl/htc.h      |    7 +
 drivers/net/wireless/ath/ath6kl/init.c     |  203 ++++++++++------------------
 drivers/net/wireless/ath/ath6kl/main.c     |   22 ++-
 drivers/net/wireless/ath/ath6kl/sdio.c     |   11 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |   18 +-
 drivers/net/wireless/ath/ath6kl/wmi.c      |   31 ++--
 drivers/net/wireless/ath/ath6kl/wmi.h      |    6 +
 16 files changed, 295 insertions(+), 279 deletions(-)

