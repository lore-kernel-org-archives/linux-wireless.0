Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145874DE717
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 21:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792357340; cv=none; b=BcMH2bPDEZiMdWwSvIXVQnk1hHJTH85j3VD7LxLAkM8APU0tT+DPnGokxwt0ttg6H9F0IHeLEXtm12CsQLjNiy3JErQL66wB4kRxDXT8p1Lmlwk0hPxkJIXrCAyb26bb9MUGgdtjfRTtWgTzhB6mFFm+dedQk6lkTwmFnaGKFaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792357340; c=relaxed/simple;
	bh=MbM68oLnHfgMNHhrjsVH1A+OpQzDA+M/S9wUQXSTyxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hbZujdn7HcUUOcmMU3UmlYYqRNjrMo+kEfzR2wpW5fisGStULi4mdfVXkKkHH8jsfN648xvZMZvoNWv3ijDR9tOIdhXxzb73+NB+S0hjBuSTr3bUvFW20cFIFvPk/IciR+6dTP9R4hGv9lA8PD4PUriDLUPwSHZwOOdJezEmdAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=RdqdOMYB; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="RdqdOMYB"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c169ae1cb26so426265566b.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 14:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792357336; x=1792962136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IjCL8rWWQCqnPM2ezT/ruQu8lgpi8/XSKN8Gv6f2o+4=;
        b=RdqdOMYBxUvoznXYcXvFs8ItyZ1ApbLKROv7LRkcPKQrzP5jNWn84PkZE5Bp/p4knj
         buz9uRLkOfAVO0BAptntmJFvjrFP0cGbCxen2+pRpQOaG60HD8eilEYgF5b2di548YUg
         WCfc/SlbtwVeOCWXDSmtyH6cJcrSAbnxzCG6Z0naxKYrc9FvpCskyHYf54QzRzBHkMFM
         2reAOIcFpgNCYmcnLUXeKIh19M4ZSOHCbLakHiYEeWWuvUH794Jq7S3GNyXccy2zyVox
         UJBMdGjBoCH5dSmdVmFm8zFcuHJ4h1NjQ1e9ubEJHpKTCUMdXrM90X2Fo3npdXl6mQa7
         MYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792357336; x=1792962136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IjCL8rWWQCqnPM2ezT/ruQu8lgpi8/XSKN8Gv6f2o+4=;
        b=YEU1oXr6DjKRJm39naBA3uM0rhomR+0/zYSO4aBTKPR+prZBPYbwGyK0N/dH+1phFL
         6RbjFFuS+mdK3+eoOyfTOtFH8H+ChkqrNwmF1FvwQxTzpH6erFp0DElBJF8R8QvYaQKP
         F40bBwAuNu0n8JsWi/+VVW2omSvObanxOtXQjcYSv/+Vv845yxSnx2embW7vN9hpuG0l
         Gewl+Zk9NuqnK+fuwu4zbA74Y8XIw6KYx7NYz+T6BK9zV2zbz90bvSD2e/OqBypPkR25
         fA80jxmV4FK69144YEkE9FEKp/n3zVaPFU5BqsdMjQ8+mkXefHfPR4fHQkWpESxY0sAj
         4Wsw==
X-Forwarded-Encrypted: i=1; AKwUvBxH5LMz/bZ19ZzNNqhycaovUeIoOTk1KKG4WtwG5FS05Nk3His6AhexQEaL3LtEZYX2JGVdM07zZCc1iHkhfQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLVj5aFiraxcx4Uu9TsBVFqGd8DcjrM23w9JJtR+4mHsrxRhCJ7
	vSuFSb42UQzlcBlPbk71IHIQkArltFgs6CAk65w3q4mQQhQ8jKYU5fICcmm1vaqF2A==
