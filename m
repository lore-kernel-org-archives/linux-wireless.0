Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB86541D633
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501328; cv=none; b=H5xPQCM2vPmBov3d42us8rLbKqAaGkwf/DUpx0stQrdTR3tagpAJ6v+/JXJ7Ax1ZqGWXLRazwMVuZaHdSAo85/wNdk7Bxk2E6dMwnM68qxr9OY0dclbmjnbbUSSZqovdlrS70gDPNcsBJh7vKWpfLvOapDUsbFaDbhepVz0hd4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501328; c=relaxed/simple;
	bh=jK3suJFo5svwCW7SI53ge/3Tbq431K/wpYj8IJr6xLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqFaNbkNn0AOqd70nESZGbDtZ5AFxpvUAnqLofK8rq/vmq5ju+xz97OFe4iyVU0H77J8rVuZfTBWvanLByjaioIM3TjN2+TEp/nLF2Op0Lg+ZY8c4uTJ2CKs2PYsu8M/+JRh3N7B1rr1dh/+MNmx8DUJ8XKp9gJ4l9m3uZCbprQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=aO5BHBTo; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aO5BHBTo"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-84e0688b859so496124b3a.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501326; x=1786106126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kIl1FECj4ULR/8VITs0v8eyw9e7Au1gZH8UIwlr6tTU=;
        b=h5XoyyzLEo9iEWe7Xyz/zkzUD7kfMxJf4cYF627k1yYYQxynaZ4dfZO/y3HZAQz3k7
         lkvsnwGdnEu5DdLB+1ztiiML+ej3L/tQYECMlSDydXxmkhVm3lt+t3rd8ujBlXfLBVsV
         sVTck0cH2HnjXFoXxKjEItU3JZhTKetGj5NEQ598i7HfGnnMMJucX9qxh0anJ41eBS0x
         kmT5mqYP9wOZdTmQ8kFNCzJ250cXVIlMGgh+Ssbvk665Cetg1Uh+VWOWgehSjOL3ono/
         ZwuOFykqXtBeyFbS+4aGmzpU1hPQJIjqSExJpFqOuTsE5pb2E/sd0u/+DzVkK9StSs2C
         R0pA==
X-Gm-Message-State: AOJu0Yy0BQbzStZExJaiqSP36pzUJh3H44zPaDalKmOZMVSmvwSdjuYu
	a9ezZAhEAKbaqlIkfofFX6SrVB/bWaeWsJl6PcNlylPHrW2+AtBBQdIekFpTd4dcgv1V/90ef54
	tfN1yMxOF9qF0d76YOij8V0DgBbszf8Mq1+afHYSGdSy33ZV7g4v2Ord2CYkMa+WyfBY5CiEVSP
	Atkn6RdodW0fSNHLgh79yeqdR3bkJR30EhdTfnHGEEtRE1XrOn8SYvDusmCikG3nGtKk45dxjiW
	3e2iDtFoIZVggCrH+/NmPEUw4DC
X-Gm-Gg: AR+sD117YGP2oo0XbXU3snB1PKxTAnFGWam9rf5ueazdrJ9D8xaBZ8W7bceJXa0CqlL
	5eUvQE66E+PXfs6u30VvJEvtz9m7tZMdpICOs+W2wpkKCkkVwjMuriLSbdXAdxEcYERfCXnbZiO
	RKbgWuCrN1HVrGsYPjNjQqLZpc/XNDNv3nBTgJkgZQ4sytdYbvUN9bTsFsq2zQ+aL7hSyqW2vUi
	/l4O1NM0suZJLbp4ZABFnthDpe0ujwo3eiiktE23eO/UEmxLcLmH+PRnMtaUc3iBVMpzMcyZytw
	BTC3+nOkthr1F8eIYcr+yuivcPZK2D86qfFjhFhUu4Sr8u/kD0CH/Bhhqs2qlb9+SkxyzgE6AfJ
	5u08ZX9msfQUQeaiZX1lSdiIpplRbwF/fhVTGCTOpOsTgRX4frODsdrbKZPb7bcBS71eG5RmE1b
	q2Oe2vOlmlvYo8Dw72R0o6YpQdEUoyIZ26V+FAs14=
