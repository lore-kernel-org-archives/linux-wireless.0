Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EFA3A1CF9
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270471; cv=none; b=SP8GVQqvXj+kbpdmdKjj6WiWjC/R/ciZSwTVAMT5LPNJN6H179So1BacKwZvTJkVm/cWA+Vm3orG9m5qFdczxZasK560HAmseP2+Q7J07mlhzLRxBLXofRFl6N8/uwlY/RJlpo273rBDgp2c1miTGY+4gj3X2bMmxROcEM+kDTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270471; c=relaxed/simple;
	bh=6krdLNtKVmL86wGsQ8jAMLKOtMcRp7QzB6NxlaWJkNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3Axf0A7EzvuvNkmjJwQalLZXCs/HYMgrLijfIhr9g048ut1C6ZrfhRc1MTEJM8IpHowpk3kAIOLF6NNl7dHOxzF6S3oqonKzqbMN4mQcaGWRM0NyMbvz9aPNBmuv5nQmc1NGAQEYR7i3O5f41xaTq+379Bn+KrNDt7ZS4ORfd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=eXa3iwCr; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="eXa3iwCr"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A05E0440067
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:44 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 41C0513C2B0;
	Wed, 11 Mar 2026 16:07:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 41C0513C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270462;
	bh=6krdLNtKVmL86wGsQ8jAMLKOtMcRp7QzB6NxlaWJkNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXa3iwCr9hL/ctIenWuusF/V8nDvkkgQWZkwEVxBxxSY3GQNwj/z19MGMPE5pkBvX
	 qevzgSG9UU+RRseX+JiOhzEkLkcDtmzxobcVFZzttvJJGby86gyjT3I84JmqXdUsNc
	 af1mIMGdyOyJhx9Qt1Ndzp9QeraYAWnigxwTh5/w=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 25/28] wifi: iwlwifi: mld: Fix bad return address in tx code.
Date: Wed, 11 Mar 2026 16:07:27 -0700
Message-ID: <20260311230730.163348-26-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260311230730.163348-1-greearb@candelatech.com>
References: <20260311230730.163348-1-greearb@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1773270465-Z8DsR1JTkZRD
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270465;Z8DsR1JTkZRD;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

iwl_mld_txq_from_mac80211 was returning the offset into
txq without checking if txq was NULL.  In case txq is
NULL, this would return a small, but non NULL pointer.

The safety check in calling code would then treat it
as non-null and attempt to dereference.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.h b/drivers/net/wireless/intel/iwlwifi/mld/tx.h
index 520f15f9d33c..8b0da098c25f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.h
@@ -45,6 +45,8 @@ static inline void iwl_mld_init_txq(struct iwl_mld_txq *mld_txq)
 static inline struct iwl_mld_txq *
 iwl_mld_txq_from_mac80211(struct ieee80211_txq *txq)
 {
+	if (!txq)
+		return NULL;
 	return (void *)txq->drv_priv;
 }
 
-- 
2.42.0

