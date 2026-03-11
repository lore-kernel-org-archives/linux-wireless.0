Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC8C3A1A26
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270471; cv=none; b=DNNtZm8Kkc+OKbNnL5QNDzRhGMHX0hJzsN2F7xdQAWhDm3q12mN18HGEarA5TLwmGdM40eahJ8+LtfDOPiB90gswtHfGKkxHWB9+6/192S2yTEmgRmulz5ikMXvV0Ugok2MKC70U110p/cZ/DFejBAhx06CbRXMja9Y5d4NkFQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270471; c=relaxed/simple;
	bh=VCaTw+3e5e9i/Vs/TIQN7VI6oLLEjVwiS3ZnSP7M4Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCGnP4NY+sT+1Lv0Un/bR7ca/248g2hFf9+Bx/lSrDvikj6ibgZDrUun0+nDBEd2t1X8ZcaEre8LOLHxI0TFiz0Ev9Ws7f2wUjRHHjm84j2Gvu3e8O5YMksC021oH/njat2Sdyfb1RV0X0ZUOGSgNA0hcrj8s2zxaRT51uxkYms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=WLJ1Ukx7; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="WLJ1Ukx7"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F2E66440082
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:41 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 2CA7013C2B0;
	Wed, 11 Mar 2026 16:07:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 2CA7013C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270459;
	bh=VCaTw+3e5e9i/Vs/TIQN7VI6oLLEjVwiS3ZnSP7M4Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLJ1Ukx7nXyr+52yvGaxPI37Uzh8XqYl+EMDmkSvhYy3YkNp4NIcV9DVjbUCp2vWK
	 x0AViUTMJw+CiZYeujXOJRsim7AHKvD/3R2We4gp8m1IvD4v8O2R4xjr2uV66l+1qW
	 eUV30LRGXCdiUyq9q14x/kzsS+ORD66aFcEmmflM=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 13/28] wifi: iwlwifi: mld: Remove warning about BAID.
Date: Wed, 11 Mar 2026 16:07:15 -0700
Message-ID: <20260311230730.163348-14-greearb@candelatech.com>
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
X-MDID: 1773270462-0Ci8Z0zv2v9U
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270462;0Ci8Z0zv2v9U;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

It seems to be expected behaviour, and is seen fairly often
in testing in adverse conditions, so make it a one-line log
message instead of WARN splat.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/agg.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/agg.c b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
index a757077b0a7a..23d55374ef8a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/agg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
@@ -216,10 +216,16 @@ iwl_mld_reorder(struct iwl_mld *mld, struct napi_struct *napi,
 	if (baid == IWL_RX_REORDER_DATA_INVALID_BAID)
 		return IWL_MLD_PASS_SKB;
 
-	/* no sta yet */
-	if (WARN_ONCE(!sta,
-		      "Got valid BAID without a valid station assigned\n"))
+	/* no sta yet.  This happens fairly often, don't WARN_ON about it. */
+	if (!sta) {
+		static bool done_once;
+
+		if (!done_once) {
+			IWL_ERR(mld, "Got valid BAID without a valid station assigned, will not log again.\n");
+			done_once = true;
+		}
 		return IWL_MLD_PASS_SKB;
+	}
 
 	mld_sta = iwl_mld_sta_from_mac80211(sta);
 
-- 
2.42.0

