Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792794854;
	b=1Z89SBQ7t1fy1RMySoX2F5Qo93AnQdNpq85AaHMRR9/pS5yRLTqS9jaCNccokZXAKbjw
	 Fqg6lqnsZERdwFW+3I+BusubBtDiJFi9Z1C9I69sltzW+B25HtqtvfRkB9fR1gysSa73Q
	 aZASlClVxQAoYmH9DLsbvccR8xzvCnOe4epEOz2jgjm55yJtS8w3qq+76df45Scd4ATbk
	 Pu39u/qIJP09zUAHGT2cMQG3oFeobPB8+mjQgsXzOFuizDPS8X1HLoQDRBMeFafoq7xBN
	 wzbTgUjftlTlh1elSvmUv72oroHPqeIFk/qu0mkiaRV9azw4yZ1RagipUCTDUd/Hp7w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792794854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jxNvehtlWeM2v9I8bvYmlnUOj1vAh6WkD6i3fkgpUTk=;
	b=IUc1E2R0UFbS+2Z/PjrBlArL8/7zdf8T11td2fcADiNPQVoP63LnNJiI41h5ofZmAXf8
	 xlAVx0eA/7BKeMJBmASgTOgSnd7lSpDcgkxmPBAYY0krCd7el/+6OncgC1C3T5TEzj4gz
	 eekMC70Ir5YnTMuBKvcinRIEBQx6Cv+vPdiXZcqx+q9Cb/Xub/8R/B8ATn7G3KF0KCnoS
	 sl/PwAYUYTeVZSqHo5JD6tnHF0yCr2vx35/F2bnYwdxYytajUxUaW3RYWbHiUo1mBjxfL
	 fb9AdO6bmpuOEyqShSAnHg6ReTqqCZOcM4c+gBNIVMjhsGpSUf9GRg66KirEi4sADPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=O2IC3SXl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9FE606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 22:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA9FE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=O2IC3SXl
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a06454116eso681542b3a.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 15:34:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792794853; cv=none;
        d=google.com; s=arc-20260327;
        b=iN92V7EyrdcfM8qmBKc7o4bj1zulgAger59zAtdwrMG5fcRgEPtvjLvJ/bbrAI1/bE
         WwH+yT+aVGDOdO9fgdxhP/lPFG6YQmlUDxYEHPBgxG2/PVMQRz0SvS2s8jlPXbJvPauI
         dlLc13mr0NVAJVuAuXFIVl2KEdfaNMrp565FQ35OWMeHyAbtwC2ZgLnjZHbezpNdbZxQ
         imBDRY3u8ZEzNRO+p6Y4fSzo2hjgTb0AMeeLJWM9UsXofVcfkIANfUTo8QBnzO0ou9St
         +u46s07VYMqcDH3G9nOtq/i5GjfiD/unqh63RjikKHJZQgLqCf3b3YPvn/5cb+Ed6Dxe
         HZTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jxNvehtlWeM2v9I8bvYmlnUOj1vAh6WkD6i3fkgpUTk=;
        fh=/CiraNG/ZP0Fl8bYTh0oN1F/ycE7k9Bkfn22/49Dv+4=;
        b=QLzYkS2UwfU60GOfh0ieiBDYPgkeUVjpcm/aIu2qFMLd6ELmw6Kby/Ny7ZvioTOQWB
         ZJD/eeCDGe87/Gqm9Zavgt/Vjg3QTFGaSOYNUQl0pewexXDr2A0zG7xjD/0cs2xBsCQz
         nuLHSxNeAwDGdX+DHFostIde7AUPb0MBViHZTnz6vgZJ7FPkhCf01FR37mu0tpos3HpU
         KmxL0tZOUwRA4Mr9diVHFUJuDcGSDYlGCXDXyrlfnyw0xf4T0HuLmSiSWHrV3ZJlQOAZ
         PKY7rZcZGxcy+28wBW8ll0mTLSO/H5YR6ucd45I/fVw5OccmXGR5/Vv/gLu6lkjK7AeT
         XHmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792794853; x=1793399653; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jxNvehtlWeM2v9I8bvYmlnUOj1vAh6WkD6i3fkgpUTk=;
        b=O2IC3SXlnkop/TSrxwNdpkVxuwurb6rjkQKekXobHGc5NAt4w5nrg7eGlw74ERVjLF
         c4GyM7Dw5g4g8ZaUTf7m2N/VPcN6+9Zs9ZZJ4BfSp6wDiebBuNbPWYVOYwXieMMLq4c/
         O5hKWDUMXhDOczR7jaCi16VuNgW2GF4Hz0K73EEgZvCaNRk71pj9MS2a7RleYycV6ASv
         fkiEvbd9aLf37fgJ46m2qySLmrGKM0pv6SYPOBcbX9TX4q/pMqt324q0fm4RfnGSWoJ1
         PLXGXwvdyI/8S3lMVGnwPw51u4nQlOgeI1AREnCTYdFOlO9ndbBH4eSViZbrfTviURSY
         /Gaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792794853; x=1793399653;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jxNvehtlWeM2v9I8bvYmlnUOj1vAh6WkD6i3fkgpUTk=;
        b=A5xoEoFX13eMe1bf19VsKEf4DSxb08Ab59JmsrYByQG3yDLF0h2EQV8E091inXwTXs
         UAICK1iNjQTSwa9jBVlLR2diiH4aVhpTMQMwSOGj9Rk1l/dCtM0UmjV1vqSCCtQxtrRg
         0hfYF1A5VmL4CehumEpajuPb1BKJpj48BUmj3G6vZmyR2mXizEQb6djwS0+ofj5DXZQh
         ouUg4K5m6pJe7EIK25lnnl7phQ0W9QxkYY1RZKu8+F8UwARecMh17Xk3Dv2/SnG0tiRG
         eJe175IKvs49yZhF0sEE+REgiSlnhOgcoCHjTzjSegHlaJxWr0nSiYBGcJoeFW/L7BT7
         xZsQ==
