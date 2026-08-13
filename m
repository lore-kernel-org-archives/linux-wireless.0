Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A55636728F;
	Thu, 13 Aug 2026 08:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609420; cv=none; b=YRs8F3R6f1bX5Z9XyQj5ltLH8qn3M1szMApVqB3n56WyVDU9z19mvfK3veJ4RKuF16pKHAZFiTI6m4RfCifBXFTd35oSGnhNANhvfVaEF73+sFBGF9hRJhzO74RNoWALbE1ssTyzOmSc3Onnm2rsHRTm3iKZwTMJ3zlbdJ9avR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609420; c=relaxed/simple;
	bh=l45JuBwYMJMWQGawB7yPHvVIE+PKPgwuPIEfnr4K+3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=poXSdW7oXLITCpyvIt3wNWaesvzBJuM3YyGYiwYXBiWNGGBl03GYSlkyaKhgmwxNuZMTtWfaBbWlLvE4h1HDIemBQ+uMBKobfe9Sd8tDBnAJo0pAN3khLiCZDO69qmdLXxbLkd5/8jtGv3fO9Ha0FE+Ptn+TuL4w2uUd8vM6KMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 40c6d26096f011f1aa26b74ffac11d73-20260813
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2e8c6304-221b-46b0-8ed3-269593f7c17f,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:7a499a031a488128c09bdb12be4f973f,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 40c6d26096f011f1aa26b74ffac11d73-20260813
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 59013449; Thu, 13 Aug 2026 16:23:24 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 3/3] wifi: nxpwifi: zero the channel statistics array
Date: Thu, 13 Aug 2026 16:23:15 +0800
Message-Id: <20260813082315.1390321-4-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260813082315.1390321-1-lilinmao@kylinos.cn>
References: <20260813082315.1390321-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

adapter->chan_stats comes from vmalloc(), which does not clear the
memory, and nxpwifi_cfg80211_dump_survey() reads it as soon as user
space asks for survey data.  For the entries no scan has filled in, a
non-zero cca_scan_dur passes the validity check and stale bytes are
reported to user space as noise, time and time_busy.

Use kcalloc() instead.  The array holds two entries per supported
channel, small enough not to need vmalloc(), and the two callers change
to kfree() accordingly.

mwifiex fixed the same issue in commit 0e20450829ca ("wifi: mwifiex:
Initialize the chan_stats array to zero").

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 5 +++--
 drivers/net/wireless/nxp/nxpwifi/main.c     | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 5cc8cdf594d3e..461e3e1947438 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -3729,8 +3729,9 @@ int nxpwifi_init_channel_scan_gap(struct nxpwifi_adapter *adapter)
 	 * additional active scan request for hidden SSIDs on passive channels.
 	 */
 	adapter->num_in_chan_stats = 2 * (n_channels_bg + n_channels_a);
-	adapter->chan_stats = vmalloc(array_size(sizeof(*adapter->chan_stats),
-						 adapter->num_in_chan_stats));
+	adapter->chan_stats = kcalloc(adapter->num_in_chan_stats,
+				      sizeof(*adapter->chan_stats),
+				      GFP_KERNEL);
 
 	if (!adapter->chan_stats)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.c b/drivers/net/wireless/nxp/nxpwifi/main.c
index b4c63829024a0..c5d078bb45983 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.c
+++ b/drivers/net/wireless/nxp/nxpwifi/main.c
@@ -644,7 +644,7 @@ static int _nxpwifi_fw_dpc(const struct firmware *firmware, void *context)
 	goto done;
 
 err_add_intf:
-	vfree(adapter->chan_stats);
+	kfree(adapter->chan_stats);
 err_init_chan_scan:
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
@@ -1384,7 +1384,7 @@ static void nxpwifi_uninit_sw(struct nxpwifi_adapter *adapter)
 	wiphy_free(adapter->wiphy);
 	adapter->wiphy = NULL;
 
-	vfree(adapter->chan_stats);
+	kfree(adapter->chan_stats);
 	nxpwifi_free_cmd_buffers(adapter);
 }
 
-- 
2.25.1

