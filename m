Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5E347607B
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 19:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790883442; cv=pass; b=GQMhymfoWEmwsn1pMcmIWjdDlx387RBbVaLxa8gupx93f5dAElhTz9/Btl7MRIz0jDjs66IG8EzkxZ9DgH5bLhpjDCQhrF0vCkW7jrBzrfzNPT/k2J5kF1yCNxCY29zFO8CDO1pQ85lUwrUhOBYu9cAKOzwinrcqaB7ayHjyBB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790883442; c=relaxed/simple;
	bh=ptnsyPxUt/cOX3q3KqSdQ2MO2NStPoJf6fRFmBAC6xY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bkkKVzVwgH6oFfkgXVvZRDH6gQO9Tjj8uQBkR/+0up7aTpQoTVKx7ZgTT6Z4ZgQ4xb2AWUnCpOG9YP3vsL0XEXPBGWwFSXXWzW9dH/EDHfJOLt89/U8VZhtk+OkHEc1xYce/Ca6UM2MTBGi0Kj5R2hRWQMM6hTts/rJK6y3NNUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SN/czutE; arc=pass smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SN/czutE"
Received: by mail-pz2-f37.google.com with SMTP id d2e1a72fcca58-887d4b0e846so489003b3a.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 12:37:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790883438; cv=none;
        d=google.com; s=arc-20260327;
        b=OpYCwdDbiG1LM0jkBxZbPKY0+Qbyp7y/t7PDRKR2VXki1PhDn5joVJMKMX3XvYIHnE
         krM0ZF6huKiA6PvirB2nmOVIJp5+MbgYVQC0qJA7U62awTZQGx0CLdFNg37P88MY57Zj
         2stYv5k5Dyc77Rgh8xQy6VslWw8ghx2OgBHZYm5HGL9hn/txWW1c2PRQSWoOGBUPvz6C
         cMhOgYm05nVnFaBNOihEb2GkgfBvKsLUVPdvjq/J8ildQbVoGqvGHCBfXJNDdO0N8Z0L
         JR5t62d/8cL2ycEHs5k+Qqoyj7sf4ZVExjnEvXrEBSjztk+lm1htNbdMMoPbCDMVCLS0
         S7kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GZGfsv2fyA8/iLkosK7wQlUAa3cwLnNMKOsuW5K4GSk=;
        fh=KOcm67SkvvB4uHvQhRmz2fvQHbLMMuQo4c8tb6F7Njo=;
        b=HCILgD8hx95JPGAlE2V1WkJpx2YGtlSZcA2/FIyuHUY42PCSSSkTHWw6GlfhVVxKwj
         xpPe/8HxLCCQ2EX6QwsVWfwr+3PlfBVGGB/frLE/pMH1e7CU1AHhfYWu6L4SoynRuVMm
         p+6tEFJi5EcaVyF4K0E76PSDPUGvG3ULYa1GUE5WGCosMjfImHm5U3KmXNk6ZX5PgQaI
         xBP5cCO2KDFsqbWRcuXh10NVmJPF0DI7bfaTISUf7kpZznb9awNRLxGC/jbCEY1jCnBI
         0fvynW/ubJapOo3PMVavUdjWCuQg/az7oKbAJv2T3cxBm0ggDEssnMhDPPU55exR47dz
         8+Vw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790883438; x=1791488238; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GZGfsv2fyA8/iLkosK7wQlUAa3cwLnNMKOsuW5K4GSk=;
        b=SN/czutEnJ4xCabuTXrEzlXlby4+HSNTMKK6uoiHQCaUTvCv9igElz4eNqT1GaWDJi
         X5h86eKxF/pGDx//KWszXGh4yTaw1F+2j4HGkrjbLvmae4rou7RvT4evgWh5VqHKgSkJ
         t7JjlTNw9RbnRrGF85pqKx4OCrAB28JDQWC2BIXvlMOJRGuAbSxNRzPxdTD0HXLrvKB0
         cixnsfsd7lpioQCSM8OX4rQrgJX4ejV0Xea6WoXyD+dayOqSaK7ftNjpNbeDTDKq3DtJ
         /xL23rKP4khnxL3o6MARvkes3KcsTX4GOW0Wpe6KGbL4XmzanciHwVroSiiETgdtj28A
         9PyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790883438; x=1791488238;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GZGfsv2fyA8/iLkosK7wQlUAa3cwLnNMKOsuW5K4GSk=;
        b=KeV7Y1LlKG0RhiQsd9pb3bgiMR5OL3WHFjlwoZl95UO3NHygVtgruPGe2Kl3YdkmY7
         UBArLoXtyqqySxmW9J2waCPmD49Fr/mOkLPtyx3+Bq09LSR2FuBds4yxYKwIqsQdKdCj
         pNnBNlcQn4d9DpgoQV6ZAZtkL2zyhBX031rxANYT1mMkqNbMcb7bmmjN4psIXQgmGB11
         vk+Fw/v7ZTAdagjPZsD0D0wBF4ibtiWaJREcGlXt5uhZ9GgWYwch9+fIb5lleUrt7xKK
         Ab51R3lyyr182C0sgRAeArWmVyn/GwPTG77jJu61xzIii+dE3Uinx2BkPLyx1QZX2BYI
         Bj2w==
