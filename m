Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04498479882
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 18:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790881143; cv=pass; b=njkiUM3e6iAHO0+WkdfAMQuSjeS04skdHbR5t54972U7dJ/85DT0AF4BGQBWUouRu+b3jkdL/AAM+6CYuX6ru5kFjcgCfPB8VrJkbal1FKK7Kgj44Lyzo7rG8E5t6Q3QkaFVFntFnMedHIHDKMTu6UhD1y4yDgt955yYJbVVRo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790881143; c=relaxed/simple;
	bh=ccI4A2GIQwIiClsVuWdnk+6SIFxd6hZgWnq8S6qY+5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ap3wUNSaCE4VMWOOrMqbnArIZ3rKPoHv/+8k4/nkXhelx6UpG3CznfpgpZpYxeNFb0IOsRC+uE+sGWCXpfjwYOkNAzPxqzCrtWoSIKI51LVpLFf+gTIhIfyEJ+g6CaR6vQSgErZvER2tj6b8T1REsY9N2aAQsIUvxRYOy0GekjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m9r/6m4k; arc=pass smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m9r/6m4k"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4cdc0d663so3093750a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 11:59:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790881141; cv=none;
        d=google.com; s=arc-20260327;
        b=nusVwdxlKyrWj8KXdPNCNjzk5LLcRBVO5+kgPyoB3dXbJaMvHhY7Kw93sEh8Kt9w5U
         IOOiIxrOLwjNiYLvtK6luPS/st7sD/kS86dfJBZhOWorPozwc8SLgsHso25Chwb6Gx0F
         p44MC+OsOfQkBian46Drk17G34LaYMpWnf7yjAzCr2K4P9N6TudGSOsH1/pECte71Qhq
         UVjR2Wx2RbVG3uKUAW/n3Rui3Kgmqsm9i84xDuAOd7MxWIssLakM+/u/BETy7NTByFlR
         g7+aQZAnB9lGspo5LosplulKJERigcTrojtZk6KmKxfVzpI18QnfHnpAGPPdEu/n0urp
         8XVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEmn6tNhMDhLv8o7Lz0K5fUAmgYBUgbAioK0pCEt2B4=;
        fh=okC+ffmPnwP9v8VGQE1L9pF5jMl5wfp1spON8Ne0s+k=;
        b=HKJNTiWEsFzGbvDZNmHYk0sdeNc6K7JYz5hCyIrxrjyYawgL+2uvCQI+o1YPNcD0MM
         yZbCFRl/XwhF8NbEdqAubBQE0EPjbqFcYyllGcJr3E8wGKu13EAbRPpfbLdo5SEOxoX3
         AJjhxujrMhKeBMMKSKusKBzUGnzW91qwy63KCcF8ysS5ONG7Rdf99ZR8duruhAqUy5cd
         /qkY8ReWW0aUF+D2gGAAu+vqdYLr/G29sBcgxKRg9vLllAEqpywFfVDy9nns0/swbN/0
         VtFsYFuvWi1wcaxn/TG6GJ5MyOKNMN0GhAL37jFOwaYvnEd4daQKNK0GRxNT79v7Bk2a
         jTpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790881141; x=1791485941; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEmn6tNhMDhLv8o7Lz0K5fUAmgYBUgbAioK0pCEt2B4=;
        b=m9r/6m4ktklSv+QMcseVK8t+Uhs/5VLQBQF70ugxxQ0JvDQy+qisoFHwNoXgeFLe2m
         6uKtA/kLVwNL0esvcGc3pNkuBD3ZECLRiArz7SKPBnDUS9SPxrWz6uGgVrR0xCfxJ1c0
         1fqKLDDX3yvzEKLrblnGnwqvttelxYGzZtSrXBua4O/wyiWf+aqiJE7l7fNQRJL3URl7
         b4kSWLuV14vQ4/gqybB93xrMcHr7B8hsRQtJ2Zdb1gaISA+tdRqFJBQ8HEJM0Es4DnoF
         bELAzGh8/E9BU7qwzcaBAlwZgN3blD65IWhJOCMsfAV9cT9/KAO7y9ObAdyy5KrD8zQ4
         aTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790881141; x=1791485941;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEmn6tNhMDhLv8o7Lz0K5fUAmgYBUgbAioK0pCEt2B4=;
        b=Bx4q3OoW9DsXiX59MwhXRXMOTuPRKJ4/U9aBt5T+vvyvTxbdshi5esfKp+3LAogC6t
         gmpsxUIp7gBGut+F7by+kE66IVhy9ZM3uPBJq4MunNnw4B2Ixrc9ghHIBWn0dk0p34Gi
         6OAKCeF7oWfMVWSH/d8Cuan+bA6QYCdWZ+wSxkwy6xs+n0JID7ZGNRVx3n2xvhaU4J9t
         Ajo8tgHQecTdShGKcfozOCVnQwF5D6AC3rFNhTnd1QYyMV31/bc2NqONAoQqkME6OP2K
         JdFPhYv2sOizftC0SruUGrRd0ubVr0z478eq55RpUaArhYban/LGDKsFrl7/VtAIYxEd
         vraw==
