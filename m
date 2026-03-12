Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5275339020A
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334867; cv=none; b=K67p/hpXdjXax47Jd6rdBzHmtxMay0wBUm7l7lQ5Ao+bp3UOyzKXlhdBSPNsTO+KHteCckKYZtj70tz9ro5LeuW7Zs6f7xCJ1sz8jYAVlnlbJ4CJdaJMBeb2xzx+DhQZMYq/PMT1lRDzR6otuCc+HluMTqWKAVLgD7MZsTfM+fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334867; c=relaxed/simple;
	bh=lR+gxuvJkoFGHPxnwd75D5Pg8X4FlLDMb+OXL5R6TJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAw7f4DPJkv4LKmdN55a+gb22RZPi4iPogecAZy/KWIeaHmfr2JOVFvArBhe9Ew7VzjkvQFdbQiZ8Ir65VWk4wBxkAJDnQxKqMXH0qJXy+qmjyRf0AEleGeJ3AaGKR/NlJLQCAKRduzjFMpkKn576z1GB3oglq7ij+UROlDg3O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=VG+G7Lfg; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="VG+G7Lfg"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CF2AF340080
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:03 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id DB22413C2BD;
	Thu, 12 Mar 2026 10:01:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DB22413C2BD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773334862;
	bh=lR+gxuvJkoFGHPxnwd75D5Pg8X4FlLDMb+OXL5R6TJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VG+G7Lfg04lTWoh3xGtV8w0qacsw9fbh5Qb6OFDfbgdVT0HWVh3fOWLQ4GvRrzB/d
	 DMYblwI+ROHkXsEKnDwvYNL7SrJJ0QiVYwiQJKNlljHIFrdYa0sPgHVhzi4bXjUjXX
	 h3GlLoogqOmzPOqB6+j1/UzyZqMSQWSIDwPtFr4k=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next v2 17/28] wifi: iwlwifi: mld: use warn-on-once in error path.
Date: Thu, 12 Mar 2026 10:00:15 -0700
Message-ID: <20260312170026.285494-18-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260312170026.285494-1-greearb@candelatech.com>
References: <20260312170026.285494-1-greearb@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1773334864-tL9WNBA_0ttV
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773334864;tL9WNBA_0ttV;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

Just splat a WARNING once, and add debug output to indicate
a bit about why it is hitting the warn path.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/agg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/agg.c b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
index 23d55374ef8a..413a8688e4eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/agg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
@@ -496,7 +496,9 @@ static void iwl_mld_free_reorder_buffer(struct iwl_mld *mld,
 		 * sync internal DELBA notification should trigger a release
 		 * of all frames in the reorder buffer.
 		 */
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
+		IWL_ERR(mld, "free-reorder-buffer problem, rxq: %d  num-stored: %d, will purge frames\n",
+			i, reorder_buf->num_stored);
 
 		for (int j = 0; j < data->buf_size; j++)
 			__skb_queue_purge(&entries[j].frames);
-- 
2.42.0