X-Gm-Message-State: AFuF++k1QJscnDNtKaT/oSyksVvnArEGerKxg0Cov07Wx0dxjlJY8Xll
	aClKXV6QJTzsAOl18SiOY0qcs+rbIWvFz+GgsghyXOOAuvqzbiSygf5GUbi+bfEK3QCUETDGcq6
	s0QNTO5fPwVPpb14bUV7ts5w2FYC0A9w=
X-Gm-Gg: AYBFou0ZrAlojHatLMl9HkYFfs229GMygIRQiUs/tE0z6HTTixakEQEKNvNsm0pGz2/
	KgW8Kx97PGk1uvl/MQjYUomW5n7zqrJ5xBvuhPMI4mevl6/KH1bXNUbYzqWc0FoPfGyFCEFN6oL
	Ei14LRrYRoCNWf61rXjz1xMQj5BIrvbFHZ0WwSWrQknLVVNGlfjGvqoIQV/xqcAiPTBATwDfKcZ
	Y8c1HmS+7NvQZn6aQHwY2BW6X+7sGsmW66adX82vx/HvOQY3Ip1rapjotZZ0+RkTYcacfjYGQS2
	J+Omln5W2nHIqA8kB8ve/dm0bFn8kLfXozgecmfwxlI8QwfsG/kvCnCk
X-Received: by 2002:a05:6a21:e105:b0:3de:48ab:3b90 with SMTP id
 adf61e73a8af0-3e0bd247258mr230906637.26.1790883437836; Thu, 01 Oct 2026
 12:37:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261001184529.502048-1-hoopyfrood42@gmail.com> <3c8de083-510c-302a-c053-2208a71ce688@candelatech.com>
In-Reply-To: <3c8de083-510c-302a-c053-2208a71ce688@candelatech.com>
From: Chris <hoopyfrood42@gmail.com>
Date: Thu, 1 Oct 2026 15:37:04 -0400
X-Gm-Features: AclHuK84ndP67yVDMOEWv_Z58TGHOlXFAAcbV6UI3AW6HMncQc5VrzzmEusBshw
Message-ID: <CAHaeJsSeqsE=cKheQ-4-O=OSt2wO-4Ryo3nxTkbvjYZUY=Or7A@mail.gmail.com>
Subject: Re: [PATCH wireless] wifi: mt76: connac3: check headroom before
 pushing EHT radiotap TLVs
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name, lorenzo@kernel.org, 
	ryder.lee@mediatek.com, shayne.chen@mediatek.com, sean.wang@mediatek.com, 
	deren.wu@mediatek.com, mingyen.hsieh@mediatek.com, lucid_duck@justthetip.ca, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 1, 2026 at 2:53=E2=80=AFPM Ben Greear <greearb@candelatech.com>=
 wrote:
