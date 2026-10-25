Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792953834;
	b=z802MC9rIE9ldTcR3RoPfqHDmz2RRxNXGUBDH1Xu6/76oQPttHsqSfgx5QsBP0OjSlFe
	 xVVYzLRLJzMvXYCVZnlcPgFIs9OYiSyeUXdulCssnMjXL2lPuxjpWNhVgawM9sPJURpgV
	 HVFVejrynjAfzl+0It6cY4EIE2T0Mmt1LnQuuxXyWIPkajIf9jkRXSEjzTB/w1M9gr5yv
	 vinqt0+oFjGUkMyXQ1NXEFkh25H2PsGFEpPDXf2Tj3xS6Elgd/DIfKxxlcx2TukqITHcT
	 YRraVxbCRon5Oyez+z0HZQhVqZmBjnQMGhrRsDpm7eFiqmFhwbxpOBFvqTuZmWcALmQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792953834;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=/PfFRzkpybBeGYhNyKbQey9szpqk7jsPsmdqcmjPvE8=;
	b=jovPFbxEWUOXFj2Dzwh5o/BPrpupKZnQwLHdl+cD7HSMA5814CKX2qq5DHW53YM/dvKC
	 DvY2NPqVllZ2rL3T4UBBf9Gaf13ORihp41cdrOrAPRkz0mESgQJkNkM+iUJOt6B3aZk/R
	 Rn4PTyCxKI4FNhGzpl2umaBG2YSwpAbvfQwVTV0cB72lY9CcB4QFfd4eG7lTtrPK0+cBG
	 96B/vtp5wPOGordSQgVRb6G92m6S5O4CwpoSkWfH3GvUgAsUxWCtAmVH217mzY3c2VYu5
	 c0I0obYNwl7s/otMGngL+qWsqh91WZjkTK4jOUwmS425rTcArOfV6gSBZRFbeEz+ohw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="nA1tNR/b";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.54
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F6A606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:43:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6F6A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nA1tNR/b
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6b1afdf5196so957572eaf.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 11:43:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792953833; cv=none;
        d=google.com; s=arc-20260327;
        b=C8T+OHGu9ZGyO6KY90+kzwrHbQcKWiMeaAL4mK4U0JYtUOfeXS5ZGCRgSgwUkJVt69
         EQxw4Hd0x1IpG8nwik7xelW9zp4GVOIkON/AidY4jG8Ps00uhBMfpY8itj2480ti77X/
         C9ABXjMg+HECw+fvJOWYS3KfjRLz6h6ZYhXVuZAV1lOC8DvVgPhPNQArOP4dzhmz1hq6
         HRUlDFSJQrPeUznzmCafO8gd6PuRtVFy0jSVelHtd7cbJXOravpToZkzY7YKDkeaxmfp
         wlZ46dYr2AKakLZTnfok3cGUvH38w96mk0ndYvo0ZmIc5yJxMx0Ucha6Qoe4BKXDzNUG
         HsWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=/PfFRzkpybBeGYhNyKbQey9szpqk7jsPsmdqcmjPvE8=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=qvGjnbZyH6QWt6OR/JUzRuOLdGUQregRqjeQCZeQwLZho3oSR90XitPuYDxzdzwq6v
         DHZtBRegSE7fes1TWWatPZwL2sdr2PnRKH9DgfFOwthneT7c1kDZzcUOnomVXoHhn+0H
         1pJ5+cJqB9aiDefEzgmdS3e4rsz/3LWcnelbbJJUfcqcW5LZwA6TaXbHaFdZ5WHgOeY6
         My4RVeSOcXOLTGSA7DDd2wawXQewmO413lnYO7dWezsixZyhyp/HF4/bFcvsCe93ltrD
         yrwJx0ooiNAtU347MCgEm5xhqt+29YcW5AVcJWtI97nDCBjFE2no2MDPM607PuJXT+SX
         m61g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792953833; x=1793558633; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/PfFRzkpybBeGYhNyKbQey9szpqk7jsPsmdqcmjPvE8=;
        b=nA1tNR/bFM526rKd04ZNycVkqfZoqCabnbRs9sN6kgZFdKDm3qCgGB985yA+ZwVTnV
         NaPy87/pRt7MGsmFhzvChruvJgSUBmEU/CigJ/d1xuZywYnxU/IkCXw6BWBHkJUTS3la
         AC1ftl1rS2vHO0ffnLzOhNc4zNsbwf5k7/HVV8jzoX/GdlKp4vjwHxK/E7nZSND2OVAw
         QgiJmEza1+F45EiZyKnGP4FH4GRpn/+Y1qh1c+0iilxxznn2mDybqG6WP3I2o5Hlix0L
         B0WmBX49VRzo5Pm+XYW+ALtVzzBV3NvIxm8O7oBv0RQzYzvU1cdduh6Rn3S3+gN+5SHU
         6c/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792953833; x=1793558633;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/PfFRzkpybBeGYhNyKbQey9szpqk7jsPsmdqcmjPvE8=;
        b=Pc0kSwwWxddFOdx1faRbjtr1Mt12GLVenrNHeVbfjH5M14J1GJphweobTviuj7cbZj
         CNYnhdRPPptFvC/dxwcRIji+B5FSbCfN9CHwwN0UA9ygza6er6GBjyosLAsezySfkkpf
         +/rA2boFibA/otthZ7AsAeDRD/nAL3W0f6wQHvQ0mIFFnM3WutuhwBVhQssafl+6JCrD
         60tKJZmgR16Vax01ZC1bvwbmkX6AO63JE0+fvlXahWdA9BLycTeV29uPAb6iZWjAnUbJ
         M11C30thDxRwHCdYlnsLRzpAObn4yY0iBrkVJIINg7M1YccG+HZDZDxcNnzngWzQRXWv
         gHzA==
