Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2033 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab0JURLH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 13:11:07 -0400
Date: Thu, 21 Oct 2010 10:10:55 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Greg KH" <greg@kroah.com>
cc: "Nohee Ko" <noheek@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"grundler@google.com" <grundler@google.com>,
	linux-wireless@vger.kernel.org, dwmw2@infradead.org
Subject: Subject: [PATCH] staging: brcm80211: brcmfmac: Removed
 codeversion from firmware filenames.
Message-ID: <20101021171054.GB15357@broadcom.com>
References: <4CBE23F4.4020104@broadcom.com>
 <20101019233520.GA12510@kroah.com>
 <FD96C117992C584DBC47231B1EB6F5568206D859DC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20101020004743.GB31965@kroah.com>
 <20101020005546.GL10832@broadcom.com> <20101020010320.GA370@kroah.com>
MIME-Version: 1.0
In-Reply-To: <20101020010320.GA370@kroah.com>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The basename-apiversion-codeversion construction for firmware filenames is not
used by most other firmware files, adds complexity, and is not providing any
value.  Rename the firmware files using just basename-apiversion.

Users of the brcmfmac driver will need to update the linux-firmware package
to get the renamed files, or manually rename their installed firmware files.
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 621521b..7f00bc4 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -54,8 +54,8 @@ static struct wl_dev *wl_cfg80211_dev;
 
 u32 wl_dbg_level = WL_DBG_ERR | WL_DBG_INFO;
 
-#define WL_4329_FW_FILE "brcm/bcm4329-fullmac-4-218-248-5.bin"
-#define WL_4329_NVRAM_FILE "brcm/bcm4329-fullmac-4-218-248-5.txt"
+#define WL_4329_FW_FILE "brcm/bcm4329-fullmac-4.bin"
+#define WL_4329_NVRAM_FILE "brcm/bcm4329-fullmac-4.txt"
 
 /*
 ** cfg80211_ops api/callback list
-- 
1.7.1


