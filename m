Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792928126;
	b=X1GFI2lI+EGdBxNbhiPd+ymDiwIMowh8eAY5zNiJL+TmAZGOqRJgDds0EriryMpHSQl+
	 uJWoaFWzY/ol5+YakoK1sl2+gVBYf3vOwLnfUsCxeiPboD80SGSAD0Aa9Wc8AunVHZHsK
	 b/6SjTC5DtiAoHF8Dt2+epzx4xXMnceDU9HH4rfIiJE5hM/z64TH5F7jtExdU9xDiPJz/
	 TKXHZnX3JrIflIw5dQ1eS2BFET9iZYIU/ujKKU6ENHSejmIzrkg5UDQf72Emm+KU73A+s
	 7Swvl/4Ej2OcCFBWVjctVdcpmsgThGG2yHhVmvmjKmekC6dQS9ZL0AbOVfHdQc4e/lA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792928126;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=I46pvyDzP5qN36xnQhB4ZzrGviDLjmJ/e3zq1M+T5SI=;
	b=1CUrVE2evV23bo6ORcS8DlOy461aiviGzCuprGFp7/NpaikPv5ZZhvxbOUYyuxkmqAI4
	 D4SawDsnwcLN7Xu2WFYDs0NiU8yXXq6HEP06nnqw3MJWlhJ2W71w7g8QSwvbP+SykU4UN
	 zrmKY6uediavxMJrkGQNSjDY9tqgJ7nlO9ynmKEMCOJg6Cbi1jksSzZ8sjZD2YAy+mQtW
	 nymZvuZOSX1Merpw+ijjWqWbxxUYKxS669tuXzyscz8mJDLxHz5LnsuFxeguiybKAbGUp
	 6FWj/K7+Ax9WOFGMyY6FwruE7McFu0ubFEs6Fmvrpxz19OGhbpqFbvePjGd8POlox1g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=j2nC5xEQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.46
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20E6606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 11:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D20E6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=j2nC5xEQ
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6df7f544919so1307940eaf.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 04:35:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792928125; cv=none;
        d=google.com; s=arc-20260327;
        b=QqCODcdrSH0sT/OI5CoJKbAcSa+obrQx3uOhTGFFkjrhuugtT+0wp/tmIOn3j3EuBX
         hIr7vPwlKiTlGvTMoO07QExkJik6zRQnLl0dMsof9pbyRAnNdDtGZOUJW1TZruHyBkI1
         QJpHAtE5kIVu9XQ4jJoZso+p0HBHxLXZtvxJRkFiWHyml57qj+f5ulDNLx/WPcpv2KuR
         RSdYDbpYXzovhVN0Y19g1jI000pazbsRwCbmAOIrG1OBRjdseP++phAkT5fGswpmE+EC
         yuDxXnofik2DBW6WUmbw6YnpOA57z9vPbd6MPm0txAzRdDvM4BKRQT5Jon3NX/dNlobg
         6BUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=I46pvyDzP5qN36xnQhB4ZzrGviDLjmJ/e3zq1M+T5SI=;
        fh=h9gs5bZBesubHJq3bGrWBGC8Kv6CCTO+905mKwzSl5U=;
        b=dT+bTCjc0Iz9nvZaFdp0SgRmST1zxKFSsSMJXV5gT2NPTM7LjlWZYu5P/Nf8ygu6To
         +Hybs21NWV2axMhBuZGxW770Qj9qS5IThJlWFNf997ULeWGtRSCqSUxMYCFrQGqu3U2U
         Qn8T0vlM7LxCxZ4AnCgQ91xVUemqec1yj6HbWaAYNMgoRVza0x13/eTd542RNkOKljEB
         KP6BEhmdOWauLNh3F3+beA7/EryHLAzbb/xu6gddwtvYuUBrO5htTIf/E7inlgvBgtdR
         /59UEJ13pM0jYPqCWrs4ZmymPHtGdx4Hn+ZoJBSObXIZR4B66L/o0wmJ8miVmA6KxJup
         iUZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792928125; x=1793532925; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I46pvyDzP5qN36xnQhB4ZzrGviDLjmJ/e3zq1M+T5SI=;
        b=j2nC5xEQNsyT+0wariV1wN7BBNPs0MiyNM3V5/V4Lbhojgbz0BIbMEjLH1hhbrV1nF
         +yFeQXB1GrMY20Ss36MnU+bzr4tCSdrWM6n/tixho76idOWQ2r+wsII+4YlcN+0g88pn
         UqCynjTp7g8ZhCvX0aSSfFUNO2Wgf8z5yuR6mz10lM2kZDKAUFB7l/4itRa9AgNQuVMD
         o1rOICwTjUVVAWXfuBZM6kSlcGddzhJr7d62n67vCC6eJ+wI9ahSXliM3j5hlxs1vZo3
         +Wob03IXyjQV37IRsZLbmCU/Zoz1iPb9Y6c8oa9CyeV5XRLJe1oo/WyJ9xUMuVwbLDg0
         SzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792928125; x=1793532925;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=I46pvyDzP5qN36xnQhB4ZzrGviDLjmJ/e3zq1M+T5SI=;
        b=KEfJ+E24HgTR08xdEJZfpMXtov69iS+d/PZU0e31/8Z6/nQJVhrssXuY8ZNYjOpCGq
         txtoRERMW4qfLc43ogzlVM7paoRS9Y6/qLCKJTkxTqnbhyBDftqMk9Xw6x4vzW9Dl3te
         7UP7dnoCpE9isnE/ayPjuUEqg5+ka63AtBgVbVOE3mIzVEm1v3Y0yO74DE8EB71+iO6X
         mvOhf2YRaN+3buulb7Ng+qzQZP3x8vI6/kkBY/IMEX9IhVx46s0egI4k7W+Gyb9VSfoe
         shrRq0pGPCPNAhLGkNsFcwCtdeIw/Q/gO2S4lzDMHwof693KNuldSCpTJVqEVF+ro+F9
         EdQA==
