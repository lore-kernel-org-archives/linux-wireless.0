Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35178 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab1KOGE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:04:26 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
CC: Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 11/18] ath9k: Add functions to allocate/free buffers for MCI
Date: Tue, 15 Nov 2011 11:34:18 +0530
Message-ID: <1321337058-12771-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111115_070429_752164_DA5724F5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

required buffers and dma allocation is done for GPM and SCHED
messages

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/mci.c   |   78 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mci.h   |    2 +
 3 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 93b45b4..9f28cc4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -647,6 +647,7 @@ struct ath_softc {
 	struct delayed_work tx_complete_work;
 	struct delayed_work hw_pll_work;
 	struct ath_btcoex btcoex;
+	struct ath_mci_coex mci_coex;
 
 	struct ath_descdma txsdma;
 
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 0fbb141..5b24676 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -14,6 +14,9 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+
 #include "ath9k.h"
 #include "mci.h"
 
@@ -252,3 +255,78 @@ void ath_mci_process_status(struct ath_softc *sc,
 	if (old_num_mgmt != mci->num_mgmt)
 		ath_mci_update_scheme(sc);
 }
+
+
+static int ath_mci_buf_alloc(struct ath_softc *sc, struct ath_mci_buf *buf)
+{
+	int error = 0;
+
+	buf->bf_addr = dma_alloc_coherent(sc->dev, buf->bf_len,
+					  &buf->bf_paddr, GFP_KERNEL);
+
+	if (buf->bf_addr == NULL) {
+		error = -ENOMEM;
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	memset(buf, 0, sizeof(*buf));
+	return error;
+}
+
+static void ath_mci_buf_free(struct ath_softc *sc, struct ath_mci_buf *buf)
+{
+	if (buf->bf_addr) {
+		dma_free_coherent(sc->dev, buf->bf_len, buf->bf_addr,
+							buf->bf_paddr);
+		memset(buf, 0, sizeof(*buf));
+	}
+}
+
+int ath_mci_setup(struct ath_softc *sc)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_mci_coex *mci = &sc->mci_coex;
+	int error = 0;
+
+	mci->sched_buf.bf_len = ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE;
+
+	if (ath_mci_buf_alloc(sc, &mci->sched_buf)) {
+		ath_dbg(common, ATH_DBG_FATAL, "MCI buffer alloc failed\n");
+		error = -ENOMEM;
+		goto fail;
+	}
+
+	mci->sched_buf.bf_len = ATH_MCI_SCHED_BUF_SIZE;
+
+	memset(mci->sched_buf.bf_addr, MCI_GPM_RSVD_PATTERN,
+						mci->sched_buf.bf_len);
+
+	mci->gpm_buf.bf_len = ATH_MCI_GPM_BUF_SIZE;
+	mci->gpm_buf.bf_addr = (u8 *)mci->sched_buf.bf_addr +
+							mci->sched_buf.bf_len;
+	mci->gpm_buf.bf_paddr = mci->sched_buf.bf_paddr + mci->sched_buf.bf_len;
+
+	/* initialize the buffer */
+	memset(mci->gpm_buf.bf_addr, MCI_GPM_RSVD_PATTERN, mci->gpm_buf.bf_len);
+
+	ar9003_mci_setup(sc->sc_ah, mci->gpm_buf.bf_paddr,
+			 mci->gpm_buf.bf_addr, (mci->gpm_buf.bf_len >> 4),
+			 mci->sched_buf.bf_paddr);
+fail:
+	return error;
+}
+
+void ath_mci_cleanup(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_mci_coex *mci = &sc->mci_coex;
+
+	/*
+	 * both schedule and gpm buffers will be released
+	 */
+	ath_mci_buf_free(sc, &mci->sched_buf);
+	ar9003_mci_cleanup(ah);
+}
diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
index 5df0d60..4eeb0fe 100644
--- a/drivers/net/wireless/ath/ath9k/mci.h
+++ b/drivers/net/wireless/ath/ath9k/mci.h
@@ -132,4 +132,6 @@ void ath_mci_process_profile(struct ath_softc *sc,
 			     struct ath_mci_profile_info *info);
 void ath_mci_process_status(struct ath_softc *sc,
 			    struct ath_mci_profile_status *status);
+int ath_mci_setup(struct ath_softc *sc);
+void ath_mci_cleanup(struct ath_softc *sc);
 #endif
-- 
1.7.0.4

