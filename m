Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64E83B0ACB
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 11:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855611; cv=pass; b=R/J+FveZvSBhjs+J3Mxz+Emqg1ztc/LWVAye8Gqdz3V8hGJ35pAQ5vMFb0LJy9Pl06Jj0Ff7oDEgYuGDVD6vBeqTpp8jL0wWyBAGENM+5sZZ41LH1QjlSRcGFdt00AsR3cjNZi7p/DkQpsoo5T33naVbuXyn8dtRAJtdR0bvcfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855611; c=relaxed/simple;
	bh=RqJN6fq+yDADBSewZeA9s6xeKTZgGpuwyz8QKWMviCE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=pAZ9C70jlAJfQzudHqDEAmAUjk2SkP5MtABSF0nahn7I2QjkuyICHjYd1AnxTuRtl28aUR8VBMvQR5UeSNwd+LyW9vxuRMWkUV8+okdJzwTUym8vN4Gbhkkmu/JqzREJCrYwDhccKyra0xYlcWg8wA4MO1u70v0NWIVsvmBs6uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jtGpVxT5; arc=pass smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jtGpVxT5"
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc750a1482fso3703866a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 04:53:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790855609; cv=none;
        d=google.com; s=arc-20260327;
        b=ggYP786Yu1CK0Ms4HUW1pUxb2BHzXhCTZqD+KcHueMoIdowojF4+1R7Klzm4TnvHb5
         G9jIloMOZd7JeM2WB/WWWv2WRhpYH4PAOh+nIW028fTSGFtJIJGsD+tT7XUAPJNCV2Js
         dBQB5AjvlEoUQBnzpqQVNG8QyUQe5E3PJXSx4q7bN+NhGluvSaxsbMdUDxYQ7dopyGOf
         mDWaxuKHIUo6XjtQ/+IcGSrDkBqnpbonnRwBFm4M7zMw7Jhqr7OOHqQ+Ie6CIyIP1/Nj
         uDcw80j6jIWfd9ogqQA2LypHfkKuOBGshG8geOjGzdmd7/UTnjrNGH1cyWKFH0ga1g0u
         k4tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=K5JT11P54xRVumRmWyIJX3lpFbuqWLog7+Jy6AcnxAM=;
        fh=FfVz1iWmQ52rIHqU2iKPF0LHgbreXC+8/3PA7ExiqQU=;
        b=oQZf4kvk6Msidp8wbMIx6afVMYS/aMgBmW7Cih8IawsgocReOFJytZmOKSdIGGjhhx
         ofKmk5ZL2QnuFuUTch4VSWnUPs7JgvLUkTuRqPewB7puOtI2JBMktmVqMRUTplb+WW7P
         bQDFufZVJUXofVgyGAIxfJFofunrGYuAeQpJRNdyYHvE4WPNY/J0/MnJzje17i80DuQ9
         brm28bRFKgc3QzZ8/2EVBPBVuoQfZN3x7bPC1gyqqjXaApkuaLZHJy49JgeF4q7ytL2a
         WluNKKzKSv7+jrXm2ibRqSf1bMQkqPloK3JYy/D4QMoZAO2XHfBBp0x+BKgBu0AYwrur
         ASUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790855609; x=1791460409; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K5JT11P54xRVumRmWyIJX3lpFbuqWLog7+Jy6AcnxAM=;
        b=jtGpVxT5wmaAyMlIOk8CkO+z/RCdvXAfvoQ433YpcdJ95hpHyReKZvSJ8zCErKxOgC
         Jl8klf05CrmFyM4c1DkafLsxHj4utenoT+vYi/+5qB0H+5jd7umX51wO1OjKbF3izsFk
         sv7Sw3TI9QhjD4LvAEgJXX349LARet3dspgtBmJ75qY01XzbuM8K8dDS/sWI5fgE4+h0
         Az+Xid/j7GomL/oHZSgWw2lBikBoOUXtkSN9My/SpuH0YL2Dr/aJXW2kwk5vS5Ho2qHa
         T3SQyzg6cnYtX5eWTgQThBO3Gt8mko7COu3i4D0o6bnCLtSgQt2j8GS8AXTiDO6Ycznt
         RWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790855609; x=1791460409;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K5JT11P54xRVumRmWyIJX3lpFbuqWLog7+Jy6AcnxAM=;
        b=glpiCUJg5SNctvmGRavZOqLDwRm2k1oQWNZaffBgMkxt0WV000/shCE8Kb0WDx43y0
         q+g7VfQECUDo/u104l5BmbB59QbQ4leSVr3qz4OPBGZE8z9sIAiLpJi5IKM+NhibMEiA
         cMpnDiSWf9yZclWvynIQY91KOGks6o83BuYv0P3Qj2TNAY7g453pRZTYzpbd1pk0mjCL
         HpQB/wFfEJUzxRIHGuFW9+z7JhMmo/ei3hGRj33VtRlmaQ+Q45BFwQUvNo0Y/RLSFR+l
         N3f0yfZCH4f6kaXlkhNkR6s39i2YooAiC+qybqX+3cGS7fU/+Wh7vKIB1s6XR++pCBxN
         xdGg==