X-Forwarded-Encrypted: i=1; AKwUvBy4iFUtbZ4+BMsaaTnedHnGojm/wh2AQb5w4g14vOzZzG1W3++Csa8wG70r/PogIfJp9YJQa1UFR2ZHv1VP1Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYIjPNvDEfAQNjWQyS4kU2TpPbjTlBTkEAUONDW7ZCvo0nwm+tHG
	2zvkyecZQHxfF+E6BZ18/nWYHw3QWw/NdhuU3WZLWzIBDUNouPflvsxpRU2YDWey2c1pz4eIZdP
	xBYAZzeIMJN7pMWYobTAukWNhEmD7HJ0=
X-Gm-Gg: AYBFou3MF5rVWed3lOxaMuPMAhttUfTDhIIboxOQyZMU4kcXKLSqXBQQ7V5OMpOWCX0
	rfC7uhy6B3tQxXt73VEOUy+DoKSz/rINk5jtF1lfsHkKxDTq6y398OCkr/J7Pw4uw0enF5L3w3h
	P4OvJsz2sjWA2MsvJHuxNfWGD1cVNeWGw5zftSmrGwleIyh39dBclVCcZkYjiUUJjWlt9udA1A6
	03X12hRQllxXS7DJg7vgOPtNOK6pnwbhc0Ea8SoM/FqxiHalotk7Wjn1FixCtgewVYqgUa79cWH
	5AL/s34E+wl0096YT/JQEzSu7Rm3uwKTeJ/8NWwkugVTMelnFvbjrrxkxq4bfNsDy4mm/lE9ZuL
	qRLh+DamwW/GUxqUoR5A3lgZ7RGXAS5M4f71Jqw==
