Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B314A4988
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530587; cv=none; b=OtA6fgdK70RJg8zJJCJKm64FiK0XfQf2UxigIFE0SQ4Skkmt0IV6gm3lruNO0BML9cILMbDJ5iikxJ0AK84PTK5YBBgoVRsSTH5knCbryo2A969egYbJofPLS/i3f0vGCysWBlmzTwAjp3AuRH+lT5DsutSDrYAhWVB64LP3YQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530587; c=relaxed/simple;
	bh=HRCHvj3A1dVi35v/41imcHy54X0mYEwDvbxLvpQVeqs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DSIPlN5Hh3CgNjf6lSJmjbKgtRo9DR7NmSxFLhzT8J4DHeNWOl9fQcPOejk7TKrF5SAMRvYa5nW4PZmmEChRWPbbC70Qpf1pIRpqGd8eiJjTA8cvMPzF/dJAQibR1ySIx4nns0I+m9LZtACZoJPaj9usrbzvWdNo5gLwp/M6PNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QV1bVXL3; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QV1bVXL3"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-381b831d535so1501332a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 07:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788530585; x=1789135385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=02m0O5dEhv7OyAeRQz2TuyPEYJMZ28BVgDL71NGGvo4=;
        b=QV1bVXL3nP9AQ15qFRRLuCslqI1s5yeSxEzhvxR+lo65ONcoUUUozRmnVSXSA087CB
         B80SyTyW35FlihvTVZcGSGUo8UX20CjgP14KbwJSEgGTHuYuDgc1F9qp+cEEO6HZDN7f
         6YH27ktMFPS/mJm3pn8tl5hCqLQWUBw222IHebZNrwAeaqGgAJSO7el47Bvmp48aS5GI
         O0VWKKqdHVr1qjJYuY/4Pny4ajLzeW1kFXIs0cZib6WYue4QDtV7o9Z1qGihjMzHzzRb
         YeseTFGGaZm8Jbb1Rm31Tgg7iZ13k2XDgpJ1+89xRVYA7uDfPO7zeOj2h6wTD9gKdb7L
         bw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788530585; x=1789135385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=02m0O5dEhv7OyAeRQz2TuyPEYJMZ28BVgDL71NGGvo4=;
        b=Q9BLfcO0qwEnIta0dwI3qVMlMC/T+QgH38zt40OVYNW2BU89rlbPGbtdAnfS01L6AM
         bNQtdEWg390I5yigPbmg/pcKy+eVSHb9LdvLob7j8xNzHP6rA3Ua7Geja3THknaC8Cal
         eWkv4b2xyU46zwduNlHO8q6EF/HRLJjZ+Q8SL7A/IN4a9EFpBCYMKuSrWNW1McgPghRO
         gxwbtMNMwwr1u1Ao+XXEPrwrAaAe9fKqDPiF0ZPNzqp4ybEJjr506zfgzGW9g71iaqya
         WA9taKArEPcXSkKOAb/VHcVPoDYWAfpZV1t9h3Gs8lILiIkBWvRwG030j6MI1wzhvz1D
         P7tA==
X-Gm-Message-State: AFuF++l3tIZnFZq3TC7hM9M58leUrARwINwEHvMoq8NoMpC0OYrM3dtm
	Ys4kcRqeIfaWsQdLiTDM7Xqnw8h5H+6Yim4OxUqxYzId2hVqh0tpM9Ne
X-Gm-Gg: AYBFou2VnP3tzvO7tcvUSsY9v9Jd2W1AIj66WLxOIZLmIUrb+UwC2Ttrz4FirH7vcRZ
	rl/ciguA5infwBDqZA0cGtpabHAK2rd7ndObVl42Ytalu+nLoSxFbxa+FNYekOmDSBIKNgGw9cD
	HCIQF//YZpsx3OK0ivwG4h42fzcoq+rOdm7j+oID+GrTGekGLiXN/fAp1Coa8wLAU8FOkhqSUkT
	mo8eT6QZFQoBldtP7wQi02Ds4lXenjS1vK1IZzRQ9FBVPihWWlinz2KKgKJjVGbhmdVcso+davm
	qiILjrlHwdb5R+GSkxuxFI/anE51FpzwTphVHakmsgzd1n931oWErxFJ1E740ADlagMiHC95D4L
	5tcPFOE5z041v/yYwy8ZwujyTUSQBtmMDbaN04FFH0Z7ysusDnc/OblHZqIJvH1mAi0z0sWQ6H+
	6gJ2XVXuVF6UrbpcsWTubWXZXEtbkrbpyJiwZZX62QjpGqWoLWVN87a8TLTWmEqTIbkY/C7T1MD
	LQ/uLp72V9UjGO03cRkYo/l