X-Gm-Message-State: AFuF++n9mES8cn5zTRTSNtmYn5K0I05Fe9ik3kuz4nUwIz/D/XvRLajL
	k9sQgMAR8pu5zKZEpNi8lJsVjFsK5GJvA5qRpaZ1/RlfR7Ha9BjGwW7wl+EyLO/+VT9r65U8Okm
	HuFyv5fXFzlnpY+XYsGyhZVUzrCmrnZHY+CGg
X-Gm-Gg: AYBFou0TIkeja6PBJ2lzWkC0VWCIRdUfRwPPscK8pmJHALjkJyweOakHAPvwAJXXsgs
	Tirc1YIsaXYsj8VQaGZJwCkNBCn6wS3OWnomfcL7ZGujA4EpTSxoVWhT27NYHt3dB7qc+HLaHlK
	KI6YUs+jQ4gWv78u6t0dlGM7ZwRRzdeRhPsBNfj+1MQLH63Q2uq3Xb00t9PQ9cUbG+eFeI2uo4U
	NDtjco1US4v5CjpawB3aHkZA6xGa1/H9wlKBJp59WUMCsI7VC5Mx8XU+RVzwqNbdjzTEaGPJuzb
	CFe8zaWtb/aWrg+oLn9ThArR2E/rN4O5POLQI4QKTi9oHjZ/IN5ouwLD
X-Received: by 2002:a05:6a20:db0c:b0:3d2:2afa:d7d with SMTP id
 adf61e73a8af0-3de9e7aab03mr5017557637.18.1790855608923; Thu, 01 Oct 2026
 04:53:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Chris <hoopyfrood42@gmail.com>
Date: Thu, 1 Oct 2026 07:53:15 -0400
X-Gm-Features: AclHuK_GhjSJfSBUgaP9P13fm5bUX41GUC3DjFSvBjo9hLwxm673JLqEbik6qV8
Message-ID: <CAHaeJsRxXsJsHXdg7YZU3J0G0cJYJUZqHrXdAYt4nFUOwNdkoQ@mail.gmail.com>
Subject: [BUG] wifi: mt76: mt7925u: skb_under_panic in EHT radiotap (monitor mode)
To: linux-wireless@vger.kernel.org
Cc: "Cc: Felix Fietkau" <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Deren Wu <deren.wu@mediatek.com>, Ming Yen Hsieh <mingyen.hsieh@mediatek.com>, 
	Devin Wittmayer <lucid_duck@justthetip.ca>
Content-Type: text/plain; charset="UTF-8"

Hi,

An MT7925 USB adapter (Netgear A9000) in monitor mode panicked my laptop
with an skb_under_panic in the EHT radiotap code. This is separate from
the TXRX_NOTIFY crash fixed by feeff151c83e (that fix is applied here)
and from the survey issue I reported on 2026-09-26.

Setup: Ubuntu 7.0.0-34-generic, with mt76 rebuilt from Ubuntu's source
plus feeff151c83e and Devin's "move the channel survey" v2;
mt76_connac_lib is Ubuntu's own. The adapter is in monitor mode, hopping
across 2.4, 5 and 6 GHz channels, with Wi-Fi 7 APs nearby. It has
happened once in about 2.5 days of scanning. From the kdump log:

  skbuff: skb_under_panic: text:ffffffffc16f4a3c len:164 put:16