X-Gm-Message-State: AFq9FYIBsFhs5BrCxIvWQiA/oheN5jIg+DtuWLabA3XP/owaSLRwlpKt
	lj1DLHQ+2PV1TfN7obBfWJ32M5uCi1UnQZoCZgXkSgQbBymQxBBFyQeoc2bmyeAq9ZwBLfE+jic
	Nk88kMVYCQ4vZrBMKcSpNKdxUMObfQFCxpVvZunhu4eE5kamqzA==
X-Gm-Gg: AYBFou0DFwlHXdY8EIgeTqh2k20fKrPYhI7x9r1e1KT9XzC5Z2/h0Aag1fwoPpjlrGc
	uIVwIRGMkEsPSoSFQKDsVd0uU0VLcpvtip86xRCKAaacihDi2PEIsq+1xuVD0jUVUSMrbN9rbwc
	AsSaiTIX15Z+jE1CLm7eA7N6mVnzCgNT5sVw74UT/MXkGoJmKZ9Gxh2y5QQT/9jfUir2fDZPJf5
	2F1xB6st3KqC8ypmdm8NvJn53DWOKsINHrsWYLwKze9FsyhgJqc4C3vDmF7/wXrDtsILXAnnZXZ
	YyerIFh1pkzhwBp3vRbeiMJuHnOEk8yMzZeTdxPZmnySB4UlCmM8SxIW+Ys/XJxO2xfpTlqce/P
	vPvrQlg1L0c/t8axbpGWXCBtytnVhkmStv8BonDS+bLNAx/T6u8du3iwfG4o=
X-Received: by 2002:a05:6820:560b:b0:6e0:fd89:f011 with SMTP id
 006d021491bc7-70ba0f61d54mr1333913eaf.65.1792928124639; Sun, 25 Oct 2026
 04:35:24 -0700 (PDT)
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
Date: Sun, 25 Oct 2026 16:35:14 +0500
X-Gm-Features: AclHuK_vYvQ4cGE0I_at9GmhF5Joc-idnOy7JuLVojb_04ZGkVw5O8YAiT4amDc
Message-ID: <CAEabPvLTeZ4kmgRsxdGLdfX1F7QaPWAKi=UU04ivjH4vfg3KjQ@mail.gmail.com>
Subject: [PATCH] wifi: rsi: fix missing offset bounds check in rsi_read_pkt()
To: linux-wireless@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

From: CryoSlayer <npetr9395@gmail.com>
Date: Sun, 25 Oct 2026 12:00:00 +0500
Subject: [PATCH] wifi: rsi: fix missing offset bounds check in rsi_read_pkt()
 for SDIO path

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

Fix this by replacing the transport-specific guard with a single check
that always validates 'offset' against the actual number of bytes that
were read into the buffer for the current transport:

  - SDIO: rcv_pkt_len (= num_blks * 256, max 7936)
  - USB:  RSI_MAX_RX_USB_PKT_SIZE (= 3000)

Also add a check that 'actual_length' is non-zero and does not exceed
the remaining buffer length, preventing an infinite loop and a
subsequent out-of-bounds 'index' on a crafted packet.

Fixes: dad0d04fa0f6 ("rsi: Add RS9113 wireless driver")
Signed-off-by: CryoSlayer <npetr9395@gmail.com>
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
