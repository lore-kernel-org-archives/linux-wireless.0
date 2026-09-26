Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E441391E7B
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 23:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790466033; cv=pass; b=jSd0voR/EixG5k77gPp3w9lkGxXwhZsbSF/W3YIEkywZHUhOn5e1R2XmJdJ+nn8/9oWhZOgrU1o/SlIJiIhXrYPZZk2HdWrLkoxBSeW0ldi9sikv3Pd8571sGMk0ZFQJV8v1XUFUjA2H9tfSIuGFxTE6NRAFywgcL2RPqArGCuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790466033; c=relaxed/simple;
	bh=vktilNp1Ojy9C8IDFSZjjTSfgR14zEEkS+PxxWOORXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vAWutI7UO4+mThBa6UfLLqa7cfL64iht4KFRiCT1olkvk6hEofg+wSMNhl5NzWxxa6wWeBK7hb0UwExkfCZyHGciEmFgrUyr+FtbjKO6aueE3OMTHx0lox8HQLMN7Q0RPdPM36auuYT9a1Ce61SBhLExpXn/8yjSBHYYZysu3Rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=esRSls5w; arc=pass smtp.client-ip=74.125.228.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esRSls5w"
Received: by mail-pz2-f38.google.com with SMTP id 41be03b00d2f7-cc79f8a6170so162863a12.1
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 16:40:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790466031; cv=none;
        d=google.com; s=arc-20260327;
        b=KAePxr1ZZfJGolBgOml7qf2+E5GKcYq61W2ECT8FglqAU5MexxveciOPwlj9e41wRJ
         Zw0ufoIcKo77jMEeyH7jB0CHZ9KgXQdC7AA7UzB4K7tzr9c3Hcu+l3qOWCzBYqns3Cz4
         U8N5hmYXMFaGtUbTrRVto0h7ddM+5cVvAd/2D35k+wmEp7e15/Kf/zzS9IFLi1/tj9Rs
         bWubdI8RPTPto7L5nLzqQaxLtr2qN5mwU0HIV9jVGkIJQYcachVkmQBHPAtjvOAhvFmN
         SHCsY4cJFQ9TzttSX0xAEgMOj1CZ2FCTQ1HUcCU3ctozkgt9DPN+Xcz485IhPzJRKqZH
         /Dmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vla1fwPoTII1UZuS4xIuYEBUk1VrkrJWcRYixCLAnoI=;
        fh=okC+ffmPnwP9v8VGQE1L9pF5jMl5wfp1spON8Ne0s+k=;
        b=NNrSkC3jz/QxkklNFqbzQycfT3k1m2RN6ZTowp3qt+O2DGQ+s/i8alCSiqH7guCl7G
         jnLRPb3x8k4LNSQ4yB5eP0Z1fuWTjn9Wv1J3Lhiw20YOjzETPj84vGALz6KNx/cI/oyE
         q0Q1mqinLsoQ5fL99pEoKK3RhhLTYIgf4kzJwI3pONZ8mfX2diVHfuZKS5zx5YenfP1o
         yvGFrrnsuYKgztwNPvAQcN+/zVOQ/OnTHZ62yZ9loumXpFXIEhHpftTCjv6DxFSGSipx
         AHxfNagwpqyoC8yk08hvJ2CZZoufBM5fVFoJNHZLotaRIYu9sKvXhEZyZ7QXU8HjRfIv
         7udQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790466031; x=1791070831; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vla1fwPoTII1UZuS4xIuYEBUk1VrkrJWcRYixCLAnoI=;
        b=esRSls5wMpVD7yoQ8+9kl1bpt20qZMMFvry/WyAb6cn/vsoyER6kbyHk+ieU3YjCym
         PlyyABvo9RRJLbMJ740C8z/vtwozzxFm/HiaaIWkgoR3fL6kGHAyc/+3Q/5nasgyMnHC
         GW7Bdw27+dMxr7oPXIlvDbvun3DP+7bFwBgxYaY4MyHooZetdlWznOkUKIXeZpRsdFFT
         yj4yKKzZ6WiWDh3+LwVW80ayjQPhbhjm80BaLlaPdE7ujexs9W1JQEMXAg6mi5zdDl42
         d58FJi5shUppj+EBCjq8aObQEaUiJCyU27YsdJUXK+O8wSl8AGacn0toJzWskbffmB9k
         FQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790466031; x=1791070831;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vla1fwPoTII1UZuS4xIuYEBUk1VrkrJWcRYixCLAnoI=;
        b=H7flBo5ieAwqlT9OaZPWUZ7wWgI4DOp6w6Zi3ywNW4pD6mtY/IDxIYs3NG81Ab1t5j
         D+G3LqxxQVXXRwBFgSeyb/KrN1qDDFJXHB8cKYUdEBdSN23QchygAdGT/C6KZvieoWEG
         C4TilAt6EegemkmLtFxg/XfOB31epncbUhdtEZt6Y64ftuVW03BYvqnsYboO22lZx44+
         oqV0BZD6yvMT16AMr+3LIO5uzyn/ZU2VeqeiD6LbNeiz35RMFgRRGk2Yyx/2wfCsXTo9
         EZ9QfWAhV4BWJJVCJUPJSnRcRRYM5OdVnzlPo+gqwpr9iS66TsAIeRE+L70uOXPzlVkr
         5jVQ==