X-Received: by 2002:a05:6a00:12e9:b0:847:99a7:c751 with SMTP id d2e1a72fcca58-84ed6d8d678mr1532064b3a.25.1785501326124;
        Fri, 31 Jul 2026 05:35:26 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-84edc273ba3sm65009b3a.5.2026.07.31.05.35.25
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:26 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cccfa32670so10605625ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501324; x=1786106124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kIl1FECj4ULR/8VITs0v8eyw9e7Au1gZH8UIwlr6tTU=;
        b=aO5BHBTozAQoxSX/JLQ/Ek5Yqe0syQMXXWM6o5o9b5pvyV0B1cb62FymhwW8Yo8pcU
         iRC1LO4AhV7VW8ojt99q6gZ5/eqTB1yNaZb2zQKhbRlatVOZRxR2JBfBz98NwgdM5g2d
         oBUZh9I4DJzDdG4xOtu7ZUb+YNW4KAvh9wduc=
X-Received: by 2002:a05:6a21:3216:b0:3c3:c687:a3b9 with SMTP id adf61e73a8af0-3c91b314ab8mr1859160637.48.1785501323998;
        Fri, 31 Jul 2026 05:35:23 -0700 (PDT)
X-Received: by 2002:a05:6a21:3216:b0:3c3:c687:a3b9 with SMTP id adf61e73a8af0-3c91b314ab8mr1859141637.48.1785501323572;
        Fri, 31 Jul 2026 05:35:23 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:23 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 03/13] wifi: ath6kl: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Fri, 31 Jul 2026 14:34:59 +0200
Message-ID: <20260731123509.1975281-4-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Stop generating cookies in ath6kl_remain_on_channel() and
ath6kl_mgmt_tx(). cfg80211 now pre-assigns the cookie before calling
into the driver.

For remain_on_channel, store the pre-assigned cookie in
vif->last_roc_id. Widen last_roc_id and last_cancel_roc_id from u32
to u64 to hold the full 64-bit cookie value.