X-Received: by 2002:a17:90b:4a8e:b0:398:bbe9:73af with SMTP id 98e67ed59e1d1-39b26107ab5mr8991224a91.7.1788530585161;
        Fri, 04 Sep 2026 07:03:05 -0700 (PDT)
Received: from csl-conti-dell7858.ntu.edu.sg ([155.69.195.57])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08cacba5sm11608907a91.12.2026.09.04.07.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:03:04 -0700 (PDT)
From: Maoyi Xie <maoyixie.tju@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless v2] wifi: mac80211_hwsim: send config events to the radio's net namespace
Date: Fri,  4 Sep 2026 22:03:00 +0800
Message-Id: <20260904140300.3402053-1-maoyixie.tju@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hwsim_mcast_config_msg() falls back to genlmsg_multicast() when it has no
genl_info, and that only reaches init_net. A radio in another namespace
therefore has its DEL_RADIO announced in init_net, while its own namespace
hears nothing.

Multicast to wiphy_net() instead, the net that GET and DUMP already filter
on. Tested with a config-group listener in each namespace, on a base and a
patched kernel.

Assisted-by: Claude:claude-opus-5 codeql
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
---
v2: rewrote the commit message; dropped Fixes: and Cc: stable.
v1: https://lore.kernel.org/linux-wireless/20260809113908.2218030-1-maoyixie.tju@gmail.com/

 .../wireless/virtual/mac80211_hwsim_main.c    | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 02b6d81cccd118..d77f54daefc519 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -4396,15 +4396,15 @@ struct hwsim_new_radio_params {
 	bool background_radar;
 };
 
-static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
+static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb, struct net *net,
 				   struct genl_info *info)
 {
 	if (info)
 		genl_notify(&hwsim_genl_family, mcast_skb, info,
 			    HWSIM_MCGRP_CONFIG, GFP_KERNEL);
 	else
-		genlmsg_multicast(&hwsim_genl_family, mcast_skb, 0,
-				  HWSIM_MCGRP_CONFIG, GFP_KERNEL);
+		genlmsg_multicast_netns(&hwsim_genl_family, net, mcast_skb, 0,
+					HWSIM_MCGRP_CONFIG, GFP_KERNEL);
 }
 
 static int append_radio_msg(struct sk_buff *skb, int id,
@@ -4488,7 +4488,8 @@ static int append_radio_msg(struct sk_buff *skb, int id,
 	return 0;
 }
 
-static void hwsim_mcast_new_radio(int id, struct genl_info *info,
+static void hwsim_mcast_new_radio(int id, struct net *net,
+				  struct genl_info *info,
 				  struct hwsim_new_radio_params *param)
 {
 	struct sk_buff *mcast_skb;
@@ -4508,7 +4509,7 @@ static void hwsim_mcast_new_radio(int id, struct genl_info *info,
 
 	genlmsg_end(mcast_skb, data);
 
-	hwsim_mcast_config_msg(mcast_skb, info);
+	hwsim_mcast_config_msg(mcast_skb, net, info);
 	return;
 
 out_err:
@@ -6190,7 +6191,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	hwsim_radios_generation++;
 	spin_unlock_bh(&hwsim_radio_lock);
 
-	hwsim_mcast_new_radio(idx, info, param);
+	hwsim_mcast_new_radio(idx, wiphy_net(data->hw->wiphy), info, param);
 
 	return idx;
 
@@ -6208,7 +6209,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 }
 
 static void hwsim_mcast_del_radio(int id, const char *hwname,
-				  struct genl_info *info)
+				  struct net *net, struct genl_info *info)
 {
 	struct sk_buff *skb;
 	void *data;
@@ -6234,7 +6235,7 @@ static void hwsim_mcast_del_radio(int id, const char *hwname,
 
 	genlmsg_end(skb, data);
 
-	hwsim_mcast_config_msg(skb, info);
+	hwsim_mcast_config_msg(skb, net, info);
 
 	return;
 
@@ -6246,7 +6247,7 @@ static void mac80211_hwsim_del_radio(struct mac80211_hwsim_data *data,
 				     const char *hwname,
 				     struct genl_info *info)
 {
-	hwsim_mcast_del_radio(data->idx, hwname, info);
+	hwsim_mcast_del_radio(data->idx, hwname, wiphy_net(data->hw->wiphy), info);
 	debugfs_remove_recursive(data->debugfs);
 	ieee80211_unregister_hw(data->hw);
 	device_release_driver(data->dev);
-- 
2.34.1

