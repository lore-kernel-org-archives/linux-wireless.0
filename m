Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F370D522F03
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 17:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790874411; cv=pass; b=qML+w9g1AEam30xlouKeUQOHsix6xJJxpcbKnGgNfLkZkF1MQXK+p2uoxCaRLPYWJMEwOWoCdFPFQa5l0e44PfrU4jCV4+in+kYsRVp17SW5Mye4cRTV4OfL0PAFd0pgESEFGGeoKa6IWDlQArzLBAqB+3qKEbYAaoMFMiyEBnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790874411; c=relaxed/simple;
	bh=RqJN6fq+yDADBSewZeA9s6xeKTZgGpuwyz8QKWMviCE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ubGgPueC16CTstMN76cnEfIX9R8ZCXVpISakmjDUwgAYsHObl2U4vCcHR06JTxiQaAm8zA5UZbpXm1BvjivzuEwdhdp0H/bMhZbuEAydIg/7uV5UbeN43sJ0EvcCuhdRb4Sy4T8VnpxngIJFXlYp9gPIqnPIHxkU+iHdv+Vjhsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D4N8GPsb; arc=pass smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4N8GPsb"
Received: by mail-pz2-f37.google.com with SMTP id 41be03b00d2f7-cc7c4c92477so2317502a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 10:06:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790874395; cv=none;
        d=google.com; s=arc-20260327;
        b=kYoh+wB8ziT2nDzuEvaRtBPyPrutg3fwaSf+37PYa5rffDluLG7Tpe6UDapEq1QstX
         ZByw7N6e0OtmItuZPsp4ZtIFiFc5TOxViQ9a513mL5pbRc/MmWjyn8+YkpOxG6c9f39a
         Eg6mNgneZZDUH5YFxk+X52PaDR8DE05o6LCAa2RwLN1Rukno8Cg7rNcXj/IiE0786NQB
         p38IvVjaLCrmXTnSrxT39PZh13ZoCKenRBWPwfHklVLSkutqYgfMfAQPJnD3k8jjQfT7
         Plitdikvig7129ZmW7M9ZL7s25G2iE5ZSLdbSd50LcunpsJvj2NQT8zFwwjLeJTYrhLx
         5GTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=K5JT11P54xRVumRmWyIJX3lpFbuqWLog7+Jy6AcnxAM=;
        fh=PP/whk6UaXLnVOIlOxkM8+X9+lOT86+4o8M68YAJ3/8=;
        b=VGBe6SD9ejqiF4cmgRhPZS6D7+K9/DceNyGrb51ijfNISuYytWTWZhzEc7k5w4BceH
         JyX9tFpbY8dwfSiC/vJKikQv5QOopqM5BSKPCIeE3DhnerPSmmb2khMb/wPT1RuQUk/6
         B3uX6L0n62xUg5WZrwtq96D3aFY5hLkSgqIhWWL/ecgFviHlKjENGV/UiuaM9RPJb9TY
         1Tm1Gu/UMe4re82zBYvdw9vMvcowqC31uVpQpUqjfmsYAxaC6UVhmTHeCAFsMI3DtXYy
         sz9+7mpwGsmbHMmzgIXzZGesmuyCY1C+OAQbrEZnjG0LSmkdyUESgUorEGUWCgJ2Ivvz
         b/xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790874395; x=1791479195; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K5JT11P54xRVumRmWyIJX3lpFbuqWLog7+Jy6AcnxAM=;
        b=D4N8GPsbFV3ciwOZ9+rJ51atq8DlWImMJTSUeNfk67SPTvHrPLSjt/ysM6S1fBcprf
         NH622lFieryAu8PnY7svS8rwQXoXM3ig3NkikbhP9ey26+c2gK8Y+v7iaYEMu5Y6CqZC
         rzUszAEl27STOPNnnr9r9SNAvcTWczA96ZZAm+fhKFgJqEqsCp3n6I/RXQE9/NRW92Ip
         BFdws52tbt0atzRksIE4//9jnPJyX7fOw59fDFnhqs50dl0ztPaxNpfRHkTRoQ6bOetz
         p0tWWeyEh+xBKJrI4ZQ/RDAyVW9AIf+ioclTryRST6wp5CoJEs3Z2QmguDdbJIBPpZOR
         x4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790874395; x=1791479195;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K5JT11P54xRVumRmWyIJX3lpFbuqWLog7+Jy6AcnxAM=;
        b=E4XHHHyfijqNxjhM5AVfct+BtAiwGpt9wdDuyOgBYNjno9VPSgRAelPdA71sJk+I81
         dMmBCJ/emZI55S2dH4Fn9/R2PPTnx6l6slCxdDn3Eo/+h+wFXmCSKVBwVIgwrfO0Rs6U
         P+t3dozM3JNaXMcGMMViOW3qDEy7nPsm00537FgQCrkaUmSwJh+dsfqpireEm7njd1+K
         VtqiNsk5gM1H+U3aLcmVN/hGFSpLlKxo7xxqz4qdN/aANrJU/MLI+RoE6zDHD6GH7nFH
         d85k/uGbvVt3qpyh/P562buLrQLdh0CcZRO+lJG60Hk/aoDGGRKxxJoQPOuyf7C3JLp0
         JF+A==
X-Gm-Message-State: AFuF++ks4DrFAyiHaTcxDwsFEnAmvY58l4mYFIv3hzQMQsfdZd1syleL
	Z/dOgZLeEb7ugzFLzX6U9CzqvsPoku807YO21PNJG+aZOT8LqZwnNAboDgAgEKDsgjAu4om6FGv
	a9orbMzXb/9SeWY2X+HPNZp4CaT5M02GHa/me
X-Gm-Gg: AYBFou1dCQDsr8JnsuC7Fj7BS3GmF+ySf9QF+f+v5L9swAFre6BFD3Gro8HjzC1wFWb
	8jtVoljCrK+1gdFOV+Vs27KZTCR/TkmZXxosd6MDnOc2SIdHkohQFINu9cA6et5+oZSd/30+9li
	7Pp0EzTB4KmyrqGRqIcORajDnIG03pkJf65SGdgy1Fhg02BOEdLyMnCotQfZgHORY7+WjkobN3s
	+G7avcK2BPoYr7VNbh3pujkvVYK00RzYaqlWAteS3zv08W7tdVQUJp7JOKtX6Sdtlf9uZfXH38I
	NlVqj1aCI8umVTm/Z8O8fgmMFfk4XfkdcNo0f0fV+trQXdz4vsqbEZwL
X-Received: by 2002:a05:6a20:258d:b0:3db:3e1c:8585 with SMTP id
 adf61e73a8af0-3e0bcf3bf12mr26815637.27.1790874395258; Thu, 01 Oct 2026
 10:06:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Chris <hoopyfrood42@gmail.com>
Date: Thu, 1 Oct 2026 13:06:21 -0400
X-Gm-Features: AclHuK8ovqgMPyMZkpNuwKx9QccSBKEru8WYA4MHzH9Zpk_niBC0KU9-4oQIiGM
Message-ID: <CAHaeJsTkLGnUhssCDCTsc3=y5FidHCsQ+_AwK_xsgeKw+TZCSg@mail.gmail.com>
Subject: [BUG] wifi: mt76: mt7925u: skb_under_panic in EHT radiotap (monitor mode)
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
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
