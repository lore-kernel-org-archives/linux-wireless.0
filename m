Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37255481257
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 11:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522454; cv=none; b=s88Ptz+DWPUg4VYgeHJ4T3EMTGZO5uznj7VToXIIIYSm0Wq+HnNWBWDEriqUX1tXPum6zLU7/3G591ERPKlVOk06XIXwyIDw11PuxOgZvu+hmkQBdWJqJ13OWsawouwP4dR4/iqIA3faVBbEBlAgZ/b4Ej8/SltvYAzQdxTX3Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522454; c=relaxed/simple;
	bh=QGib8wXxLjphYUJnSM8tdtUUFiSLYSt2RBNSn7qs8Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8dNNLz7eJbV26LxgZ9MIYWmeQzSekawSKfY3FrZ1+Sg+QTXtapMLSAaZYfpbtT8rE0SOA8V5FSbBWJrKPaZN3yCeEH09zlDmzhSh3kPlJ8oQsPRZ8yEZAI7oYkD07es7RXxzRucCs/wAw66Qf6g2quBkWKgaG2Hv0gunWi8yKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ctHjeasg; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctHjeasg"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7f4e596e393so958197a34.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 04:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788522452; x=1789127252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MfRYZuaFnkNVB/L+WVfkjL8Z4nHliPGglT6z3Y/oaNA=;
        b=ctHjeasgo7xuveBqwGS6whftpCt2w+v7aNjRaGZmIkK3iFpsKU0fb83obbkWmhkA1X
         JPPc+bfFJC/Dt+9SOpic8GcR/UEtNjWU343ch5D997OCeCaBKr7dOcoxyJ8OwTFHBob4
         fV/JTCY9QmfG0hJQMXWxt2urTKpIH9lUooHQNZD6x9XGg9ETVVCUzAi9XtId2pJisqyL
         BpBE5mzOdYJ5B1r+00Y5QBG7Nk5vn+stjscg00Toa6gDfUgS48DLOysl1NgYP6/Zunoa
         L5D6tjM2+GbIfwd7UoOkcZKovsxE+Ot5hQDdfMIFZLkv9Dz0rhxyPAMl3RQautXDDHRO
         PNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788522452; x=1789127252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MfRYZuaFnkNVB/L+WVfkjL8Z4nHliPGglT6z3Y/oaNA=;
        b=VqjGmxHUEtLQqxoMw4CIwbbuO51xEu5yUKNcKbLoYRCAKJxTUee4FjEu/mTdAHxebZ
         kYF0QmMWZt60GjoXkQqe8UwjHp41OTOuH3LS1sPclgalbnTvi2lhU0KQ2ezULyGpveai
         0FqvNro0lN3II0cFkbQ+Usg9xOf9BiYa6kbgc5DO7pq7bIVuuFoUNzQJE+1MhEEfwdjb
         KJX4WNbx8MLjMFlZHW3BeBpC+nNpO1IUkXp2a5GeYF4H4Q7rRBGSnUUTekNPUlqqNIng
         bR/X3bWN9F3O6+Gm8isaoAmCelpPS88u7Bw7MWj2NlFipEdJiqQNYtofQ0zXKsYzi6Kn
         9XXQ==
X-Forwarded-Encrypted: i=1; AKwUvByEMZOIL/XqQJ33FSGVOEKFHUHVCs6DTD8v44S0XnHUKYYXrVsRuTGMjq2PrE0o49kDwCqAP0a7yOLC1jBO+Q==@vger.kernel.org
X-Gm-Message-State: AFuF++lhdrH4QS4VzDCxpZEipWIKXiJMub8l5r5AeJcz4GbNrA0pp0GN
	2rlVzic4g87rc7k5Hg7TKMgYyl6SYsWgCz6Evpa7p8H63iLHu42qsB7YQ+rBr6wBobQ=
X-Gm-Gg: AYBFou3IaN4I375Ysr6aRv3V2YEkBf1/IvLDPonOGh3QyN4CBb8iAKwIXzr5iDR+wv0
	pgaUgVXj5/iQ3zcD1cEyxXc6SzcMdhPCfzX2pLE54r/HBUoMiWU5SaRCeD6By/20+5ruLl/Nf03
	4ARPhim74LD/TeaIxE7PJBYMJPTXKYoMxdpwcNi9+NVhe7Zf9F9yB4vlVvGNBREAotsNcTJ/WJ3
	WytyYju915GlKlib8QXoBl6nJtB2Z90hKaT2mCB+RRqiWjXRheMvYHn0CKoBogJ7fvbSEbNGgF4
	rsSY5rGy0liVFvwHY76Op3oXpCNSaG5PyypHHMAufqLW3NRvv/L4+loaagl6Z72hRwzO9J71HiF
	UQDh5pqaUdlCI+J12sxix5o2RNJSnJ1GnPQSJ2iigje57c08GUPJwrgHSaJ4Kf7a+1h60oJGggO
	AeTMllHJvt9Y4hBsVPkvdf0m008iHMvOn7IgG3H/cvtZzoiFDENTGxWn3dF+FfYKwECahy/GlWi
	6YLClrosigXfvo=