X-Gm-Message-State: AFuF++lfLw3fNwcqoZ6wglx8LADcQsly+6uD++LK7ggJM4YbIItSiAWy
	EZER4j1tDmDYKvhMItpOwTvhBXJGF9UMr9i81FsYO/3panhG4nqrmRaIyEFX9XhhYFnSUUm0Arx
	Z06ZuioedF/Z20UwmHhNVtoLY4e68sl4sfQ==
X-Gm-Gg: AYBFou0YypfGlH37kCbguvkZUMTFXo80FOPLxL6nmxDkWJUywdPw/hHlbHzGHAza83n
	UJo4fuV+3sDkLNbSZlf3BvGHQ3PRWApbiUS98TjUydkEdOYTv5vRsU3AlL6nD5Zy8iIT2vfsoHO
	l1OYeAXZ1BTujf6aXHjO0Uv//E4X0Hq7X4lk3h8r2ZM2KtzNhKFSJsCaCG5TGEOkxeAy1HEXbAE
	XbmGNke4ZzoFoBQFqvFbis0NDiBSwmV4E2jnzEOit3fP7YyAsj40y1wrThhzWmNmEB2t8v7lgEe
	4j77nBesnPW/UAMwDNVX6uwUY0YT70fZF4Kg8Rzj1f65cajKT7e6y4HU
X-Received: by 2002:a05:6a20:d485:b0:3dd:a006:7b3b with SMTP id
 adf61e73a8af0-3de0e89680bmr10127728637.58.1790466030655; Sat, 26 Sep 2026
 16:40:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com>
In-Reply-To: <CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com>
From: Chris <hoopyfrood42@gmail.com>
Date: Sat, 26 Sep 2026 19:40:19 -0400
X-Gm-Features: AclHuK_mbxKsRN1eEi9uxdQcJQ3kkZUUEiKs1jqERW49JwaYGKqdEMuhT8rWYHg
Message-ID: <CAHaeJsQ3FxvU1dQTSP751-Jq8JVv-tS8oRhNhuVy5-U4kPXwrA@mail.gmail.com>
Subject: Re: [BUG] wifi: mt76: mt7925u: survey busy time is 0xADBEEF per
 update, booked to a stale channel (monitor mode)
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Two follow-ups on the same device, from reading registers through
mt76's debugfs (regidx/regval) with the interface in monitor mode:

