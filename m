Received: from workdog.hb.i-no.de (unknown [37.17.237.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1DA3E0C57;
	Thu, 25 Jun 2026 12:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.17.237.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782390191; cv=none; b=eVXd9F7WV5lzZKKbN2TOj4puN0t706lPTWmLueDPb0LcvfJipDRwpvyAQM8fyzsA94RFa2U/54CTkNNfhLxEt1tA396WtHW82umDXBzicLSCHxjUL5nFRg8o1HZ+5GZWJjbHWt7Nflk02Iyj6KDC+6Q60NBpywwFUOXO6eM3dF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782390191; c=relaxed/simple;
	bh=bCCHjqTQ4kBBj6wQWvP+FH6UGzsEZRIFRGdEfKn9Enk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X+O1ka524fpQBFePl51GG4/Sgl02fsu8244Gzyk4nLKB+NUNv8dNEMx3gwglTS6uTXU919bpTfi3BiTaLW7/bucCfOeOGhSqNsszPkbsRxywC7ltsWxOB5eyaO9FHwm9CLOy5bad39thNDlh6bOCOd6zfJfgbtR0W8upZHFyaJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=schwarzvogel.de; spf=fail smtp.mailfrom=i-no.de; arc=none smtp.client-ip=37.17.237.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=schwarzvogel.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=i-no.de
Received: from klausman by workdog.hb.i-no.de with local (Exim 4.99.4 2 (workog))
	id 1wcidp-000000028Me-3Pbr;
	Thu, 25 Jun 2026 13:53:09 +0200
From: Tobias Klausmann <klausman@schwarzvogel.de>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tobias Klausmann <klausman@schwarzvogel.de>
Subject: [PATCH wireless-next] wifi: iwlwifi: mvm: demote "Unhandled alg" warning to debug
Date: Thu, 25 Jun 2026 13:53:00 +0200
Message-ID: <20260625115300.508794-1-klausman@schwarzvogel.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Tobias Klausmann <klausman@i-no.de>

The RX crypto paths emit an IWL_WARN "Unhandled alg" whenever a frame
arrives that the firmware did not decrypt. This is expected and benign
(e.g. multicast frames received before the GTK is installed), is not
actionable, and floods the kernel log.

Keep the diagnostic but move it from IWL_WARN to the driver's existing
debug facility under the IWL_DL_DROP class, so it is silent by default
and can be re-enabled at runtime via the debug_level bitmask. The
multi-queue path uses IWL_DEBUG_DROP_LIMIT, which provides the same
rate limiting the open-coded net_ratelimit() check did.

Signed-off-by: Tobias Klausmann <klausman@schwarzvogel.de>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index d0c0faae0122..8b037e52eae3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -190,7 +190,8 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 	default:
 		/* Expected in monitor (not having the keys) */
 		if (!mvm->monitor_on)
-			IWL_WARN(mvm, "Unhandled alg: 0x%x\n", rx_pkt_status);
+			IWL_DEBUG_DROP(mvm, "Unhandled alg: 0x%x\n",
+				       rx_pkt_status);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7f0b4f5daa21..4eded44a104e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -504,8 +504,9 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		 * Also drop un-decrypted frames in monitor mode.
 		 */
 		if (!is_multicast_ether_addr(hdr->addr1) &&
-		    !mvm->monitor_on && net_ratelimit())
-			IWL_WARN(mvm, "Unhandled alg: 0x%x\n", status);
+		    !mvm->monitor_on)
+			IWL_DEBUG_DROP_LIMIT(mvm, "Unhandled alg: 0x%x\n",
+					     status);
 	}
 
 	return 0;
-- 
2.53.0

