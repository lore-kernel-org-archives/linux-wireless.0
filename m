Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E7E4854F8
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 22:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791500353; cv=none; b=OfyZGuT3iWgVOHCKuRvY82JaBEvx5pKjzWoly5PPHvkvKpmD0qYswgeKnu+4Y8lOPoXkx6/RDqwDSrVnesVhrryWp8hdk9DxMudVJVUMdCUnPJrlIgnfbmvYADDbG2MkPLgg0J0e6ttolSLtyo9umYp6jtruuC3q3LzyzOuDV+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791500353; c=relaxed/simple;
	bh=Zw0gbn9o7SjSJOincKcZvRn8r0aq7uZB2SLBjipojw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8O1zp/L/WbXLCci2B9OgYP3Wq2CvrraixXiGajgyTWmgmgPQRzstGzxjHgRywQkaYdbw12E3dlveQl3gg2H7tNr904x3oSC/KqDrEO5xA3MSlu4jrQ4VcYNKDcBv8q24HLQ838Ru50qqY+QqBQvgFMJE8kAdj8PNojfgPzumKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LnTKXd0r; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LnTKXd0r"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2e2007dd8bso571442766b.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 15:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791500350; x=1792105150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fmc8osNOh8IgZplHnLzxqA7D71f13vW1JNQrlYkSov0=;
        b=LnTKXd0rJinoFqGtzc4jikA6J5+gZCKwPptkpnYXmyxIK+hWGphJFdtEjUAnEIQVbS
         250eL7hmRBSrJuRNmLlUd+tNMDR/KkoP+u2CNd/QRZ59+IdSlcnvxt6LHBc+E4zCAsEI
         pzVPdnZ5f+sT4Piq9o6st1d2Ea5sFTfHD2kzW5U00TUv8jPkpD43kb2zoDAA0A+3t4VZ
         sm87hAxQpzRUABCoxORP9mxnQ7PVhmQuWzaX07KYNk0c0F4KeQQ19H8nZYdH3c6fy+n4
         0NMgR+9ncByubs2oChO3sFSOoqdPLBg8tA3uTPPyGvR85w6Dqqm5IIyJLXZuIifC9b6V
         yobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791500350; x=1792105150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fmc8osNOh8IgZplHnLzxqA7D71f13vW1JNQrlYkSov0=;
        b=YypZs9WJPsvmVBvqCxPAKl7USKpaqMVmHxzq56AHT94InZgScnwVs9c12cM0qbtoj4
         O2fDC5WJCFG12Hvm5rH8HA5bSvPrwBmJkZIVdh6WkfX+vkMGJhSkHGlJO9Lv0WXvetPt
         TxdeD0zNsls6UIDStrbki3u0HywgJpwhdYwT40bhVM7A9aZdgLb2wV55y4SW98eElid1
         B7rFnKMV/vQUOsu5Ry960Kmhm6NlwcV7ZDZICnFJddaGMkAC/AZQ9Jj/AWrs0gvULbrx
         UHJLsFvW/dGPp2znSyn3mBtzuG7oKvCIa9XZ9ScWXbRUpIfhji3qbitK44k4AVyDzrxv
         YuXQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTA4uHFTU+9LysScmDwmU57deJRLv88vjEo8jcOJ1Lv1fIZkg2kv0uV73JNlFr/GOgubb1yT2XG3tb1ZHsKA==@vger.kernel.org
X-Gm-Message-State: AFuF++nr09LARz2h0viOSSym6+83aIXMOLstlhyIlgDLU6fHAVvnv9JI
	lVhOjFqEQ37FHPLQYrRnVBjNzmzDIQWqUqM8pKu1IIx7d1qO7xy/DzFa2XPffLdR
X-Gm-Gg: AYBFou1kCJ8T1/2CsJVN1WIYHy8z/nEyTLQBfaLCnU/QKcu64FWvwzEp/xc9Ir+isbL
	QlxzsS3scM7h5HVLwJJBTg40Mekg9oKwWz2tCvVMMtU3w8ZV987+YXwQrIqWfIX9JK8lCherdK4
	mJwlyuu3+xWodwsXB6o+6ObRlEnRKVsJsB4mYLpMf6PeppFLUJ3Vwkp9SM7V7BB/kc46FiNs8f3
	rkzbgvOq3xdXzt+EUT7mY4SCYbZiGsxIfy7AAZ0906nZQdFm+yHXFWmVOQdePVhTsKe/OgpUfXq
	7Azt/ShfgN0RysB/D9NuXp34DgyykYQGKZ2q7d6wV3idqFwUGXol5scoDsvJ3hi64xDiCQzTqPp
	6IUnq+3L/m+Qlg/62CfjXehw8ydUUnh0VuWTFs0OC1/ACrNo1sN7FcXDz7h6y4cCDODFdc4gtqF
	UrmexbtOPLaaD6Z9jI2G8m1T/ciTlG8q6dq7RoDzWNQISElYlxagRxWly7+oavNie+g9f7R7cQy
	as87g==