For mgmt_tx, store the pre-assigned cookie in wmi->last_mgmt_tx_cookie
so the firmware TX status event handler can pass the correct cookie to
cfg80211_mgmt_tx_status(). Thread the cookie through the powersave
queue (ath6kl_mgmt_buff) so it is available when the frame is
eventually dequeued and sent.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 18 ++++++------------
 drivers/net/wireless/ath/ath6kl/core.h     |  5 +++--
 drivers/net/wireless/ath/ath6kl/main.c     |  1 +
 drivers/net/wireless/ath/ath6kl/txrx.c     |  1 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |  2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h      |  1 +
 6 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ecde91159b54..e9d6e6a53d7d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3038,16 +3038,10 @@ static int ath6kl_remain_on_channel(struct wiphy *wiphy,
 {
 	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
 	struct ath6kl *ar = ath6kl_priv(vif->ndev);
-	u32 id;
 
 	/* TODO: if already pending or ongoing remain-on-channel,
 	 * return -EBUSY */
-	id = ++vif->last_roc_id;
-	if (id == 0) {
-		/* Do not use 0 as the cookie value */
-		id = ++vif->last_roc_id;
-	}
-	*cookie = id;
+	vif->last_roc_id = *cookie;
 
 	return ath6kl_wmi_remain_on_chnl_cmd(ar->wmi, vif->fw_vif_idx,
 					     chan->center_freq, duration);
@@ -3106,6 +3100,7 @@ static int ath6kl_send_go_probe_resp(struct ath6kl_vif *vif,
 
 static bool ath6kl_mgmt_powersave_ap(struct ath6kl_vif *vif,
 				     u32 id,
+				     u64 cookie,
 				     u32 freq,
 				     u32 wait,
 				     const u8 *buf,
@@ -3138,6 +3133,7 @@ static bool ath6kl_mgmt_powersave_ap(struct ath6kl_vif *vif,
 
 			INIT_LIST_HEAD(&mgmt_buf->list);
 			mgmt_buf->id = id;
+			mgmt_buf->cookie = cookie;
 			mgmt_buf->freq = freq;
 			mgmt_buf->wait = wait;
 			mgmt_buf->len = len;
@@ -3222,7 +3218,6 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		 * Send Probe Response frame in GO mode using a separate WMI
 		 * command to allow the target to fill in the generic IEs.
 		 */
-		*cookie = 0; /* TX status not supported */
 		return ath6kl_send_go_probe_resp(vif, buf, len, freq);
 	}
 
@@ -3235,16 +3230,15 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		id = vif->send_action_id++;
 	}
 
-	*cookie = id;
-
 	/* AP mode Power saving processing */
 	if (vif->nw_type == AP_NETWORK) {
-		queued = ath6kl_mgmt_powersave_ap(vif, id, freq, wait, buf, len,
-						  &more_data, no_cck);
+		queued = ath6kl_mgmt_powersave_ap(vif, id, *cookie, freq, wait,
+						  buf, len, &more_data, no_cck);
 		if (queued)
 			return 0;
 	}
 
+	ar->wmi->last_mgmt_tx_cookie = *cookie;
 	return ath6kl_wmi_send_mgmt_cmd(ar->wmi, vif->fw_vif_idx, id, freq,
 					wait, buf, len, no_cck);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 77e052336eb5..a0b236eeeab5 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -404,6 +404,7 @@ struct ath6kl_mgmt_buff {
 	u32 freq;
 	u32 wait;
 	u32 id;
+	u64 cookie;
 	bool no_cck;
 	size_t len;
 	u8 buf[];
@@ -631,8 +632,8 @@ struct ath6kl_vif {
 	struct cfg80211_scan_request *scan_req;
 	enum sme_state sme_state;
 	int reconnect_flag;
-	u32 last_roc_id;
-	u32 last_cancel_roc_id;
+	u64 last_roc_id;
+	u64 last_cancel_roc_id;
 	u32 send_action_id;
 	bool probe_req_report;
 	u16 assoc_bss_beacon_int;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 8afc6589fc51..9c023d7ce305 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -898,6 +898,7 @@ void ath6kl_pspoll_event(struct ath6kl_vif *vif, u8 aid)
 		spin_unlock_bh(&conn->psq_lock);
 
 		conn->sta_flags |= STA_PS_POLLED;
+		ar->wmi->last_mgmt_tx_cookie = mgmt_buf->cookie;
 		ath6kl_wmi_send_mgmt_cmd(ar->wmi, vif->fw_vif_idx,
 					 mgmt_buf->id, mgmt_buf->freq,
 					 mgmt_buf->wait, mgmt_buf->buf,
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index d81825413906..609d458ca6c5 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1469,6 +1469,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 					spin_unlock_bh(&conn->psq_lock);
 					idx = vif->fw_vif_idx;
 
+					ar->wmi->last_mgmt_tx_cookie = mgmt->cookie;
 					ath6kl_wmi_send_mgmt_cmd(ar->wmi,
 								 idx,
 								 mgmt->id,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 6c29f0bcec9f..2140fddba8ba 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -596,7 +596,7 @@ static int ath6kl_wmi_tx_status_event_rx(struct wmi *wmi, u8 *datap, int len,
 	ath6kl_dbg(ATH6KL_DBG_WMI, "tx_status: id=%x ack_status=%u\n",
 		   id, ev->ack_status);
 	if (wmi->last_mgmt_tx_frame) {
-		cfg80211_mgmt_tx_status(&vif->wdev, id,
+		cfg80211_mgmt_tx_status(&vif->wdev, wmi->last_mgmt_tx_cookie,
 					wmi->last_mgmt_tx_frame,
 					wmi->last_mgmt_tx_frame_len,
 					!!ev->ack_status, GFP_ATOMIC);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 8fbece3fdad9..89ce2abbb1cd 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -125,6 +125,7 @@ struct wmi {
 
 	u8 *last_mgmt_tx_frame;
 	size_t last_mgmt_tx_frame_len;
+	u64 last_mgmt_tx_cookie;
 	u8 saved_pwr_mode;
 };
 
-- 
2.54.0

