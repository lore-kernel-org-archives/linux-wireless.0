Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1205F3C872B
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 22:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791500351; cv=none; b=I9vmSP6nqBJJbqWT7euGLCsMJJyjPhCSBg84O+6OKBFxRETN7b/KikxShmMxxgYbUjjaqWnp0wj08hJbaBj1/yQRIWYLg/oy5biUfvN29ovNxEJXgo1gbiRehtITanK8h0jbOLeFwLDKn/3gVTQ/3nnqOjb9nmJqjRAnWFZHBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791500351; c=relaxed/simple;
	bh=Mt/lGA8OGPsPAg/wnnrooNVAKD9CUaS3+1q68XpgO1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8cTDzCuUtHtMAOYgkrhfyizeapUD+o7IOe6J2cXXqBeXYc5X++94mbOMFE9lm3CocPHKbNs35sefpCMObDj5BGCq3gqeybePYtXUDxYzAj94ChmISbdP+hgXjnp1RoWG2VYkYOStveeejIfGaRXeYFkkToYy4Q+VqLoEMhZNQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F06AjRfC; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F06AjRfC"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2a4e013a44so890785866b.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 15:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791500348; x=1792105148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HfIuMkKcZhoNGOCpjkNiN0ls+U2IBKT483IcF3W/m8s=;
        b=F06AjRfCf2AxffZKTMOaQMwhg06bRPbQ1g2wAAy6tckEKkJiIAFgIAB5+1THGWjIkF
         5JBBdOZccnxPc8Ly6Gas1nqfYtVUMBwsb46cnCHTjDzFxkvU4Cwbqgoq+9Fg4QkOIlPh
         0C5KrttV2Yt25ACib2EwSCFyXeq8b2EmZM5rpNkzjBK4yEOkFxEei9NUrrSAHrBu8YbQ
         KVq3aHHkfwCSUqJtYvMrkEd+eODcOfvtow0u+SV4Vog82hRH74uIXr8ljIFsgeC7Npf6
         HIvbqX6F/z/WQxto3BKTVIugjPXQSLdT5kn+dYlJau1SSKIzbjIU8CFJoZpuXGsZJobp
         9BNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791500348; x=1792105148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HfIuMkKcZhoNGOCpjkNiN0ls+U2IBKT483IcF3W/m8s=;
        b=D7g8RmIN8XyxuZyew/URpTw72FQfpcgtMFl5TkNIPK9ajPqU5XngSqjY93Rpbn7wEr
         KFlPTP8+iMrtw+xrlV78X9m3yrT+ldNPI8SWcmisF1TEgdbZdrQHblUoNOfXeYb+Iy2u
         8cSEnieBw0OvwaJQDVKDgaYSAOEOSlRj/mzabBFdhJ0BBHJ0SaZOA4pgK1PqOCdi1p2y
         cInE2dWSvLdemQV2AsePUKRC1asgc8fuuCNH8v43S3x6ufBBp9Tr64pZBxcl1uC/ojfD
         zA0pG5nkU8TJS0JvKI2wyKk8hRSZxxP7dZDYabPOrNXZR6PRQo2F2w4WFmHiKj7ymVX2
         pAOA==
X-Forwarded-Encrypted: i=1; AKwUvBzX7BPKxr1xhj2Qpp5cXQyxaceM+grVlYg3KRvrJM81JYn/SnxdLMXy6pl1uO6pHVinO2T4OEtK9mmOcDuuNA==@vger.kernel.org
X-Gm-Message-State: AFuF++nBIMmNxwfh+BIIdbAk5HoQYmfSxuRmiNm1p0u7ZRcNwU5V3Zj/
	kPT3mg7dOKXwA1FDvn+WKYCWkjl1WQnujEK0lAOoU5nQNaOhhzQQncvd