X-Received: by 2002:a17:907:9709:b0:c2e:1b4d:e9f4 with SMTP id a640c23a62f3a-c31a9f68e76mr15707666b.31.1791500349693;
        Thu, 08 Oct 2026 15:59:09 -0700 (PDT)
Received: from nb-xps.ts.zxczxc.org ([78.56.243.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9ae59f9sm6993566b.80.2026.10.08.15.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 15:59:08 -0700 (PDT)
From: Nikolay Bryskin <nbryskin@gmail.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net,
	Nikolay Bryskin <nbryskin@gmail.com>
Subject: [PATCH 2/2] wifi: ath11k: apply the initial regdomain before registering the wiphy
Date: Fri,  9 Oct 2026 01:58:53 +0300
Message-ID: <20261008225853.15399-3-nbryskin@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261008225853.15399-1-nbryskin@gmail.com>
References: <20261008225853.15399-1-nbryskin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k marks its wiphy REGULATORY_WIPHY_SELF_MANAGED in
ath11k_reg_init(), but applies the regdomain received from the firmware
only after ieee80211_register_hw(), and asynchronously:
regulatory_set_wiphy_regd() just stores the request and schedules
reg_work. Userspace is told about the new wiphy from wiphy_register(), so
it can query the regdomain before there is one. iwd does exactly that as
soon as the wiphy appears, which triggers the WARN_ON() in
nl80211_get_reg_do():

  !regdom && self_managed
  WARNING: net/wireless/nl80211.c:10576 at nl80211_get_reg_do+0x229/0x270 [cfg80211], CPU#4: iwd/716
  Call Trace:
   genl_family_rcv_msg_doit+0x144/0x1a0
   genl_rcv_msg+0x1cc/0x300
   netlink_rcv_skb+0xcd/0x150
   genl_rcv+0x28/0x40
   netlink_unicast+0x2fb/0x4a0
   netlink_sendmsg+0x219/0x480
   __sys_sendto+0x226/0x230
   ...

The regdomain is already known at that point (ab->default_regd[], or
ab->new_regd[] if an update arrived meanwhile), so apply it before
ieee80211_register_hw(). wiphy_register() then installs the pending
regdomain itself, via wiphy_regulatory_register() ->
reg_process_self_managed_hints(). That happens under the same RTNL hold
as the NL80211_CMD_NEW_WIPHY notification, and nl80211_get_reg_do() takes
the RTNL as well, so userspace can no longer see the wiphy without its
regdomain.

The window matters beyond the warning. With an msleep(2000) inserted
after ieee80211_register_hw() for testing, iwd associated before the
regdomain was applied; the late regdomain then went through
ath11k_reg_notifier() ("driver initiated regd update") and the channel
list update to the firmware while associated, and from then on TX was
badly degraded while RX stayed fine (QCA6390, 5 GHz DFS channel, signal
-33 dBm, no beacon loss):

  tx packets: 2012, tx failed: 1678, tx retries: 0
  tx bitrate: 48.0 MBit/s
  rx bitrate: 648.5 MBit/s 80MHz HE-MCS 6 HE-NSS 2

ping showed 39% loss. Without the delay, the WARN_ON() shows up at boot
only occasionally. With this patch and the same delay neither the
warning nor the TX degradation occurred.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-05266-QCAHSTSWPLZ_V2_TO_X86-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Link: https://lore.kernel.org/all/16aa99921c4e92e8d4da3c84aacbec2e673666aa.camel@sipsolutions.net/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Nikolay Bryskin <nbryskin@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 3dfd24d7b5a6..4ebdde872213 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10648,6 +10648,16 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	    ab->hw_params.bios_sar_capa)
 		ar->hw->wiphy->sar_capa = ab->hw_params.bios_sar_capa;
 
+	/* Apply the regd received during initialization. Do it before
+	 * registering so that cfg80211 installs it while registering the
+	 * wiphy, before userspace can query a self-managed wiphy without one.
+	 */
+	ret = ath11k_regd_update(ar);
+	if (ret) {
+		ath11k_err(ar->ab, "ath11k regd update failed: %d\n", ret);
+		goto err_free_if_combs;
+	}
+
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
 		ath11k_err(ar->ab, "ieee80211 registration failed: %d\n", ret);
@@ -10662,13 +10672,6 @@ static int __ath11k_mac_register(struct ath11k *ar)
 		 */
 		ar->hw->wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MONITOR);
 
-	/* Apply the regd received during initialization */
-	ret = ath11k_regd_update(ar);
-	if (ret) {
-		ath11k_err(ar->ab, "ath11k regd update failed: %d\n", ret);
-		goto err_unregister_hw;
-	}
-
 	if (ab->hw_params.current_cc_support && ab->new_alpha2[0]) {
 		memcpy(&ar->alpha2, ab->new_alpha2, 2);
 		ret = ath11k_reg_set_cc(ar);
-- 
2.56.0

