Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E4351C343
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788545353; cv=none; b=IsdRK2tYkVGog/IHq1RPYrTw7N1DKE9KjLM5QZR9yvPa9XrtIVDFDBahnHViumNWacOm9fbORfE0RhPOrbBSPPqikJIXiMRWmEoCYh1Rf00JOX9elM1WJTXwID3iKfQHF3yYDqpZ0gWumuFYwhude45R3QvSMVn6QHHTx0DCC9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788545353; c=relaxed/simple;
	bh=cOJ8OxC4C2lMANiPHbYWMMXjIpP6bwsiDFodLkUz53A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oNqbTTvSfFxeDLknaDkv8cw+DfSjCkgGYjnlCoj7JnGfN6n0TsCh5A0GEKgNDaHnZ3+Lsvh0LIsNN7gPqj9gXYKlxq3+a6c3Dm3vNghxzuj0qCZAXMuttsSoR7HrvNq9YzwQcCzarrXnFzYOCdPT0vho3e6R0oCf7/aCB445wiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MeI59mND; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MeI59mND"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9371bcf1f8fso103906685a.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788545350; x=1789150150; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MhB51A6w/OoQrojpsxyxq7p8lUxX8bUIIqyiGqLRUb0=;
        b=MeI59mND87iOaMNWK84U92bOhkqYgMtsweWAIzOODOFD/e730DJQxx9g960NRdUAPx
         m+dBShC9r0ewvFS+W/7a0H4CRUQNrdJO9PCWVtcx0dA9xGG3nKCbYZJAqxyknnURKOEk
         MzwukEl10NFJr1cr6hlh9NdRFYvsOU21Jacc4gfcNIzQsUK2ofjtj3EU/34EnIIlt7oj
         JO94jLYgmJlrp97ktjlE2TgYlGvdBZ3Op05GOnpoeNGKh+qasqcPKrJ2DvNTe4NDF74P
         9t08BpE1TulxXqgmhzaJ/fVLMTxcgBkLs0KBOk/pbi/5rvaqOzeTGwa7Q6IapZduNuRx
         UfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788545350; x=1789150150;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MhB51A6w/OoQrojpsxyxq7p8lUxX8bUIIqyiGqLRUb0=;
        b=C44jb7aJjCLCTqu5XZuas1wmD/XoOpQzqdNljbVRgaZBcjixgMPbR9RYVFUr6UbN2K
         TF6FkEmtGFb/COlUFy62GTS+Gjtq+8ba3XPO/pGBuLehbiaDtLI62VyPU9K2j1OMBBvj
         rwUnJ2SHTOJ7damijl7koFYpNqMj0e+nngFM3OLEpdxeLZ523KoJwCZVBjPBFtlX/tNF
         erADkGMk8cLJIcNeTxe8YntId+E4KxnqDp7JUr7+mgkLw6gumP9G1LPmMJsETxBMFRSg
         a1T6rTGuoIDPv8og1b0ewuYyTxteoXhKE2xClS0mwl4lUzaTNomrdsjdFW2nf+0Eu9pW
         KtfA==
X-Forwarded-Encrypted: i=1; AKwUvBz1BnctmPS8//bQ98iFYb7fZTNMyaclg2M+NVBW9kThDcxsjlDfg6ttLSAzieJzJFX81kXO2b008SLTVbjmBA==@vger.kernel.org
X-Gm-Message-State: AFuF++k1Imy2YgUUVCQojjC1ZqF0t0OqD/GMxqRifpdJt1RwPNFkLl/l
	QzHvSy0Zfd2yih+jAdzJEaiRo6iYo1bbFzOSFXZZ7A4vYIQl5Oe4/703PzPk
X-Gm-Gg: AYBFou30l+GgT37ErmiEd/Ngn7rvKrbAHaiFNa8VWVDhi5L7nBNS/bs4vfb6gwUzv1p
	t+obJ5MQyMuWexYSRJjz/AF2tU3QHKzyhy75b3Aw301ze48sdaczsb6VQuhYVyyTI0y76kro/MN
	MMvdXhIRNmsCB8McFXRqyZcAckac7fUZp5AMsuNK753vaZmu+7b56aIujq5TKOqXpLTut3nMTfs
	JfHpc/QPje9GiFr22w/8lay8ujVssLZB60wLwf5EG6FGEm7aHOtuuWxa+F3hxUeyK4lVASHIMOG
	aTuyzxgh1m4t75mPqXTUS/xUYsxsw+EbiIXz1JdVJS/N9lVijKNOcsVLPNl+E8PuMWo1QLMf5FI
	LDbdl4j4O/TLRmjtsVhyaQE1Ag7Atrt0lWezYrIbiqSh5ixn/eMGSRfFoJWTBlk9uwgxB5V0Smf
	nrMZ26xgpiexmVzV6ehMbKWFfXHfQ9raVH/p8Jr3xwUO1aDVKkgxxH7m9KjieA+QE8n80sMOiLw
	XfVpn0/hZQ85zbnC10syxLM68/F4h5yNHjFDTfkR6povCLGNgP0cxdwB4hEF6IjnRezT9jVk+O0
	M+W9I132l17GDgs=
X-Received: by 2002:a05:620a:6e1a:b0:92e:d7c7:7de9 with SMTP id af79cd13be357-93980325353mr601007985a.8.1788545349740;
        Fri, 04 Sep 2026 11:09:09 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fba21d6sm260739085a.37.2026.09.04.11.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:09:09 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: ath9k_htc: fix the byte count of a full RMW buffer flush
Date: Fri,  4 Sep 2026 21:08:49 +0300
Message-ID: <20260904180849.775404-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_reg_rmw_buffer() flushes the buffer when it is full, but sizes
the WMI command with sizeof(struct register_write), which is 8 bytes.
The buffer holds struct register_rmw entries, which are 12 bytes. For
the 15 entries of a full buffer the firmware receives 120 bytes instead
of 180 and applies only the first 10 read-modify-writes.

ath9k_reg_rmw_flush() already uses the correct size. Use it in the
full-buffer path as well.

No current caller fills the buffer; ath9k_hw_4k_set_gain() comes
closest with 14 entries. The first caller to queue a 15th entry loses
its last five writes without any error, which is why this is worth
having in stable trees before one appears.

Fixes: 8badb50cfab6 ("ath9k_htc: add new WMI_REG_RMW_CMDID command")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
Changes in v2:
- Add Assisted-by, rewrite the commit message, rebase onto ath-next. No
  code change.

 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 6de78ae85726..0b49d2cc99f0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -405,7 +405,7 @@ static void ath9k_reg_rmw_buffer(void *hw_priv,
 	if (priv->wmi->multi_rmw_idx == MAX_RMW_CMD_NUMBER) {
 		r = ath9k_wmi_cmd(priv->wmi, WMI_REG_RMW_CMDID,
 			  (u8 *) &priv->wmi->multi_rmw,
-			  sizeof(struct register_write) * priv->wmi->multi_rmw_idx,
+			  sizeof(struct register_rmw) * priv->wmi->multi_rmw_idx,
 			  (u8 *) &rsp_status, sizeof(rsp_status),
 			  100);
 		if (unlikely(r)) {

base-commit: 1d8e73163ef933624341075f576e2f36ef9133f7
-- 
2.55.0