X-Gm-Message-State: AFuF++m3ySMMyIDeYqAqLkoQo+ZCEJV/0IQ0DcjFScP0dnax0qGJtY2x
	qf+TPXUHdYz88x7nfz2da/1F72GMOla6x/kXx+7ASK8azgV7KIwF44Q7tVCJWh4bhhN2nbZgfWd
	QOMHz1cuUW3Y5/UqvdI2ZMalQ4c+S+wTf7lOH
X-Gm-Gg: AYBFou1NYORgJwcYsaEBGMSpYQJ3w0AdAcEveMHJnOWV555McWhmn+ilpsFamAWZiom
	bmJek9EWFYgrkX+/7qDBRaAOu0OnaAaVPnSrdlbXY2drWD9ZR41NWgpjM5+pIHQD1DLXKZVALhD
	M8n+zPRkXSGVMwFaWoiLAIBOk/xG3o54mOmV/K7E0wXkTLRF2gMZJlzqKi82rmx46DEamGHUMez
	ksINforlqf2OmY6MeBYH1PcB+qLz2BKFutWO4sD2OEwyfkZtYsTeRwhhp+d397W1P4p6IO3jgeP
	kD711dHXJqdh1exxPJDUcNBZ0oKv5oZ3R6OW1eNIF3zRlXGdoXhkeP8P2kpsc4EJgBs=
X-Received: by 2002:a05:6a21:6104:b0:3de:4c08:169 with SMTP id
 adf61e73a8af0-3e0bd228822mr290489637.69.1790881141102; Thu, 01 Oct 2026
 11:59:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com>
 <CAHaeJsQ3FxvU1dQTSP751-Jq8JVv-tS8oRhNhuVy5-U4kPXwrA@mail.gmail.com>
In-Reply-To: <CAHaeJsQ3FxvU1dQTSP751-Jq8JVv-tS8oRhNhuVy5-U4kPXwrA@mail.gmail.com>
From: Chris <hoopyfrood42@gmail.com>
Date: Thu, 1 Oct 2026 14:58:47 -0400
X-Gm-Features: AclHuK8k68dhxbIQ9dP9Ln9OZtY6wfJELysSNwTcyYLwzQ0B_0NNdSpk62UFNs0
Message-ID: <CAHaeJsSM2kg6undbwaMUwcBbrA500CxMShU=VHv7w1B+YefHiA@mail.gmail.com>
Subject: Re: [BUG] wifi: mt76: mt7925u: survey busy time is 0xADBEEF per
 update, booked to a stale channel (monitor mode)
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Devin,

Thanks again for the survey channel fix. It has been running here since
Sep 30, and the counters now land on the right channel.

The other half of this report is still open. You clearly know this
driver well, so I wanted to ask whether you would be willing to look at
it:

1. Busy time. mt792x_phy_update_channel() reads MT_MIB_SDR9 at the
   mt7921 address, and on the MT7925 (USB) that read returns 0xDEADBEEF:
   busy grows by 0xADBEEF (11,386.6 ms) per update, whatever the channel
   is doing. Just now, on 6295 MHz: 1,654 s active, 127,302 s busy.
   Reading through debugfs, SDR6 is 0xFFFFFFFF and SDR36/37 are 0, so the
   whole MIB block at that address looks unreachable on this chip, while
   RMAC next to it reads normally. mt7996 gets these counters from its
   firmware (MCU_UNI_CMD_GET_MIB_INFO); I don't know whether the mt7925
   firmware answers that.

2. Noise floor. mt792x_phy_get_nf() returns 0 here, so the survey has no
   noise at all. The IPI histogram that mt7915 and mt7996 build their
   floor from seems to exist at the mt7996 addresses but is disabled
   (RX_CTRL1 at 0x83082004 is 0, and the bins at 0x83001000 and
   0x83011000 are all 0).

One caution from testing: setting IPI_EN by writing that register
through debugfs didn't stick and wedged the chip (MCU timeouts, an "rx
urb mismatch" WARN, four firmware reloads, no RX until the interface was
taken down and up), so I have stuck to reads since.