X-Gm-Gg: AYBFou2l/Vgelnafzi8h05jlM9MZyZCHuY6ojLpWSO+WpkpEj+GK2KX1GFU5x9/Q0IG
	SHAUQ9y1zhCvem0AhOslnToYnYZu34evTVMQBH5hvHRAaiwYoesFIcdCctJGNQrzxnwsaPKWDJr
	rMgP4TzPbvux139t4g4Agae56oKNqLgN+YVMuYMCZoEUn2ox2rzpjtf00YSMkrXpf0izk81ulB3
	WYu1wSFiCCAwEvWsI7yvBVaZac9Ee/EW5gs/dolB+8l78vdC+JDta+N062XqXBp450rR+Zbau5L
	g7llUwTYJRmrtAagWJrIGy2mGxtBRicVsNzHhrn0LtsnwzCmjthAT1rBskk0hexDN0mVySSmz65
	sxCwTr+E8CPKZStLJ04hCPfY8IW4WipcOLbDEIzxW/gmRHH9/GDEHO7RN2tHJNnQne8jkKCD1oK
	PjYI3rnPItNqZuiAdkcL4F7RlklIBtoy9CMZBL/tbjlR2xB/AsY2jyezFGvqWZkHLnjmKUr+6Uo
	ynNLBUhoycLOX8//cIl9jryCchdxcYuFtTa1ld+175QSUw4SAv++dP2spuu5qL3+Rf/b1oyQImU
	F7VtD4UMpd9rsoV0xuiqFhHXlooeb4S+PV1ZrTsl5xMJJp9taAmIOvQZ8HN3SKVr+qGmrwCkdmT
	5kZ+/LKYUMUjhNPqlOtRbzsYeCi+EpQNdctyzQ+fv8CHgm23okrCHxzrc0wPQfThpdQw3MQlG/R
	SYUirpqYP6yw==
X-Received: by 2002:a17:907:2d0a:b0:c31:5918:86d1 with SMTP id a640c23a62f3a-c419e03a4c8mr432252966b.10.1792357336034;
        Sun, 18 Oct 2026 14:02:16 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4465eb0c67sm21953166b.12.2026.10.18.14.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 14:02:13 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH RFC ath-next] wifi: ath11k: advance the TX PN of keys reinstalled after a firmware restart
Date: Sun, 18 Oct 2026 23:02:12 +0200
Message-ID: <20261018210212.1926073-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After a firmware crash mac80211 installs the same pairwise and group
keys again. ath11k_install_key() leaves key_tsc_counter at zero, so the
restarted firmware sends with PNs the key has already used: stations
drop the frames as replays until the PN passes the last one they
received, and CCMP and GCMP reuse the nonce under the same key.

A station that had received 11, 2012 and 3512 frames before the crash
accepted downlink again only after 11-13, 1817-2119 and 3324-3627
frames after the restart. Broadcast ARP requests are dropped as well,
so a station whose neighbour entry expires stays unreachable.

Start a reinstalled key past any PN it may have used. An HE PPDU
carries at most 256 MPDUs and lasts at least 40 us, so add 8 PNs per
microsecond since mac80211 last started the radio to the key's tx_pn.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
RFC because WLAN.HK.2.9.0.1-02146 ignores the field: with key_tsc_counter
set to 83834696 on every reinstalled key, the station that had received
3511 frames still needed 3324-3627 frames before it accepted downlink
(1 run).