>
> On 10/1/26 11:45, Chris Kelly wrote:
> > mt76_connac3_mac_decode_eht_radiotap() pushes the EHT and U-SIG radiota=
p
> > TLVs, 64 bytes, in front of the frame without checking that the skb has
> > room for them. It may not: the rx skb is built over the buffer with
> > nothing reserved -- mt76u_build_rx_skb() with MT_DRV_RX_DMA_HDR on USB,
> > mt76_dma_rx_process() with a zero buf_offset on PCIe -- so the only
> > headroom is the RX descriptor that mt7925_mac_fill_rx() pulls. A
> > descriptor carrying the P-RXV (group 3) but no C-RXV (group 5) leaves 4=
8
> > bytes: the EHT TLV takes all of them and the U-SIG push runs past
> > skb->head.
>
> Can you also increase the headroom when monitor mode is active so that it
> can report the data?
>
> Thanks,
> Ben
>
> >
> > Seen once on an MT7925 USB adapter in monitor mode, hopping channels:
> >
> >    skbuff: skb_under_panic: text:ffffffffc16f4a3c len:164 put:16 head:f=
fff8d4132ca3000 data:ffff8d4132ca2ff0 tail:0x94 end:0xec0 dev:<NULL>
> >    kernel BUG at net/core/skbuff.c:214!
> >    RIP: 0010:skb_panic+0x59/0x5b
> >    Call Trace:
> >     skb_push.cold+0x14/0x14
> >     mt76_connac3_mac_radiotap_push_tlv+0x1c/0x80 [mt76_connac_lib]
> >     mt76_connac3_mac_decode_eht_radiotap+0x7a/0x1d0 [mt76_connac_lib]
> >     mt7925_queue_rx_skb+0x686/0xde0 [mt7925_common]
> >     mt76u_process_rx_entry+0x2eb/0x330 [mt76_usb]
> >     mt76u_rx_worker+0xeb/0x2b0 [mt76_usb]
> >
> > Leave the EHT fields out of the radiotap header when there is no room
> > for them; the frame is still delivered with the rest.
> >
> > Fixes: 97d7ab9f51ec ("wifi: mt76: mt7925: add EHT radiotap support in m=
onitor mode")
> > Cc: stable@vger.kernel.org
> > Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> > Assisted-by: Claude:claude-opus-5-5
> > Signed-off-by: Chris Kelly <hoopyfrood42@gmail.com>
> > ---
> >   drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c | 11 ++++++++++=
+
> >   1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c b/dr=
ivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c
> > index 651fcd4..0ed8ee7 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c
> > @@ -210,6 +210,17 @@ void mt76_connac3_mac_decode_eht_radiotap(struct s=
k_buff *skb, __le32 *rxv,
> >                     "Should push tlv at the top of mac hdr"))
> >               return;
> >
> > +     /* The TLVs are pushed in front of the frame, into its headroom. =
The
> > +      * skb is built over the rx buffer with nothing reserved, on USB =
and
> > +      * PCIe alike, so that headroom is only the RX descriptor just pu=
lled:
> > +      * 48 bytes with the P-RXV and no C-RXV, less than the 64 the EHT=
 and
> > +      * U-SIG TLVs take, and skb_push() past skb->head is a kernel BUG=
.
> > +      * Leave the EHT fields out then.
> > +      */
> > +     if (skb_headroom(skb) < 2 * sizeof(struct ieee80211_radiotap_tlv)=
 +
> > +                             sizeof(*eht) + sizeof(u32) + sizeof(*usig=
))
> > +             return;
> > +
> >       eht =3D mt76_connac3_mac_radiotap_push_tlv(skb, IEEE80211_RADIOTA=
P_EHT,
> >                                                sizeof(*eht) + sizeof(u3=
2));
> >       usig =3D mt76_connac3_mac_radiotap_push_tlv(skb, IEEE80211_RADIOT=
AP_EHT_USIG,
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>


Hi Ben,

Thanks for looking at it.

When the guard fires, the descriptor is the short one: P-RXV but no
C-RXV. Most of what this function reports comes from the C-RXV -- LTF
size and LDPC extra symbol (rxv[4]), PE disambiguity and UL/DL (rxv[5]),
STA-ID (rxv[8]), BSS color and TXOP (rxv[9]), spatial reuse (rxv[13]) --
so with more headroom those fields would be filled from whatever follows
the P-RXV, which is the frame itself. Devin confirmed that reading. What
the short descriptor does carry is MCS, NSS, GI, bandwidth, coding and
beamforming.

So I'd keep this patch as the minimal crash fix for stable, and follow
up for wireless-next with a change that, when the C-RXV is absent,
reports just the P-RXV fields, making room with skb_cow_head() after
copying the rxv words (expanding the head frees the descriptor rxv
points into). The caller knows whether group 5 was present, so
mt76_connac3_mac_decode_eht_radiotap() would need to be told, which
touches mt7996 as well.

Would that cover what you're after, or would you rather see headroom
reserved for all rx buffers while a monitor interface is up? Devin saw
2.6 million EHT frames with the long descriptor (at least 176 bytes of
headroom) and none with the short one; we've hit it once in about 2.5
days of scanning.

Thanks,
Chris