X-Gm-Message-State: AFq9FYIZQghDo0wmEZa+o01BjEl3lUF4XdXru/r5G4+6acEs+r9Sf+AB
	ygvuygdA2BEqt1E8fciPnCTAhbS5Xo0VogEB7G4t8DrWx5OHfq2W52Zv3OAjRihjWMXaWTHytQ9
	eyQrSelNzCmLhWkEVWqmbciAHP1L0VV2XR+esmNvST0hXmAg=
X-Gm-Gg: AYBFou3AbKu3jDyyGhhwUNK7rge2t3hjQhhpNWkstwMPDbKyxmhoivhj8Ddf1Twc8a6
	9nKZktLRXpu116CBew8tQsAOSSU8PshVe9T9AsBdE5Qw9dE2enwWJHIvIS7MtpNKr6z62X95t1d
	53IsUP1CDSUKl64lIe1g7yDhOMSjM+Tq043NlbWH3McUNUarNvY0tbuBSpd4bFUxhNU6+fyOGQK
	jW9mctot1OARSRM0F+T6pSsQMI/4zjyjMu6ZJBazQX6Kh4H8pga1+UAKl/8ETtEx8P/kxeBFktd
	miIk/fPDViYjj6guLwV3jm1fqTVRrK2SO0PBrhxq7o3shY0ndNiQE+KvBf8jjqEe4KgtXwjujw6
	+gI8XUg7Dz1kQf9KZifeNXcSaN/4D1HPKyNNVSupd2keeqV1nNCE3vvrLXsg=
X-Received: by 2002:a05:6820:3390:20b0:701:795:4ee4 with SMTP id
 006d021491bc7-70ba0f6bc25mr1483528eaf.76.1792953832810; Sun, 25 Oct 2026
 11:43:52 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: CryoSlayer <npetr9395@gmail.com>