Which command or field sets the TX PN of an installed key on this
firmware? Without one the stations need new keys after a restart.

 drivers/net/wireless/ath/ath11k/core.h |  5 +++++
 drivers/net/wireless/ath/ath11k/mac.c  | 12 ++++++++++++
 drivers/net/wireless/ath/ath11k/mac.h  |  3 +++
 drivers/net/wireless/ath/ath11k/wmi.c  |  4 ++++
 drivers/net/wireless/ath/ath11k/wmi.h  |  1 +
 5 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index a0d725923ef24..683d6b750439c 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -668,6 +668,11 @@ struct ath11k {
 	u8 mac_addr[ETH_ALEN];
 	struct ath11k_he ar_he;
 	enum ath11k_state state;
+	/* last mac80211 start, and the TX PN advance for keys reinstalled
+	 * after a firmware restart
+	 */
+	ktime_t start_time;
+	u64 restart_pn_advance;
 	bool supports_6ghz;
 	struct {
 		struct completion started;
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa37d1..0f9bf1d00546f 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4421,6 +4421,13 @@ static int ath11k_install_key(struct ath11k_vif *arvif,
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV |
 			      IEEE80211_KEY_FLAG_RESERVE_TAILROOM;
 
+	/* The restarted firmware has lost the TX PN of a key that mac80211
+	 * installs again, so start it past any PN the key may have used.
+	 */
+	if (ar->state == ATH11K_STATE_RESTARTED)
+		arg.key_tsc_counter = atomic64_add_return(ar->restart_pn_advance,
+							  &key->tx_pn);
+
 install:
 	ret = ath11k_wmi_vdev_install_key(arvif->ar, &arg);
 
@@ -6645,6 +6652,9 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 		break;
 	case ATH11K_STATE_RESTARTING:
 		ar->state = ATH11K_STATE_RESTARTED;
+		/* Every key in use was installed after the last start */
+		ar->restart_pn_advance = ATH11K_MAX_MPDU_PER_US *
+			ktime_us_delta(ktime_get_boottime(), ar->start_time);
 		ath11k_mac_wait_reconfigure(ab);
 		break;
 	case ATH11K_STATE_RESTARTED:
@@ -6656,6 +6666,8 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 		goto err;
 	}
 
+	ar->start_time = ktime_get_boottime();
+
 	ret = ath11k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_PMF_QOS,
 					1, pdev->pdev_id);
 
diff --git a/drivers/net/wireless/ath/ath11k/mac.h b/drivers/net/wireless/ath/ath11k/mac.h
index 127cb476b44b7..cde8f1c08eb0e 100644
--- a/drivers/net/wireless/ath/ath11k/mac.h
+++ b/drivers/net/wireless/ath/ath11k/mac.h
@@ -20,6 +20,9 @@ struct ath11k_generic_iter {
 };
 
 /* number of failed packets (20 packets with 16 sw reties each) */
+/* An HE PPDU carries at most 256 MPDUs and lasts at least 40 us */
+#define ATH11K_MAX_MPDU_PER_US			8
+
 #define ATH11K_KICKOUT_THRESHOLD		(20 * 16)
 
 /* Use insanely high numbers to make sure that the firmware implementation
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 5c27e7057e6ad..0deab00939af7 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -1876,6 +1876,10 @@ int ath11k_wmi_vdev_install_key(struct ath11k *ar,
 		memcpy(&cmd->key_rsc_counter, &arg->key_rsc_counter,
 		       sizeof(struct wmi_key_seq_counter));
 
+	if (arg->key_tsc_counter)
+		memcpy(&cmd->key_tsc_counter, &arg->key_tsc_counter,
+		       sizeof(struct wmi_key_seq_counter));
+
 	tlv = (struct wmi_tlv *)(skb->data + sizeof(*cmd));
 	tlv->header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_ARRAY_BYTE) |
 		      FIELD_PREP(WMI_TLV_LEN, key_len_aligned);
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index b2dade0516ac7..049c90fa80c4d 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -3690,6 +3690,7 @@ struct wmi_vdev_install_key_arg {
 	u32 key_txmic_len;
 	u32 key_rxmic_len;
 	u64 key_rsc_counter;
+	u64 key_tsc_counter;
 	const void *key_data;
 };
 

base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
prerequisite-patch-id: cd9f2849ade92e165f15fe3f887edabd1d06b6e8
prerequisite-patch-id: 3c9ba2aec0d93942448aba1dc5d26b632d519e5a
prerequisite-patch-id: 9a833c602db147b490fba6df590eeea3847f4877
prerequisite-patch-id: 6fd3e11242fb3ead65751e3cd9972c4d7c63f989
prerequisite-patch-id: 01e149ed860e5e40e79725580548ce4034f344b2
-- 
2.53.0