X-Gm-Gg: AYBFou1pvBhRl4tkv4DXjS8TQbYIVIvPB0g7QjcXCN1147Q4L7qgl7qU+zepyMSu/vW
	gXbENydXuZ5DKYpg9PsFlZIjK0TjXPiTThrARM2JHLlGJBYSPxHqKFWKQPIhSNpwPnf6MvcBm2E
	2r7s5Njuf37enojfrIK+oY3FlTGcHHqch5jqwTlYPlqqkjkcXuXw2spcRlZueGOdA2cAmWwysxo
	LFw9as8VCzL4iCYbG0bb4UjvYgEuU4AyHvNfgXZGCLNQTVecnqvzihfllAkolmVTc8yt8ri55t9
	XKd/Miy64pU3N0ld2bak/E2UnxKlzS+Wqs7t3zNWdLi0XoDPsgI2ZPRjxdOrc0r9/KiiMFt017P
	Ig0W1Iw05/1vj80LYMFQ34RA6UzMi+xREnFpFJFLKYEUzm2RRqNAJrBArytY/Kgsq9PHQNsHqfg
	Fk7B+aO1iEyCKHPJCkVPgt2jUqdwzV4cUUY89UhMjCMHReIt6Qa9pQ/ul/mgIWoLuPj5oUptms2
	dM8AA==
X-Received: by 2002:a17:907:6d12:b0:c2a:704c:8c74 with SMTP id a640c23a62f3a-c31a9d578e7mr16894766b.28.1791500348119;
        Thu, 08 Oct 2026 15:59:08 -0700 (PDT)
Received: from nb-xps.ts.zxczxc.org ([78.56.243.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9ae59f9sm6993566b.80.2026.10.08.15.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 15:59:07 -0700 (PDT)
From: Nikolay Bryskin <nbryskin@gmail.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net,
	Nikolay Bryskin <nbryskin@gmail.com>
Subject: [PATCH 1/2] wifi: ath11k: initialize txmgmt_empty_waitq before registering the hw
Date: Fri,  9 Oct 2026 01:58:52 +0300
Message-ID: <20261008225853.15399-2-nbryskin@gmail.com>
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

ath11k_mac_register() initializes ar->txmgmt_empty_waitq only after
__ath11k_mac_register() has returned, but __ath11k_mac_register() calls
ieee80211_register_hw(). From that point on userspace can transmit
management frames (iwd starts authenticating as soon as the wiphy shows
up), and a WMI mgmt TX completion event then ends up in
wmi_process_mgmt_tx_comp(), which calls wake_up() on the not yet
initialized wait queue head:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:__wake_up+0x5a/0xf0
  Call Trace:
   <IRQ>
   ath11k_wmi_tlv_op_rx+0x174c/0x32b0 [ath11k]
   ath11k_htc_rx_completion_handler+0x4fd/0x670 [ath11k]
   ath11k_ce_per_engine_service+0x2b2/0x380 [ath11k]
   ath11k_pcic_ce_tasklet+0x1d/0x40 [ath11k]
   tasklet_action_common+0x186/0x290
   handle_softirqs+0xe8/0x2a0
   ...
  Kernel panic - not syncing: Fatal exception in interrupt

The window is normally very short. The panic above was hit at boot with
an msleep(2000) inserted after ieee80211_register_hw() for testing, while
iwd authenticated to an AP during the delay.

Initialize the wait queue together with the rest of the txmgmt state,
before registering, as ath12k already does.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-05266-QCAHSTSWPLZ_V2_TO_X86-1

Fixes: dddaa64d0af3 ("ath11k: add wait operation for tx management packets for flush from mac80211")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Nikolay Bryskin <nbryskin@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index c1fa42edd363..3dfd24d7b5a6 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10738,12 +10738,11 @@ int ath11k_mac_register(struct ath11k_base *ab)
 
 		idr_init(&ar->txmgmt_idr);
 		spin_lock_init(&ar->txmgmt_idr_lock);
+		init_waitqueue_head(&ar->txmgmt_empty_waitq);
 
 		ret = __ath11k_mac_register(ar);
 		if (ret)
 			goto err_cleanup;
-
-		init_waitqueue_head(&ar->txmgmt_empty_waitq);
 	}
 
 	return 0;
-- 
2.56.0

