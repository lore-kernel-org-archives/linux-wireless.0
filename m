Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9300E30EF77
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 01:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788310885; cv=none; b=unb0lElX6LGBWFSY0a4x7jKacKLk7xrbs1gHXIKXIgdswiuBe+ze2xbKQzvPu+oWJgQ2ETATD3yYzodvdkpse1xGl2YlWzJGhsyggoFOaXILRu+2BV8KH5OTXQLiXzxXT50pw5Qhoj9iiJ7yPNHmIVRaby8Ws2LIK1mwo9Me4tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788310885; c=relaxed/simple;
	bh=Q6tfhjQHAk22vFyZ3PtUbqriLWpDS8KohLhNM5fxKrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lGQGkXEBphFZO5KK24fbmUapEktWhy9FExGPYN0Rmg3hxBgoCjmEUhVWmBLvIKPP7SdkXRRANnOdr+cv7hSbRUyuUYcvjFGbXCsRdBupfCg43Y/TfQO1nmmQ8GXUMolO7TsATywv0YwiRivGWHV3LReklxeOXN5ni6o1+GlJr3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QQkAAR1B; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QQkAAR1B"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d58efc7356so5083045ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 18:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788310883; x=1788915683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mIsvf/pMgFR1o4nDemQvggnheWLtStmBokvR+GjxbWU=;
        b=QQkAAR1BA9GLVIQtGv+SlGTkRoBZpcc63+Ys//eGIHd5v2NHhRRp0tReiibNER1aUQ
         fcBUDTydglo/Hi/f/63FucHq8b5+dbIouzLKex5PaD/kq97z5aGuGrQQU5ZmVvG5xzOP
         pmUogVMBEsNnmtSTyYuSPwohLW+r/EK4VCAhKIR8/OMYMm+iwGGwVSvVl90B8dWYfAzp
         xaYJDM8V08VxfmmHm/37rETWdzYZ1tSNA3CyjhEhpGIwB22xPJ7D0sZRfLqkHjlEVBDb
         kyN4bggKZz4zMvQtybMN8OpvCiFX6uGkDvDfpupR4wUX4igQdofnMh8wHTp+gqMCcCIm
         C9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788310883; x=1788915683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mIsvf/pMgFR1o4nDemQvggnheWLtStmBokvR+GjxbWU=;
        b=CPPi2XxiuAvx1jTce5Su88ovs6c6ty0WFzZM+9tGYMna7NXRl6kL/9De1IULiYlVp9
         6qJj8LOWSFU/kVbynrIReR7lZdnj9Dne9ZiyknmHAv6w5Ukrk/AS/+epZOHQdfAju5Rf
         W6S/HLIy2e2507nFZ8dWtLEKwxcfQacqid+dZxubxOTHOS1yRAVE+Hxo+54zJtRSNxI6
         guCgHQqzCUj8OgT+L77sZwwx1LVsVe/gVazpsxQeBg7bgfHRc/X8BAX1RV+xGDWMB3lA
         +NgGSwk7TJchCtmOEc2KqiltCCGaWHcXydP6Y1nQ5yUBeqzT7tO87Y47umHC6Wli4ZTx
         8cEA==
X-Forwarded-Encrypted: i=1; AKwUvBxYxozm/p6umwDQmUshCuqehAsAHfyAALce50xuV2MATrLdfMnXOJblT9Qg1J/Fw4Klk9gn4iIWTZm/3Eo38A==@vger.kernel.org
X-Gm-Message-State: AFuF++lbyBpB+3fLILFDHJp0kWbNtWapFqeuuXAIpnnr25y7Mui0VY+8
	w2d4OcV85dhdy0gJ7cmp+cW7R5uYZw6I9+pnEBrO356cqomygADwBiV3
