Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F0C3A16B5
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270470; cv=none; b=Bs3vdJsXLSC9AWoAfDIZ8peVcHml1ZaxloSvLb0gwx1dLn9RVPMGBNokQRfnUO1cysT+V682hpoKXH/DD/rCanQKp2QVBZn1srPhdCb345A9tcU99uG48yfFBHricEyE4/Uow21XEdXHDqjOLq7K9rfx8kV+V5gJsO3K0OvBR3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270470; c=relaxed/simple;
	bh=Z+bL97X10ttZavUDhVPw3Ahdpno1vHwhYxGt+bBZ1d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpt+QmDTWiHB0qmxUSV0ohUtrgZUiEkJn59FI9afYe2LrSWhvWw1S++K+97v/RrVkhqJeEvYWJJOOtG5nf9kmmIjOTxMygpMGLJAB1F3fXcDBYARisB8f7DscgotZcVRXIuDqdydoJs98y5b+O/UiuR/XJxmeC37tHsZ2nSY+Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=fEoGTHyr; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="fEoGTHyr"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 96F7D50B7C3
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:47 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 99A0044007C
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:40 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id C5F2213C2B8;
	Wed, 11 Mar 2026 16:07:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com C5F2213C2B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270457;
	bh=Z+bL97X10ttZavUDhVPw3Ahdpno1vHwhYxGt+bBZ1d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEoGTHyrj1XUBtfJk3p+NTcYY+p/vgi3WFIdGB42izk65GoWfR4jENJzbSYRzvY7k
	 q+54j5J+fzclEmvsMBHpNqqsA1Fu4Yh6aB3MEeBqKPfZebAAuQmPtxnB8GUJdTt3u6
	 HW5dqFL/vW5YAo+TdlcYkk2D3RcF8tvHjb0nubnY=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 07/28] wifi: mac80211:  Fix use-after-free of debugfs inodes.
Date: Wed, 11 Mar 2026 16:07:09 -0700
Message-ID: <20260311230730.163348-8-greearb@candelatech.com>
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
X-MDID: 1773270461-hyhoL7o2ZOrv
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270461;hyhoL7o2ZOrv;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

When recursively removing debugfs files, clean up child link
debugfs pointers since the recursive removal will have deleted
their memory.  This fixes use-after-free problem when those child
links are eventually cleaned up.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/debugfs_netdev.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 51d2ae232a85..bc2da35db4ae 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -1039,9 +1039,28 @@ static void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_link_data *link;
+	int i;
+
 	if (!sdata->vif.debugfs_dir)
 		return;
 
+	/* In case where there were errors on station creation and maybe
+	 * teardown, we may get here with some links still active.  We are
+	 * about to recursively delete debugfs, so remove any pointers the
+	 * links may have.
+	 */
+	rcu_read_lock();
+
+	for (i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
+		link = rcu_access_pointer(sdata->link[i]);
+		if (!link)
+			continue;
+
+		link->debugfs_dir = NULL;
+	}
+	rcu_read_unlock();
+
 	debugfs_remove_recursive(sdata->vif.debugfs_dir);
 	sdata->vif.debugfs_dir = NULL;
 	sdata->debugfs.subdir_stations = NULL;
-- 
2.42.0

