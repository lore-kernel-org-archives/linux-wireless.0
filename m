Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548C33A1695
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270468; cv=none; b=Ql0f6p3uhNCAMxhxLihTdPLI48a7FHzfixwNJcCCQ9Q5s2dP9K37ZR7JHAXf2vf7WYt11HryjN86rwmPKao8Ce0LIk711zexxl2rO/yX0HimPC1wT0E/IQrv+lXwOPMq6dY+U89FDtXLT1who+raM2nUQQdPhtmolfK4gw4T0pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270468; c=relaxed/simple;
	bh=LTrp6PkpKYEg4BoWNckuFEuP3G5zXUwriDEvZarByNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeM1/KZACLXeELSGgrbOJa+ObV/KrpQGatlAdqSl4k3bpBmbLcxMd9fgumE1U9846pEg69q4Jm/hxlZH3I0Gf4VqGAsF7yd5Q8HpXdONuSN/r/AbWnz3bqCp/QymBwhgzlIyVCFLbbKx5Em/ds6xWxI/jIH2xPlGHC1Nfgj+NCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=MkyFo/PI; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="MkyFo/PI"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9FD4E440086
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:40 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 070ED13C2B9;
	Wed, 11 Mar 2026 16:07:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 070ED13C2B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270458;
	bh=LTrp6PkpKYEg4BoWNckuFEuP3G5zXUwriDEvZarByNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkyFo/PIshZ2oT782sudLBcDsIkIhytQ8Y5nq9V98SWm3zd6lncKQ5Xx+1OB+Vnr1
	 Y03+aXq5/db9EoJGkvgJ0byxDxw8XVb3Z36mrTQqNXkGgQ9U1P6HKde4Tsf2CQNesK
	 rh+alVvVixHAoBHEiUdjGgz3zXnBtwAhA6ELYvQ8=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 08/28] wifi: mac80211: Debugfs safety checks.
Date: Wed, 11 Mar 2026 16:07:10 -0700
Message-ID: <20260311230730.163348-9-greearb@candelatech.com>
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
X-MDID: 1773270461-XuysmAXNpngb
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270461;XuysmAXNpngb;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

Safety checks in case links are not be properly cleaned up at
the time we are removing netdev debugfs.  Since link debugfs
is child of netdev debugfs, and we are about to recursively clean
up the netdev tree, be sure to null out any debugfs inode pointers
in the child links.

Root cause of the inode use-after-free is something
different, but this patch may also make system more resiliant.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/debugfs_netdev.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index bc2da35db4ae..000859b8c005 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -1037,9 +1037,33 @@ static void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata,
 		add_link_files(&sdata->deflink, sdata->vif.debugfs_dir);
 }
 
+static void
+ieee80211_debugfs_clear_link_ptr(struct ieee80211_sub_if_data *sdata,
+				 struct dentry *dir)
+{
+	struct ieee80211_link_data *link;
+	int i;
+
+	rcu_read_lock();
+
+	if (sdata->vif.debugfs_dir == dir)
+		sdata->vif.debugfs_dir = NULL;
+
+	for (i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
+		link = rcu_access_pointer(sdata->link[i]);
+		if (!link)
+			continue;
+
+		if (dir == link->debugfs_dir)
+			link->debugfs_dir = NULL;
+	}
+	rcu_read_unlock();
+}
+
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_link_data *link;
+	struct dentry *dir;
 	int i;
 
 	if (!sdata->vif.debugfs_dir)
@@ -1061,8 +1085,10 @@ void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 	}
 	rcu_read_unlock();
 
-	debugfs_remove_recursive(sdata->vif.debugfs_dir);
+	dir = sdata->vif.debugfs_dir;
+	debugfs_remove_recursive(dir);
 	sdata->vif.debugfs_dir = NULL;
+	ieee80211_debugfs_clear_link_ptr(sdata, dir);
 	sdata->debugfs.subdir_stations = NULL;
 }
 
@@ -1151,7 +1177,7 @@ void ieee80211_link_debugfs_drv_remove(struct ieee80211_link_data *link)
 
 	/* Recreate the directory excluding the driver data */
 	debugfs_remove_recursive(link->debugfs_dir);
-	link->debugfs_dir = NULL;
+	ieee80211_debugfs_clear_link_ptr(link->sdata, link->debugfs_dir);
 
 	ieee80211_link_debugfs_add(link);
 }
-- 
2.42.0