X-Received: by 2002:a05:6a20:3c8d:b0:3e0:ba43:3d3d with SMTP id
 adf61e73a8af0-3e7af8001f7mr442293637.9.1792794853057; Fri, 23 Oct 2026
 15:34:13 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAHaeJsQLvC-KBEpy5qu8iYxSB51mbHohrPvN4PJushF_Tk3foA@mail.gmail.com>
 <20261023180554.7266-1-lucid_duck@justthetip.ca>
In-Reply-To: <20261023180554.7266-1-lucid_duck@justthetip.ca>
From: Chris <hoopyfrood42@gmail.com>
Date: Fri, 23 Oct 2026 18:34:01 -0400
X-Gm-Features: AclHuK-TQOKJ5AyUFSaxMUSVX5DG5h7fuIaa4gR6ynEKVI3XJIwGu3Fysv6Wifo
Message-ID: <CAHaeJsSfoTxJhWVCrELCiLZr1zD42LGJUvrmf7oSzRQpwh6-jw@mail.gmail.com>
Subject: Re: [RFC PATCH wireless] wifi: mt76: mt7925: get the survey airtime
 from the firmware
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Deren Wu <deren.wu@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Javier Tia <floss@jetm.me>, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 2:06=E2=80=AFPM Devin Wittmayer
<lucid_duck@justthetip.ca> wrote:
>
> Busy time in the mt7925 survey is bogus. The register it comes from
> doesn't work on this chip, so every update adds the same large number
> and busy time soon outgrows the time spent on the channel. Transmit
> and receive time come out far too low as well.
>
> Ask the firmware for all three instead, the way mt7996 does.
>
> The MT7927 counts 5 and 6 GHz on a second band that the survey never
> read, so read both bands there and only add the one the channel is on.
>
> Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for =
mt7925 chips")
> Fixes: 05fd14885303 ("wifi: mt76: mt7925: sync MT7927 BSS band assignment=
")
> Reported-by: Chris Kelly <hoopyfrood42@gmail.com>
> Closes: https://lore.kernel.org/linux-wireless/CAHaeJsT8O8Nhq351hFp3NAL8e=
0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com/
> Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> ---
> Chris, here's the RFC you asked about. Busy time now follows the load
> and stays under the time on the channel, hopping every half second too.
>
> It's an RFC because the offsets aren't documented. On an A9000:
>
>   19  busy time, including the card's own transmit
>   20  receive time
>   28  transmit time
>
> The MT7927 counts 5 and 6 GHz on a second band, which keeps counting
> while unused, so only the band in use is added.
>
> Busy as a share of time on the channel, A9000 on 2.4 GHz next to an
> MT7921AU:
>
>                before    after    MT7921AU
>   idle         4229%     4.2%     1.4%
>   100 Mbit/s   4317%     37.3%    33.7%
>   saturated    4346%     79.5%    77.4%
>
> Tested on the A9000 (Arch 6.18 and 7.2, Ubuntu 7.3, wireless-next with
> lockdep) and on a PCIe MT7925 and MT7927 (Fedora 7.2). mt7921 keeps its
> registers, which work on my MT7921AU.
>
> Could you try it on your A9000 against the Wi-Spy?
>
>  .../net/wireless/mediatek/mt76/mt7925/mac.c   | 42 +++++++++++
>  .../net/wireless/mediatek/mt76/mt7925/main.c  |  1 +
>  .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 70 +++++++++++++++++++
>  .../net/wireless/mediatek/mt76/mt7925/mcu.h   | 17 +++++
>  .../wireless/mediatek/mt76/mt7925/mt7925.h    |  3 +
>  .../net/wireless/mediatek/mt76/mt7925/pci.c   |  2 +-
>  .../net/wireless/mediatek/mt76/mt7925/usb.c   |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt792x.h   |  1 +
>  8 files changed, 136 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7925/mac.c
> index 7af996abe294..4ec3712fe614 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
> @@ -1470,6 +1470,48 @@ void mt7925_queue_rx_skb(struct mt76_dev *mdev, en=
um mt76_rxq_id q,
>  }
>  EXPORT_SYMBOL_GPL(mt7925_queue_rx_skb);
>
> +void mt7925_mac_update_chan_time(struct mt792x_phy *phy, bool reset)
> +{
> +       struct ieee80211_channel *chan =3D phy->mt76->chandef.chan;
> +       struct mt76_channel_state *state =3D phy->mt76->chan_state;
> +       struct mt792x_dev *dev =3D phy->dev;
> +       int i, n_bands =3D 1, band =3D 0;
> +
> +       /* The MT7927 counts 2.4 GHz on band 0 and 5/6 GHz on band 1, and
> +        * the band not in use keeps counting, so read both every time an=
d
> +        * only add the band the channel is on.
> +        */
> +       if (is_mt7927(&dev->mt76)) {
> +               n_bands =3D ARRAY_SIZE(phy->state_ts);
> +               if (chan)
> +                       band =3D mt7927_band_idx(chan->band);
> +       }
> +
> +       for (i =3D 0; i < n_bands; i++) {
> +               bool add =3D !reset && i =3D=3D band;
> +               u32 bss_rx;
> +
> +               bss_rx =3D mt76_get_field(dev, MT_MIB_SDR37(i),
> +                                       MT_MIB_SDR37_RXTIME_MASK);
> +               if (add)
> +                       state->cc_bss_rx +=3D bss_rx;
> +
> +               mt7925_mcu_get_chan_mib_info(phy, i, add);
> +       }
> +}
> +
> +void mt7925_update_channel(struct mt76_phy *mphy)
> +{
> +       struct mt792x_dev *dev =3D container_of(mphy->dev, struct mt792x_=
dev, mt76);
> +
> +       if (mt76_connac_pm_wake(mphy, &dev->pm))
> +               return;
> +
> +       mt7925_mac_update_chan_time(mphy->priv, false);
> +       mt76_connac_power_save_sched(mphy, &dev->pm);
> +}
> +EXPORT_SYMBOL_GPL(mt7925_update_channel);
> +
>  static void
>  mt7925_vif_connect_iter(void *priv, u8 *mac,
>                         struct ieee80211_vif *vif)
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/n=
et/wireless/mediatek/mt76/mt7925/main.c
> index 22cc5b49da0a..393c225c19e4 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
> @@ -351,6 +351,7 @@ int __mt7925_start(struct mt792x_phy *phy)
>                 return err;
>
>         mt792x_mac_reset_counters(phy);
> +       mt7925_mac_update_chan_time(phy, true);
>         set_bit(MT76_STATE_RUNNING, &mphy->state);
>
>         ieee80211_queue_delayed_work(mphy->hw, &mphy->mac_work,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7925/mcu.c
> index f299a3379adb..b741a4880cfe 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> @@ -1057,6 +1057,76 @@ int mt7925_mcu_get_temperature(struct mt792x_phy *=
phy)
>         return temperature;
>  }
>
> +int mt7925_mcu_get_chan_mib_info(struct mt792x_phy *phy, u8 band, bool a=
dd)
> +{
> +       enum {
> +               IDX_BUSY_TIME,
> +               IDX_TX_TIME,
> +               IDX_RX_TIME,
> +               IDX_NUM
> +       };
> +       struct {
> +               struct {
> +                       u8 band;
> +                       u8 __rsv[3];
> +               } hdr;
> +               struct {
> +                       __le16 tag;
> +                       __le16 len;
> +                       __le32 offs;
> +               } data[IDX_NUM];
> +       } __packed req =3D {
> +               .hdr.band =3D band,
> +       };
> +       static const u32 offs[] =3D {
> +               [IDX_BUSY_TIME] =3D UNI_MIB_BUSY_TIME,
> +               [IDX_TX_TIME] =3D UNI_MIB_TX_TIME,
> +               [IDX_RX_TIME] =3D UNI_MIB_RX_TIME,
> +       };
> +       struct mt76_channel_state *state =3D phy->mt76->chan_state;
> +       struct mt76_channel_state *state_ts =3D &phy->state_ts[band];
> +       struct mt792x_dev *dev =3D phy->dev;
> +       struct mt7925_mcu_mib *res;
> +       struct sk_buff *skb;
> +       int i, ret;
> +
> +       for (i =3D 0; i < IDX_NUM; i++) {
> +               req.data[i].tag =3D cpu_to_le16(UNI_CMD_MIB_DATA);
> +               req.data[i].len =3D cpu_to_le16(sizeof(req.data[i]));
> +               req.data[i].offs =3D cpu_to_le32(offs[i]);
> +       }
> +
> +       ret =3D mt76_mcu_send_and_get_msg(&dev->mt76,
> +                                       MCU_WM_UNI_CMD_QUERY(GET_MIB_INFO=
),
> +                                       &req, sizeof(req), true, &skb);
> +       if (ret)
> +               return ret;
> +       if (skb->len < sizeof(req.hdr) + IDX_NUM * sizeof(*res)) {
> +               dev_kfree_skb(skb);
> +               return -EINVAL;
> +       }
> +
> +       skb_pull(skb, sizeof(req.hdr));
> +       res =3D (struct mt7925_mcu_mib *)skb->data;
> +
> +       if (!add)
> +               goto out;
> +
> +#define __res_u64(s) le64_to_cpu(res[s].data)
> +       state->cc_busy +=3D __res_u64(IDX_BUSY_TIME) - state_ts->cc_busy;
> +       state->cc_tx +=3D __res_u64(IDX_TX_TIME) - state_ts->cc_tx;
> +       state->cc_rx +=3D __res_u64(IDX_RX_TIME) - state_ts->cc_rx;
> +out:
> +       state_ts->cc_busy =3D __res_u64(IDX_BUSY_TIME);
> +       state_ts->cc_tx =3D __res_u64(IDX_TX_TIME);
> +       state_ts->cc_rx =3D __res_u64(IDX_RX_TIME);
> +#undef __res_u64
> +
> +       dev_kfree_skb(skb);
> +
> +       return 0;
> +}
> +
>  static void
>  mt7925_mcu_parse_phy_cap(struct mt792x_dev *dev, char *data)
>  {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/ne=
t/wireless/mediatek/mt76/mt7925/mcu.h
> index 11f9eac13ffc..f3e892dbb74c 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
> @@ -57,6 +57,23 @@ struct mt7925_mcu_reg_event {
>         __le32 val;
>  } __packed;
>
> +enum {
> +       UNI_CMD_MIB_DATA,
> +};
> +
> +enum {
> +       UNI_MIB_BUSY_TIME =3D 19,
> +       UNI_MIB_RX_TIME =3D 20,
> +       UNI_MIB_TX_TIME =3D 28,
> +};
> +
> +struct mt7925_mcu_mib {
> +       __le16 tag;
> +       __le16 len;
> +       __le32 offs;
> +       __le64 data;
> +} __packed;
> +
>  struct mt7925_mcu_ant_id_config {
>         u8 ant_id[4];
>  } __packed;
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers=
/net/wireless/mediatek/mt76/mt7925/mt7925.h
> index 636efe038392..706e67e8ec42 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
> @@ -375,6 +375,9 @@ int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, st=
ruct ieee80211_vif *vif,
>  int mt7925_mcu_config_sniffer(struct mt792x_vif *vif,
>                               struct ieee80211_chanctx_conf *ctx);
>  int mt7925_mcu_get_temperature(struct mt792x_phy *phy);
> +int mt7925_mcu_get_chan_mib_info(struct mt792x_phy *phy, u8 band, bool a=
dd);
> +void mt7925_mac_update_chan_time(struct mt792x_phy *phy, bool reset);
> +void mt7925_update_channel(struct mt76_phy *mphy);
>
>  int mt7925_usb_sdio_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr=
,
>                                    enum mt76_txq_id qid, struct mt76_wcid=
 *wcid,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7925/pci.c
> index 0d477dc1086c..939a46c0428b 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
> @@ -604,7 +604,7 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
>                 .sta_add =3D mt7925_mac_sta_add,
>                 .sta_event =3D mt7925_mac_sta_event,
>                 .sta_remove =3D mt7925_mac_sta_remove,
> -               .update_survey =3D mt792x_update_channel,
> +               .update_survey =3D mt7925_update_channel,
>         };
>         static const struct mt792x_hif_ops mt7925_pcie_ops =3D {
>                 .init_reset =3D mt7925e_init_reset,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7925/usb.c
> index f97f787b2198..2d3bf035fdfc 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
> @@ -174,7 +174,7 @@ static int mt7925u_probe(struct usb_interface *usb_in=
tf,
>                 .sta_add =3D mt7925_mac_sta_add,
>                 .sta_event =3D mt7925_mac_sta_event,
>                 .sta_remove =3D mt7925_mac_sta_remove,
> -               .update_survey =3D mt792x_update_channel,
> +               .update_survey =3D mt7925_update_channel,
>         };
>         static const struct mt792x_hif_ops hif_ops =3D {
>                 .mcu_init =3D mt7925u_mcu_init,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wi=
reless/mediatek/mt76/mt792x.h
> index a7d71e007da0..3ee513258d00 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt792x.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
> @@ -221,6 +221,7 @@ struct mt792x_phy {
>         u32 ampdu_ref;
>
>         struct mt76_mib_stats mib;
> +       struct mt76_channel_state state_ts[2];
>
>         u8 sta_work_count;
>         u8 clc_chan_conf;
> --
> 2.56.0
>



On Fri, Oct 23, 2026 at 2:05 PM Devin Wittmayer
<lucid_duck@justthetip.ca> wrote:
> Chris, here's the RFC you asked about. Busy time now follows the load
> and stays under the time on the channel, hopping every half second too.
[...]
> Could you try it on your A9000 against the Wi-Spy?

Thanks, Devin. It works here.

A9000 (mt7925u on USB 2.0), Ubuntu 7.0.0-38-generic, WM firmware
20260605184805 from Ubuntu's linux-firmware 20260319 (not the
2026-10-20 release), built out of tree from Ubuntu's mt76 source on
top of your survey v2. Ubuntu's 7.0 has no MT7927, so I dropped the
is_mt7927() block and the chan local it used; the rest is as sent.

Monitor mode, no association, 98 channels at 500 ms dwell, survey read
every ~5 s, 102 minutes: 8596 per-channel updates, none with busy over
active time, none going backwards. Quiet 6 GHz channels read 0.1-0.3%.
Without the patch the same setup gave 6013% on one channel. No MCU
timeouts or resets.

Load was a phone on a 2.4 GHz AP on channel 1 playing 2160p video.
Busy as a share of time on the channel, next to the Wi-Spy DBx2's RF
occupancy (bins 6 dB over its floor):

                              hopping                  locked on ch 1
                           busy      Wi-Spy     busy    Wi-Spy
  normal air         41.9%   71.4%       50.8%   69.1%
  2160p video     57.2%   85.5%       69.4%   85.0%

The Wi-Spy counts any energy, so it reads higher on 2.4 GHz, but the
two move together, and channels 2-5 rose with the load on both. On
5 GHz the Wi-Spy is the weaker of the two (3-16% on busy channels where
busy reads 13-32%), and busy stays above the airtime of the frames I
can decode there, as it should.

One thing on offset 20: in monitor mode it doesn't look like all of
rx. On busy 5 GHz channels it mostly reads under 2% while the frames I
decode alone take 13-19% (ch 149: 1.6% vs 19.1%), yet on 2.4 GHz
channels 2-4, between the networks on 1 and 6, it is nearly all of
busy (22-25%) with almost nothing decodable there. It does follow load
(ch 1 locked: 29% -> 55%). Busy doesn't depend on it, but MediaTek may
know what it counts. tx stays 0, as it should with nothing sent.

Tested-by: Chris Kelly <hoopyfrood42@gmail.com>

Chris