X-Gm-Gg: AYBFou3JDvWYj4n4HZyiBNdyfp/s0wUc+zrLWPkMZp/jqjO5i+ShJQy4kb0eOMfWJWa
	5JzHcTUFBHJkL0K1Qf6rStNI0SDNdSXKg8jIqnHGXtduaAgppJkJK1+XS71aN4jbhb7WsucCpxs
	ZotzgJJWNVmSWkyzKacLQTbbQYH/kWglJmSHFVk+p9tlBfPPQIGeR4WSoK3IrCw2TJouIOaRJQn
	O8ydYfoOdLsCvV9ZCiobUA/gYxwgPGl+/3OzFVchMijsBu28yENlu2o5Y9D5T8ndgMg3MgpwA6d
	sZfq6gL9VzZtcfDpUlnvWTszeMVHpp3hhB4RvmKR5+iY2c/y02t5vyrQ47FNH71Uu388S2nPsVn
	jb0tmQEz5MWlt2WVj2dKXCzyMj1v917N7boLHml8B7IA//TTPzvMpTAzs/16HydW/bqVGIVCLAU
	cSuREnTg9zQtU+JtHAW3NfX5F1wRl1aMkXnN0lWph+ffsnL4bWOaCffD2Cc9606qu8/lcwc4Szp
	S7MLq3l/OXvP3Vt
X-Received: by 2002:a17:90b:17cd:b0:38e:67e1:15b with SMTP id 98e67ed59e1d1-39aededf539mr1313470a91.6.1788310881957;
        Tue, 01 Sep 2026 18:01:21 -0700 (PDT)
Received: from localhost (211-75-139-220.hinet-ip.hinet.net. [211.75.139.220])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae0dfe6b6sm2164002a91.1.2026.09.01.18.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 18:01:21 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Vignesh C <quic_vignc@quicinc.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Mahendran P <quic_mahep@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath12k: fix NULL dereference in hw scan cleanup path
Date: Wed,  2 Sep 2026 09:01:17 +0800
Message-ID: <20260902010117.3225320-1-acelan.kao@canonical.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath12k_mac_op_hw_scan() walks ahvif->links_map in its abort path to
tear down the scan vdevs it may have created. It skips link vifs which
are no longer present:

	arvif = wiphy_dereference(hw->wiphy, ahvif->link[link_id]);
	if (!arvif)
		continue;

	ar = arvif->ar;
	if (ar->scan.arvif == arvif) {

but it does not check arvif->ar, which is cleared in several teardown
paths while the link remains set in links_map. When firmware crashes
and the reset worker detaches the link vifs from their radio, a scan
request arriving in that window fails, enters the abort path and
dereferences a NULL ar:

  BUG: kernel NULL pointer dereference, address: 0000000000001508
  RIP: 0010:ath12k_mac_op_hw_scan+0x170/0x8a0 [ath12k]
  Call Trace:
   drv_hw_scan+0xa0/0x160 [mac80211]
   __ieee80211_start_scan+0x305/0x7b0 [mac80211]
   ieee80211_request_scan+0xe/0x20 [mac80211]
   nl80211_trigger_scan+0x610/0xa20 [cfg80211]

0x1508 is the offset of scan.arvif within struct ath12k, reached from
a NULL base.

The oops happens in a task holding wiphy and rtnl locks, so it takes
down the rest of the networking stack with it: subsequent scan, netns
and NetworkManager operations block indefinitely in D state.

Check the radio before using it, matching the existing arvif check
directly above and the arvif->ar check already used elsewhere in this
file.

Fixes: feed05f1526e8 ("wifi: ath12k: Split scan request for split band device")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 99bf5cf79d102..64a636f3ae3c6 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -5821,6 +5821,16 @@ int ath12k_mac_op_hw_scan(struct ieee80211_hw *hw,
 				continue;
 
 			ar = arvif->ar;
+
+			/* The link vif may have been detached from its radio
+			 * while this scan request was being processed, for
+			 * example by a firmware recovery running concurrently.
+			 * The link is still set in links_map in that case, so
+			 * the radio has to be checked before it is used.
+			 */
+			if (!ar)
+				continue;
+
 			if (ar->scan.arvif == arvif) {
 				wiphy_work_cancel(hw->wiphy, &ar->scan.vdev_clean_wk);
 				spin_lock_bh(&ar->data_lock);
-- 
2.53.0