X-Received: by 2002:a05:6820:290e:b0:6b1:4e36:fb80 with SMTP id 006d021491bc7-6b6fa4e066cmr4331480eaf.15.1788522451912;
        Fri, 04 Sep 2026 04:47:31 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339c0ec914sm6950891eec.31.2026.09.04.04.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:47:31 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wifi: iwlwifi: fix typos in comments
Date: Fri,  4 Sep 2026 17:17:21 +0530
Message-ID: <20260904114724.32518-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904114724.32518-1-hemanth.selam@gmail.com>
References: <20260904114724.32518-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h      | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c   | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c      | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
index f1254546cc9d..dd24749f0431 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
@@ -772,7 +772,7 @@ enum {
 #define LQ_FLAG_RTS_BW_SIG_DYNAMIC      (2 << LQ_FLAG_RTS_BW_SIG_POS)
 
 /* Bit 6: (0) No dynamic BW selection (1) Allow dynamic BW selection
- * Dyanmic BW selection allows Tx with narrower BW then requested in rates
+ * Dynamic BW selection allows Tx with narrower BW then requested in rates
  */
 #define LQ_FLAG_DYNAMIC_BW_POS          6
 #define LQ_FLAG_DYNAMIC_BW_MSK          (1 << LQ_FLAG_DYNAMIC_BW_POS)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index c581cc8f5bcb..fcc19a4408bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -628,7 +628,7 @@ struct iwl_pc_data {
  * @tcm_error_event_table: address(es) of TCM error table(s)
  * @rcm_error_event_table: address(es) of RCM error table(s)
  * @error_event_table_tlv_status: bitmap that indicates what error table
- *	pointers was recevied via TLV. uses enum &iwl_error_event_table_status
+ *	pointers was received via TLV. uses enum &iwl_error_event_table_status
  * @internal_ini_cfg: internal debug cfg state. Uses &enum iwl_ini_cfg_state
  * @external_ini_cfg: external debug cfg state. Uses &enum iwl_ini_cfg_state
  * @fw_mon_cfg: debug buffer allocation configuration
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index b2c5be22c293..0b0e296cb2fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -782,7 +782,7 @@ static int iwl_mvm_mac_ctxt_cmd_ibss(struct iwl_mvm *mvm,
 				       MAC_FILTER_IN_PROBE_REQUEST |
 				       MAC_FILTER_ACCEPT_GRP);
 
-	/* cmd.ibss.beacon_time/cmd.ibss.beacon_tsf are curently ignored */
+	/* cmd.ibss.beacon_time/cmd.ibss.beacon_tsf are currently ignored */
 	cmd.ibss.bi = cpu_to_le32(vif->bss_conf.beacon_int);
 
 	/* TODO: Assumes that the beacon id == mac context id */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
index 3f8628cbd480..2a4403b50557 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
@@ -89,7 +89,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
  * This functions cancels the session protection which is an act of good
  * citizenship. If it is not needed any more it should be canceled because
  * the other bindings wait for the medium during that time.
- * This funtions doesn't sleep.
+ * This functions doesn't sleep.
  */
 void iwl_mvm_stop_session_protection(struct iwl_mvm *mvm,
 				      struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 2fd4a9961145..958eb255250f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -135,7 +135,7 @@ int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd,
 }
 
 /*
- * We assume that the caller set the status to the sucess value
+ * We assume that the caller set the status to the success value
  */
 int _iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u32 id, u16 len,
 				 const void *data, u32 *status)
@@ -284,7 +284,7 @@ int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq)
  * @smps_request: The request to change the SMPS mode.
  * @link_id: for MLO link_id, otherwise 0 (deflink)
  *
- * Get a requst to change the SMPS mode,
+ * Get a request to change the SMPS mode,
  * and change it according to all other requests in the driver.
  */
 void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-- 
2.48.1

