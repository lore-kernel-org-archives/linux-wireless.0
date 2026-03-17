Received: from vps-8cfc3056.vps.ovh.net (chai.nummela.org [51.195.103.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C58135CB80
	for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2026 09:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.195.103.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773740170; cv=none; b=Xm/u4Ker/8WEwLOlsBNSQuVI0m1eNJLVBSwxW99syRxXId20nJFLSSZGpA2nujtTMJORo8Xo/i9Wgz9cBwnGDxdS9N1Rh5Utm14E9vjXjxPL1RdYBTaIMQWoBayd0ga2pbrQ/Mt5XsHTguvlqWmXGAtT/N/CCHU/a5OL0KOErzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773740170; c=relaxed/simple;
	bh=ORUJ3HapXZwTmnZ1nGQbhZAB7HEvMkzZoJpxSnYtGNY=;
	h=Date:Message-ID:From:To:Subject:Content-Type:MIME-Version:
	 Content-Disposition; b=ODTwWpic92BiB1xx+l35lZzJlhdEoh4uuBbnOsK26K3Evzf2u4b/Gw4lVHUNnaSeX9v3a6Y0K1ol1blvmQ/tfkEEyun9lWG8huFGwKFpjVj92hSGHcgCgh2bnqGBUcDaNSmEfnHivHkFIFceds4mSXt07jwwvxL7TeCkVolyYGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nummela.org; spf=pass smtp.mailfrom=nummela.org; dkim=pass (2048-bit key) header.d=nummela.org header.i=@nummela.org header.b=bRSgy486; arc=none smtp.client-ip=51.195.103.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nummela.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nummela.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nummela.org header.i=@nummela.org header.b="bRSgy486"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nummela.org
	; s=20250215; h=MIME-Version:Content-Type:Subject:To:From:Message-ID:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bb7Uiqu1WjFFf3hwueBA3ZPEzeofaJrG0PvOwVLCCA4=; b=bRSgy486d/QIRXF1xGJ/z6mVJS
	FWkDrgy9J9zMD9KKmyVn+0ad2fQlXty8MkRMGB19/oceRQP58vZxHDBnnf6SkqQqAkpWru8JtXyIs
	q5auwGxZS73tpRSVG/dK9RmRdNrKim1nEJ0jMSuXXBKNJt1QYNVfN2rW6raeRhymtdNzAbPxORJIZ
	Ezbto+i46JRRr1izqG2KVM1S1Ke67/zN1phwJePMSFnK/FhasFcEGdXrOUDnmER3RMwBxkK0NtCW0
	3aBVWeHVD4H3hgZLvktSl4zEwOk16ZH+cle8xZ3xvPh7VVeCKcSkgH0ulu7wW2AwX8rwQ5zPhTw6O
	69YdWkSg==;
Received: from chai.nummela.org ([2001:41d0:701:1100::a7eb] helo=vps-8cfc3056)
	by vps-8cfc3056.vps.ovh.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ville@nummela.org>)
	id 1w2QqL-0000jp-36
	for linux-wireless@vger.kernel.org;
	Tue, 17 Mar 2026 09:36:05 +0000
Received: from 109-204-177-37.cust.valoonet.fi
 (109-204-177-37.cust.valoonet.fi [109.204.177.37]) by www.nummela.org (Horde
 Framework) with HTTPS; Tue, 17 Mar 2026 09:36:05 +0000
Date: Tue, 17 Mar 2026 09:36:05 +0000
Message-ID: <20260317093605.Horde.9WKqN4PAUyX4gAKkAiaQzv9@www.nummela.org>
From: Ville Nummela <ville@nummela.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: rsi_91x_usb: do not pause rfkill polling when
 stopping mac80211
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline


Removing rsi_91x USB adapter could cause rtnetlink to lock up.
When rsi_mac80211_stop is called, wiphy_lock is locked. Call to
wiphy_rfkill_stop_polling would wait until the work queue has
finished, but because the work queue waits for wiphy_lock, that
would never happen.

Moving the call to rsi_disconnect avoids the lock up.

Signed-off-by: Ville Nummela <ville.nummela@kempower.com>
---
   drivers/net/wireless/rsi/rsi_91x_mac80211.c | 17 ++++++++++++++++-
   drivers/net/wireless/rsi/rsi_91x_usb.c      |  2 ++
   drivers/net/wireless/rsi/rsi_common.h       |  1 +
   3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c  
b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index c7ae8031436a..c1fbd16ac2f7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -325,6 +325,22 @@ void rsi_mac80211_detach(struct rsi_hw *adapter)
   }
   EXPORT_SYMBOL_GPL(rsi_mac80211_detach);

+/**
+ * rsi_mac80211_rfkill_exit() - This function is used to stop rfkill polling
+ *                              when the device is removed.
+ * @adapter: Pointer to the adapter structure.
+ *
+ * Return: None.
+ */
+void rsi_mac80211_rfkill_exit(struct rsi_hw *adapter)
+{
+	struct ieee80211_hw *hw = adapter->hw;
+	if (hw) {
+		wiphy_rfkill_stop_polling(hw->wiphy);
+	}
+}
+EXPORT_SYMBOL_GPL(rsi_mac80211_rfkill_exit);
+
   /**
    * rsi_indicate_tx_status() - This function indicates the transmit status.
    * @adapter: Pointer to the adapter structure.
@@ -422,7 +438,6 @@ static void rsi_mac80211_stop(struct ieee80211_hw  
*hw, bool suspend)
   	rsi_dbg(ERR_ZONE, "===> Interface DOWN <===\n");
   	mutex_lock(&common->mutex);
   	common->iface_down = true;
-	wiphy_rfkill_stop_polling(hw->wiphy);

   	/* Block all rx frames */
   	rsi_send_rx_filter_frame(common, 0xffff);
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c  
b/drivers/net/wireless/rsi/rsi_91x_usb.c
index d83204701e27..8765cac6f875 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -877,6 +877,8 @@ static void rsi_disconnect(struct usb_interface  
*pfunction)
   	if (!adapter)
   		return;

+	rsi_mac80211_rfkill_exit(adapter);
+
   	rsi_mac80211_detach(adapter);

   	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
diff --git a/drivers/net/wireless/rsi/rsi_common.h  
b/drivers/net/wireless/rsi/rsi_common.h
index 7aa5124575cf..591602beeec6 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -79,6 +79,7 @@ static inline int rsi_kill_thread(struct rsi_thread *handle)
   }

   void rsi_mac80211_detach(struct rsi_hw *hw);
+void rsi_mac80211_rfkill_exit(struct rsi_hw *hw);
   u16 rsi_get_connected_channel(struct ieee80211_vif *vif);
   struct rsi_hw *rsi_91x_init(u16 oper_mode);
   void rsi_91x_deinit(struct rsi_hw *adapter);
--
2.34.1