Date: Sun, 25 Oct 2026 23:43:43 +0500
X-Gm-Features: AclHuK8mfXz0Y0npzhlL5JdQrel9vZGHzX7ClYAoniM1TlIpJSRIRUSaFvoDgSw
Message-ID: <CAEabPvLp-yeJSyLDwju7C_isBTTjkdAkoGz3uFwpt3BZAgTchg@mail.gmail.com>
Subject: [PATCH v3] wifi: rsi: fix missing offset bounds check in
 rsi_read_pkt() for SDIO path
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Nikita Safronov <npetr9395@gmail.com>
Date: Sun, 25 Oct 2026 12:00:00 +0500
Subject: [PATCH v3] wifi: rsi: fix missing offset bounds check in
 rsi_read_pkt() for SDIO path

The bounds check on the 'offset' field of an incoming frame descriptor
was only active for the USB code path (rcv_pkt_len == 0). In the SDIO
path rsi_read_pkt() is called with a non-zero rcv_pkt_len equal to
num_blks * 256, so the existing guard:

    if (!rcv_pkt_len && offset > RSI_MAX_RX_USB_PKT_SIZE - FRAME_DESC_SZ)
        goto fail;

was silently skipped, leaving 'offset' -- a u16 read verbatim from
device-controlled receive data -- unvalidated before it was used to
index into pktbuffer[8192].

Any rogue or compromised SDIO device could set bytes [2..3] of a frame
descriptor to an arbitrary value (0-65535). The subsequent calls to
rsi_get_queueno() and rsi_get_length() would then perform an
out-of-bounds read of up to 57 KB past the end of pktbuffer, leading
to a kernel oops or exposing heap memory to the driver.

The previous fix (commit f1cb3476e48b, "rsi: Fix out-of-bounds read
in rsi_read_pkt()") addressed the USB path only, noting it was
"unclear whether this is triggerable from other type of bus."
This patch confirms the SDIO path is affected and fixes it.

Fix this by replacing the transport-specific guard with a single check
that always validates 'offset' against the actual number of bytes that
were read into the buffer for the current transport:

  - SDIO: rcv_pkt_len (= num_blks * 256, max 7936)
  - USB:  RSI_MAX_RX_USB_PKT_SIZE (= 3000)

Also add a check that 'actual_length' is non-zero and does not exceed
the remaining buffer length, preventing an infinite loop and a
subsequent out-of-bounds 'index' on a crafted packet.

Fixes: f1cb3476e48b ("rsi: Fix out-of-bounds read in rsi_read_pkt()")
Signed-off-by: Nikita Safronov <npetr9395@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c
b/drivers/net/wireless/rsi/rsi_91x_main.c
index xxxxxxx..xxxxxxx 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -157,6 +157,7 @@ int rsi_read_pkt(struct rsi_common *common, u8
*rx_pkt, s32 rcv_pkt_len)
     u8 *frame_desc = NULL, extended_desc = 0;
     u32 index, length = 0, queueno = 0;
     u16 actual_length = 0, offset;
+    u32 buf_sz;
     struct sk_buff *skb = NULL;
 #ifdef CONFIG_RSI_COEX
     u8 bt_pkt_type;
@@ -164,15 +164,22 @@ int rsi_read_pkt(struct rsi_common *common, u8
*rx_pkt, s32 rcv_pkt_len)

+    buf_sz = rcv_pkt_len ? (u32)rcv_pkt_len : RSI_MAX_RX_USB_PKT_SIZE;
+
     index = 0;
     do {
         frame_desc    = &rx_pkt[index];
         actual_length = *(u16 *)&frame_desc[0];
         offset        = *(u16 *)&frame_desc[2];
-        if (!rcv_pkt_len && offset >
-            RSI_MAX_RX_USB_PKT_SIZE - FRAME_DESC_SZ)
+
+        /* Validate actual_length to avoid infinite loop and
+         * out-of-bounds index on subsequent iterations.
+         */
+        if (actual_length == 0 || actual_length > buf_sz - index)
+            goto fail;
+
+        /* Validate offset for both USB and SDIO paths. */
+        if (offset > buf_sz - index - FRAME_DESC_SZ)
             goto fail;

         queueno = rsi_get_queueno(frame_desc, offset);
