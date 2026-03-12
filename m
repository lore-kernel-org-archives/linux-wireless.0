Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376003FB7F4
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334867; cv=none; b=iWb2sqYFeeld32B1w889nPo3DURRzOVGkgTNoN2gJocIzOR4n5O6FznF1UkHaXX+923retQg0sYruqGx94a452fZA4TLqQxYhtbDs6oTB0x2o05thLd0wRMpgHewG8GyZ+Q6EshbFG8hEH2Qpy/3+zhryIy+vcc6JVCvWp7tWp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334867; c=relaxed/simple;
	bh=K+GwCuxKtjcSmwOUXvnQjepT2zhFcF8qL6zmH4yzcAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9ZtbfJ4seLtCXaYcSNQ8+HADNuNHGsVins05bz3ZyAHzDj3pX+0WfoXzXNCuSCib7zaAJVGFg5G1mrpd0KO0ZWP8C1mH4DrqKajXkT+43wZuExYX0mTY+vtEksKHeFZ48vlnfTJkQ8FSgCvT/CKYEdpkEIDFSxi64Gmr+uOfT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=Vaw29QSG; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Vaw29QSG"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 670D4800A0
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:03 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id ADDA013C2B0;
	Thu, 12 Mar 2026 10:01:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com ADDA013C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773334860;
	bh=K+GwCuxKtjcSmwOUXvnQjepT2zhFcF8qL6zmH4yzcAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vaw29QSGW+LNWgEC0F1n2AdI040YyTgiFafnDWsV6a4UXff/HLUInsxSgLDCpSiAG
	 D5vjBeakISF0EmaMbI8E2BvPLVoh/yDfqPKTi8Xce/BfAF28e74hdvuf0yefNfzxNF
	 9Ic6APRKgUdU0gWu3X8VHYVMhkLWmnxda+kU/yUY=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next v2 12/28] wifi: iwlwifi: mld:  Improve logging in error cases.
Date: Thu, 12 Mar 2026 10:00:10 -0700
Message-ID: <20260312170026.285494-13-greearb@candelatech.com>
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
X-MDID: 1773334864-Oq8SvBvPE6Hp
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773334864;Oq8SvBvPE6Hp;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

To give better understanding of how and when failures
happen.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/sta.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index c478cee570a2..6338ca46f68e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -574,7 +574,8 @@ static int iwl_mld_rm_sta_from_fw(struct iwl_mld *mld, u8 fw_sta_id)
 				   WIDE_ID(MAC_CONF_GROUP, STA_REMOVE_CMD),
 				   &cmd);
 	if (ret)
-		IWL_ERR(mld, "Failed to remove station. Id=%d\n", fw_sta_id);
+		IWL_ERR(mld, "Failed to remove station. Id=%d ret: %d\n",
+			fw_sta_id, ret);
 
 	return ret;
 }
@@ -735,8 +736,10 @@ int iwl_mld_add_sta(struct iwl_mld *mld, struct ieee80211_sta *sta,
 	int ret;
 
 	ret = iwl_mld_init_sta(mld, sta, vif, type);
-	if (ret)
+	if (ret) {
+		IWL_ERR(mld, "iwl-mld-add-sta, mld-init-sta failed. ret=%d\n", ret);
 		return ret;
+	}
 
 	/* We could have add only the deflink link_sta, but it will not work
 	 * in the restart case if the single link that is active during
@@ -744,8 +747,10 @@ int iwl_mld_add_sta(struct iwl_mld *mld, struct ieee80211_sta *sta,
 	 */
 	for_each_sta_active_link(mld_sta->vif, sta, link_sta, link_id) {
 		ret = iwl_mld_add_link_sta(mld, link_sta);
-		if (ret)
+		if (ret) {
+			IWL_ERR(mld, "iwl-mld-add-sta, mld-add-link-sta failed. ret=%d\n", ret);
 			goto destroy_sta;
+		}
 	}
 
 	return 0;
-- 
2.42.0

