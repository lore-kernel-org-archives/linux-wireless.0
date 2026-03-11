Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDD43A3832
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270471; cv=none; b=TaZ9/YwZCgLsFcwbceqw7voe5O6ydpTa0kCo+R6YLQSQqweZXGoX5w9DpMFyPZN9AFZHye4k7vDhAU4440lAo2VnbWaM2pCMHD1COfyyd+cb09LwMTCPkFf5ZsmWarwK9izUoLMMNeFheIhfoPaFxzIAFyUnKKzFB85RD1Tmhlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270471; c=relaxed/simple;
	bh=2UTsqU8oDsvMdz4MSLxy8TUKLmsLG1fSGAgQilj4J6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iW7GvMeQ7CbcXq5dnPzQ6vaFyIc7FY9l2sIbLakAMpbjyNs6/Papy5AwCvSSMH5VTEs308V7fAUm+qxPPOfbdLyESlwuFL4MBv6vdYrGojrZbfZgAuqcOUOiVg3DXiVSd6WQ9WdWuj2lfYb5fX7V863u8RzOIfuYqfezcG+9ns0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=eGZqXbZn; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="eGZqXbZn"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 77AC6440092
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:42 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 81C7313C2BE;
	Wed, 11 Mar 2026 16:07:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 81C7313C2BE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270460;
	bh=2UTsqU8oDsvMdz4MSLxy8TUKLmsLG1fSGAgQilj4J6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGZqXbZn8KMqJoU27t15UjH5NA6pbk8ZOId/hCNv7johwwTLooxbI17vzGZAcxbzZ
	 mg2Xo4Zb4tbU3vKHmjbzbn/ZJN89YuGfZAh4dO8atcj7RPcNNcLtxgDunMyebndiO2
	 qt5bOCESyodgY4ptoY9WWTpACiQQn5psImRrYCVU=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 18/28] wifi: iwlwifi: mld: Use warn-on-once in emlsr exit logic.
Date: Wed, 11 Mar 2026 16:07:20 -0700
Message-ID: <20260311230730.163348-19-greearb@candelatech.com>
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
X-MDID: 1773270463-WzaPUevRhidK
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270463;WzaPUevRhidK;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

Only splat warning once, and improve logging to indicate more
about why it is in the problem state.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
index f842f5183223..7a37ca64a612 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
@@ -164,7 +164,10 @@ static void iwl_mld_check_emlsr_prevention(struct iwl_mld *mld,
 		 * The timeouts are chosen so that this will not happen, i.e.
 		 * IWL_MLD_EMLSR_PREVENT_LONG > IWL_MLD_PREVENT_EMLSR_TIMEOUT
 		 */
-		WARN_ON(mld_vif->emlsr.exit_repeat_count > 3);
+		if (WARN_ON_ONCE(mld_vif->emlsr.exit_repeat_count > 3)) {
+			IWL_ERR(mld, "check-emlsr-prevention exit repeats: %d > 3, blocked-reasons: 0x%x\n",
+				mld_vif->emlsr.exit_repeat_count, mld_vif->emlsr.blocked_reasons);
+		}
 	}
 
 	IWL_DEBUG_EHT(mld,
-- 
2.42.0