head:ffff8d4132ca3000 data:ffff8d4132ca2ff0 tail:0x94 end:0xec0
dev:<NULL>
  kernel BUG at net/core/skbuff.c:214!
  Oops: invalid opcode: 0000 [#1] SMP PTI
  CPU: 0 UID: 0 PID: 1076104 Comm: mt76-usb-rx phy Kdump: loaded
Tainted: G        W IOE       7.0.0-34-generic #34-Ubuntu
PREEMPT(lazy)
  RIP: 0010:skb_panic+0x59/0x5b
  Call Trace:
   <TASK>
   skb_push.cold+0x14/0x14
   mt76_connac3_mac_radiotap_push_tlv+0x1c/0x80 [mt76_connac_lib]
   mt76_connac3_mac_decode_eht_radiotap+0x7a/0x1d0 [mt76_connac_lib]
   mt7925_queue_rx_skb+0x686/0xde0 [mt7925_common]
   mt76u_process_rx_entry+0x2eb/0x330 [mt76_usb]
   mt76u_rx_worker+0xeb/0x2b0 [mt76_usb]
   __mt76_worker_fn+0x58/0xa0 [mt76]
   kthread+0xf7/0x130
   ret_from_fork+0x195/0x2a0
   ret_from_fork_asm+0x1a/0x30
   </TASK>

As far as I can tell from the source, mt76_connac3_mac_decode_eht_radiotap()
pushes the EHT TLV (48 bytes) and the U-SIG TLV (16 bytes) in front of
the frame without checking the headroom. mt7925u sets MT_DRV_RX_DMA_HDR,
so mt76u_build_rx_skb() builds the skb over the rx buffer with nothing
reserved. The only headroom left is the RX descriptor that
mt7925_mac_fill_rx() pulls. A descriptor of just the base words and the
P-RXV (group 3), with no C-RXV (group 5), is 32 + 16 = 48 bytes, which
matches head/data above. The EHT TLV takes all of it, and the U-SIG
push (put:16) runs past skb->head. The code came in with 97d7ab9f51ec
("wifi: mt76: mt7925: add EHT radiotap support in monitor mode").
mt76_connac3_mac.c in wireless-next today is identical to the copy I
built from.

I'm now running with the change below. It leaves the EHT fields out
when there's no room for them:

--- a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c
@@ -210,6 +210,16 @@ void mt76_connac3_mac_decode_eht_radiotap(struct
sk_buff *skb, __le32 *rxv,
       "Should push tlv at the top of mac hdr"))
  return;

+ /* The TLVs are pushed in front of the frame, into its headroom. On USB
+ * the skb is built over the rx buffer itself, so that headroom is only
+ * the RX descriptor just pulled: 48 bytes with the P-RXV and no C-RXV,
+ * less than the 64 the EHT and U-SIG TLVs take, and skb_push() past
+ * skb->head is a kernel BUG. Leave the EHT fields out then.
+ */
+ if (skb_headroom(skb) < 2 * sizeof(struct ieee80211_radiotap_tlv) +
+ sizeof(*eht) + sizeof(u32) + sizeof(*usig))
+ return;
+
  eht = mt76_connac3_mac_radiotap_push_tlv(skb, IEEE80211_RADIOTAP_EHT,
  sizeof(*eht) + sizeof(u32));
  usig = mt76_connac3_mac_radiotap_push_tlv(skb, IEEE80211_RADIOTAP_EHT_USIG,

Two smaller things I noticed while reading it, in case they're useful:

- With no C-RXV, the decode still reads rxv[4], rxv[5], rxv[8], rxv[9]
  and rxv[13]. Those lie past the 4-word P-RXV, in the frame itself. A
  mac80211 warning a day earlier, from mt76u_rx_worker ("Rate marked as
  an EHT rate but data is invalid: MCS:0, NSS:15"), may come from the
  same kind of frame, but I haven't confirmed that.
- Even with a C-RXV, the TLVs are written over the end of the descriptor
  before all of rxv has been read. With groups 1, 2 and 4 also present,
  the U-SIG TLV's memset lands on rxv[12..15], so DATA0_SPATIAL_REUSE
  (rxv[13]) always reads 0.

I worked this out with the help of an AI coding assistant (Claude), from
the kdump log and the driver source. I'm happy to test patches on this
adapter.

Thanks,

Chris Kelly