I can build and test anything on the A9000 (kernel 7.0.0-34, with your
survey patch, the TXRX_NOTIFY fix and the EHT headroom patch applied),
in monitor mode across 2.4, 5 and 6 GHz.

Thanks,
Chris

On Sat, Sep 26, 2026 at 7:40=E2=80=AFPM Chris <hoopyfrood42@gmail.com> wrot=
e:
>
> Hi,
>
> Two follow-ups on the same device, from reading registers through
> mt76's debugfs (regidx/regval) with the interface in monitor mode:
>
> 1. The busy-time read itself fails. MT_HW_CHIPID (0x70010200) reads
>    0x00007925, so the method works, but:
>
>      0x820ed020  MT_MIB_SDR6   0xffffffff
>      0x820ed02c  MT_MIB_SDR9   0xdeadbeef   (band 1, 0x820fd02c: same)
>      0x820ed054  MT_MIB_SDR36  0x00000000
>      0x820ed058  MT_MIB_SDR37  0x00000000
>
>    while the RMAC block next to it answers normally (MT_WF_RFCR,
>    0x820e5000 =3D 0x00201002). So the WF MIB block at the mt792x
>    address is not reachable on this chip, which is where the
>    0xADBEEF busy time comes from.
>
> 2. No noise floor: mt792x_phy_get_nf() returns 0, so the survey never
>    reports noise. mt7996_phy_get_nf() (and mt7915's) computes one from
>    the idle power indicator histogram, weighted by the 802.11 IPI
>    levels, -92 to -52 dBm; measured while the channel is idle, it also
>    reflects interference, which would make the survey's noise
>    genuinely useful to survey and monitoring tools.
>
>    The PHYRX registers answer at the mt7996 (connac3) addresses:
>    MT_WF_PHYRX_CSD_BAND_RXTD12(0) (0x83088230) reads 0x9000c2c2, but
>    MT_WF_PHYRX_BAND_RX_CTRL1(0) (0x83082004) reads 0, i.e. IPI_EN off,
>    and the IRPI bins at 0x83001000 and 0x83011000 read 0 on busy and
>    quiet channels alike.
>
>    Setting IPI_EN from the host the way mt7996_mac_enable_nf() does
>    (RX_CTRL1 |=3D 0x5 through regval) does not stick -- it reads back 0
>    -- and it wedged the device: MCU message timeouts, a
>    "rx urb mismatch" WARN in mt76u_complete_rx(), repeated firmware
>    reloads, and no RX until the interface was taken down and up. So
>    presumably the firmware owns these registers.
>
>    Does the mt7925 support the IPI histogram, enabled by the firmware
>    or by an MCU command? If so, could the survey report noise the way
>    mt7996 does? I can test on the mt7925u.
>
> Thanks,
> Chris Kelly
>
>
> On Sat, Sep 26, 2026 at 7:11=E2=80=AFPM Chris <hoopyfrood42@gmail.com> wr=
ote:
> >
> > Hi,
> >
> >
> > On an mt7925u adapter in monitor mode, the channel survey
> > (iw dev <if> survey dump) does not measure anything: all counters are
> > booked to one channel whatever channel is tuned, and "channel busy
> > time" grows by a constant 11386.6 ms per update, which is 0xDEADBEEF
> > masked with MT_MIB_SDR9_BUSY_MASK. Details below; I can test patches.
> >
> > System
> > ------
> > Device:   Netgear Nighthawk A9000, USB 0846:9072, driver mt7925u
> >           (on a USB 2.0 host)
> > Kernel:   7.0.0-31-generic (Ubuntu 26.04.1 LTS)
> > Firmware: HW/SW Version: 0x8a108a10, Build Time: 20260605184651a
> >           WM Firmware Version: ____000000, Build Time: 20260605184805
> > Setup:    a single monitor interface (NetworkManager does not manage
> >           the device), retuned with "iw dev <if> set freq ..." about
> >           once a second.
> >
> > What happens
> > ------------
> > "iw dev <if> survey dump" lists 98 channels. All read 0 except
> > 5955 MHz (6 GHz channel 1), which is never marked [in use], and whose
> > counters grow whatever channel the radio is on:
> >
> >   time          tuned to   active (ms)  busy (ms)   +active  +busy
> >   18:23:48.404  2462 MHz   9571269      415246784
> >   18:23:49.477  5845 MHz   9572344      415349263   1075     102479
> >   18:23:50.599  5865 MHz   9573464      415497289   1120     148026
> >   18:23:51.649  5660 MHz   9574519      415576995   1055      79706
> >   18:23:53.000  6295 MHz   9575865      415679475   1346     102480
> >   18:23:54.050  5955 MHz   9576917      415816114   1052     136639
> >   18:23:55.097  6615 MHz   9577967      415907207   1050      91093
> >
> > - "channel active time" advances with wall-clock time.
> > - "channel busy time" advances in exact multiples of 11386.6 ms
> >   (79706 =3D 7x, 91093 =3D 8x, 102479 =3D 9x, 136639 =3D 12x,
> >   148026 =3D 13x), on busy and idle channels alike, so busy is now
> >   ~43x active.
> > - "channel receive time" and "channel transmit time" stay at
> >   247 ms and 24 ms although frames are received continuously.
> > - No noise value is reported.
> >
> > Analysis
> > --------
> > From reading drivers/net/wireless/mediatek/mt76 in current mainline
> > (not verified on the chip beyond the numbers above):
> >
> > 1. Busy: 11386607 us =3D 0xADBEEF =3D 0xDEADBEEF & GENMASK(23, 0).
> >    mt792x_phy_update_channel() adds
> >    mt76_get_field(dev, MT_MIB_SDR9(0), MT_MIB_SDR9_BUSY_MASK) to
> >    cc_busy on every update, so the MT_MIB_SDR9 read appears to
> >    return 0xDEADBEEF on this device. MT_WF_MIB_BASE() in
> >    mt792x_regs.h is shared with mt7921; I have not checked whether
> >    that address, or its access over USB, is valid for mt7925.
> >
> > 2. Channel: mt76_update_survey() and mt792x_phy_update_channel()
> >    book the counters to phy->chan_state, which only
> >    __mt76_set_channel() moves. For a monitor interface, mt7925
> >    retunes through mt7925_change_chanctx() ->
> >    mt7925_mcu_config_sniffer(), which never calls
> >    __mt76_set_channel(), so the counters stay on whatever channel
> >    chan_state was left on: 5955 MHz here, through every retune and
> >    through taking the interface down and up again (which does not
> >    reset them either).
> >
> > 3. Active: mt76_update_survey_active_time() adds host time to the
> >    same stale state, hence active ~=3D wall-clock time on one channel.
> >
> > Effect: channel utilisation from this adapter's survey is
> > meaningless: one channel reads far over 100% busy, every other 0.
> >
> > Possible directions (untested)
> > ------------------------------
> > - Move phy->chan_state (and survey_time) to the new channel when the
> >   sniffer channel changes in mt7925_change_chanctx().
> > - Check the MIB counter address/access for mt7925(u), or read the
> >   counters from firmware as mt7996 does (MCU_UNI_CMD_GET_MIB_INFO),
> >   if the mt7925 firmware supports it.
> >
> > To reproduce
> > ------------
> >   ip link set <if> down
> >   iw dev <if> set type monitor
> >   ip link set <if> up
> >   iw dev <if> set freq 2437
> >   iw dev <if> survey dump        # note the one non-zero entry
> >   iw dev <if> set freq 5180 80 5210
> >   sleep 2
> >   iw dev <if> survey dump        # that entry again: busy grows by
> >                                                  # multiples of 11386.6=
 ms
> >
> > Those steps here (only the non-zero survey entry shown):
> >
> >   after "set freq 2437":
> >     5955 MHz: active 11927456 ms, busy 521734332 ms, rx 247 ms, tx 24 m=
s
> >   after "set freq 5180 80 5210" and 2 s:
> >     5955 MHz: active 11929867 ms, busy 521882358 ms, rx 247 ms, tx 24 m=
s
> >     (+2411 ms active, +148026 ms busy =3D 13 x 11386.6)
> >
> > and then held on 2437 MHz, a dump a second:
> >
> >   time                 active (ms)  busy (ms)     +active  +busy
> >   19:03:08.317  11929934     521939291
> >   19:03:09.360  11930980     522041771   1046     102480
> >   19:03:10.407  11932023     522144250   1043     102479
> >   19:03:11.454  11933072     522246730   1049     102480
> >   19:03:12.500  11934118     522349209   1046     102479
> >   19:03:13.544  11935161     522451688   1043     102479
> >   19:03:14.587  11936229     522554168   1068     102480
> >   19:03:15.659  11937307     522656647   1078     102479
> >   19:03:16.734  11938350     522747740   1043      91093
> >   19:03:17.806  11939423     522850220   1073     102480
> >
> >
> > Thanks,
> > Chris Kelly
