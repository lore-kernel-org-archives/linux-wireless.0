Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24522 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2EGKce (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:34 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	joseph daniel <josephdanielwalter@gmail.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 12/20] NFC: Fix LLCP compilation warning
Date: Mon,  7 May 2012 12:31:23 +0200
Message-Id: <1336386691-24840-13-git-send-email-sameo@linux.intel.com> (sfid-20120507_123238_334388_C2E66FF4)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: joseph daniel <josephdanielwalter@gmail.com>

nfc_llcp_general_bytes is defined in nfc/core.c as:
nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *gb_len).

as in nfc/nfc.h:
nfc_llcp_general_bytes(struct nfc_dev *dev, u8 *gb_len), if CONFIG_NFC_LLCP
is not defined.

so we got some warnings,
net/nfc/core.c:207:2: warning: passing argument 2 of ‘nfc_llcp_general_bytes’ from incompatible pointer type [enabled by default]
net/nfc/nfc.h:87:19: note: expected ‘u8 *’ but argument is of type ‘size_t *’

Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/nfc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 2c868d2..4dd8fab 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -84,7 +84,7 @@ static inline int nfc_llcp_set_remote_gb(struct nfc_dev *dev,
 	return 0;
 }
 
-static inline u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, u8 *gb_len)
+static inline u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *gb_len)
 {
 	*gb_len = 0;
 	return NULL;
-- 
1.7.9.1

