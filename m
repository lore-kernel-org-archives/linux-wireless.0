Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57865 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbYJHUyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 16:54:22 -0400
Date: Wed, 8 Oct 2008 16:53:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2008-10-08
Message-ID: <20081008205342.GF32472@tuxdriver.com> (sfid-20081008_225437_223523_01A453B4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

Here is one more that I think is worth sending for 2.6.27.  It has
a corresponding bugzilla entry:

	http://bugzilla.kernel.org/show_bug.cgi?id=11722

Please let me know if there are problems!

Thanks,

John

P.S.  This one is already in net-next-2.6 -- FYI...

---

Individual patch is available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 0523820482dcb42784572ffd2296c2f08c275a2b:
  Timo Teras (1):
        af_key: Free dumping state on socket close

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Luis R. Rodriguez (1):
      ath9k: fix oops on trying to hold the wrong spinlock

 drivers/net/wireless/ath9k/core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 2f84093..88f4cc3 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -316,7 +316,7 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 #define ATH_RX_TIMEOUT           40      /* 40 milliseconds */
 #define WME_NUM_TID              16
 #define IEEE80211_BAR_CTL_TID_M  0xF000  /* tid mask */
-#define IEEE80211_BAR_CTL_TID_S  2       /* tid shift */
+#define IEEE80211_BAR_CTL_TID_S  12      /* tid shift */
 
 enum ATH_RX_TYPE {
 	ATH_RX_NON_CONSUMED = 0,
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