1. The busy-time read itself fails. MT_HW_CHIPID (0x70010200) reads
   0x00007925, so the method works, but:

     0x820ed020  MT_MIB_SDR6   0xffffffff
     0x820ed02c  MT_MIB_SDR9   0xdeadbeef   (band 1, 0x820fd02c: same)
     0x820ed054  MT_MIB_SDR36  0x00000000
     0x820ed058  MT_MIB_SDR37  0x00000000

   while the RMAC block next to it answers normally (MT_WF_RFCR,
   0x820e5000 =3D 0x00201002). So the WF MIB block at the mt792x
   address is not reachable on this chip, which is where the
   0xADBEEF busy time comes from.

2. No noise floor: mt792x_phy_get_nf() returns 0, so the survey never
   reports noise. mt7996_phy_get_nf() (and mt7915's) computes one from
   the idle power indicator histogram, weighted by the 802.11 IPI
   levels, -92 to -52 dBm; measured while the channel is idle, it also
   reflects interference, which would make the survey's noise
   genuinely useful to survey and monitoring tools.

   The PHYRX registers answer at the mt7996 (connac3) addresses:
   MT_WF_PHYRX_CSD_BAND_RXTD12(0) (0x83088230) reads 0x9000c2c2, but
   MT_WF_PHYRX_BAND_RX_CTRL1(0) (0x83082004) reads 0, i.e. IPI_EN off,
   and the IRPI bins at 0x83001000 and 0x83011000 read 0 on busy and
   quiet channels alike.

   Setting IPI_EN from the host the way mt7996_mac_enable_nf() does
   (RX_CTRL1 |=3D 0x5 through regval) does not stick -- it reads back 0
   -- and it wedged the device: MCU message timeouts, a
   "rx urb mismatch" WARN in mt76u_complete_rx(), repeated firmware
   reloads, and no RX until the interface was taken down and up. So
   presumably the firmware owns these registers.

   Does the mt7925 support the IPI histogram, enabled by the firmware
   or by an MCU command? If so, could the survey report noise the way
   mt7996 does? I can test on the mt7925u.

Thanks,
Chris Kelly


On Sat, Sep 26, 2026 at 7:11=E2=80=AFPM Chris <hoopyfrood42@gmail.com> wrot=
e:
>
> Hi,
>
>
> On an mt7925u adapter in monitor mode, the channel survey
> (iw dev <if> survey dump) does not measure anything: all counters are
> booked to one channel whatever channel is tuned, and "channel busy
> time" grows by a constant 11386.6 ms per update, which is 0xDEADBEEF
> masked with MT_MIB_SDR9_BUSY_MASK. Details below; I can test patches.
>
> System
> ------
> Device:   Netgear Nighthawk A9000, USB 0846:9072, driver mt7925u
>           (on a USB 2.0 host)
> Kernel:   7.0.0-31-generic (Ubuntu 26.04.1 LTS)
> Firmware: HW/SW Version: 0x8a108a10, Build Time: 20260605184651a
>           WM Firmware Version: ____000000, Build Time: 20260605184805
> Setup:    a single monitor interface (NetworkManager does not manage
>           the device), retuned with "iw dev <if> set freq ..." about
>           once a second.
>
> What happens
> ------------
> "iw dev <if> survey dump" lists 98 channels. All read 0 except
> 5955 MHz (6 GHz channel 1), which is never marked [in use], and whose
> counters grow whatever channel the radio is on:
>
>   time          tuned to   active (ms)  busy (ms)   +active  +busy
>   18:23:48.404  2462 MHz   9571269      415246784
>   18:23:49.477  5845 MHz   9572344      415349263   1075     102479
>   18:23:50.599  5865 MHz   9573464      415497289   1120     148026
>   18:23:51.649  5660 MHz   9574519      415576995   1055      79706
>   18:23:53.000  6295 MHz   9575865      415679475   1346     102480
>   18:23:54.050  5955 MHz   9576917      415816114   1052     136639
>   18:23:55.097  6615 MHz   9577967      415907207   1050      91093
>
> - "channel active time" advances with wall-clock time.
> - "channel busy time" advances in exact multiples of 11386.6 ms
>   (79706 =3D 7x, 91093 =3D 8x, 102479 =3D 9x, 136639 =3D 12x,
>   148026 =3D 13x), on busy and idle channels alike, so busy is now
>   ~43x active.
> - "channel receive time" and "channel transmit time" stay at
>   247 ms and 24 ms although frames are received continuously.
> - No noise value is reported.
>
> Analysis
> --------
> From reading drivers/net/wireless/mediatek/mt76 in current mainline
> (not verified on the chip beyond the numbers above):
>
> 1. Busy: 11386607 us =3D 0xADBEEF =3D 0xDEADBEEF & GENMASK(23, 0).
>    mt792x_phy_update_channel() adds
>    mt76_get_field(dev, MT_MIB_SDR9(0), MT_MIB_SDR9_BUSY_MASK) to
>    cc_busy on every update, so the MT_MIB_SDR9 read appears to
>    return 0xDEADBEEF on this device. MT_WF_MIB_BASE() in
>    mt792x_regs.h is shared with mt7921; I have not checked whether
>    that address, or its access over USB, is valid for mt7925.
>
> 2. Channel: mt76_update_survey() and mt792x_phy_update_channel()
>    book the counters to phy->chan_state, which only
>    __mt76_set_channel() moves. For a monitor interface, mt7925
>    retunes through mt7925_change_chanctx() ->
>    mt7925_mcu_config_sniffer(), which never calls
>    __mt76_set_channel(), so the counters stay on whatever channel
>    chan_state was left on: 5955 MHz here, through every retune and
>    through taking the interface down and up again (which does not
>    reset them either).
>
> 3. Active: mt76_update_survey_active_time() adds host time to the
>    same stale state, hence active ~=3D wall-clock time on one channel.
>
> Effect: channel utilisation from this adapter's survey is
> meaningless: one channel reads far over 100% busy, every other 0.
>
> Possible directions (untested)
> ------------------------------
> - Move phy->chan_state (and survey_time) to the new channel when the
>   sniffer channel changes in mt7925_change_chanctx().
> - Check the MIB counter address/access for mt7925(u), or read the
>   counters from firmware as mt7996 does (MCU_UNI_CMD_GET_MIB_INFO),
>   if the mt7925 firmware supports it.
>
> To reproduce
> ------------
>   ip link set <if> down
>   iw dev <if> set type monitor
>   ip link set <if> up
>   iw dev <if> set freq 2437
>   iw dev <if> survey dump        # note the one non-zero entry
>   iw dev <if> set freq 5180 80 5210
>   sleep 2
>   iw dev <if> survey dump        # that entry again: busy grows by
>                                                  # multiples of 11386.6 m=
s
>
> Those steps here (only the non-zero survey entry shown):
>
>   after "set freq 2437":
>     5955 MHz: active 11927456 ms, busy 521734332 ms, rx 247 ms, tx 24 ms
>   after "set freq 5180 80 5210" and 2 s:
>     5955 MHz: active 11929867 ms, busy 521882358 ms, rx 247 ms, tx 24 ms
>     (+2411 ms active, +148026 ms busy =3D 13 x 11386.6)
>
> and then held on 2437 MHz, a dump a second:
>
>   time                 active (ms)  busy (ms)     +active  +busy
>   19:03:08.317  11929934     521939291
>   19:03:09.360  11930980     522041771   1046     102480
>   19:03:10.407  11932023     522144250   1043     102479
>   19:03:11.454  11933072     522246730   1049     102480
>   19:03:12.500  11934118     522349209   1046     102479
>   19:03:13.544  11935161     522451688   1043     102479
>   19:03:14.587  11936229     522554168   1068     102480
>   19:03:15.659  11937307     522656647   1078     102479
>   19:03:16.734  11938350     522747740   1043      91093
>   19:03:17.806  11939423     522850220   1073     102480
>
>
> Thanks,
> Chris Kelly
