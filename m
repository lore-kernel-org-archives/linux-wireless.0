Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DD3356762
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 23:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790464281; cv=pass; b=R7f+spxYv/LBRKwKODefPGzdvPHMoAvpxR4DNM5XN0um7+f2B+Cu02+sJr03rfv1iBW0J9sVSOfWWaOqNsCXyyUxsGpaQuk/qji4XmDwgD09Q8Hpv9qViVzRLwEI01a/DCDGFTppmpDWbHpLnXonRt2c7pv91BrLk5ka2rtWQgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790464281; c=relaxed/simple;
	bh=mReUwtFswoxyDUHSMT0fFutB58rqkFkFGaTJ/PDkSVg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jgkm0rw2KV658zdT77IOdUEoUMM24tAO10Sg0ChHjRpm1dGzmF6Q6KfXx2J+Vq2o9vkKtu0PDh/uy0Wl+o6rxuWkHMSjgc7F2lCy8ezN4y/LlvPGwe7NG44CYi0/t1oh3XUXgAUZOVWHbJSCqEmpklmtEOVcH7EYzMVM2nSu5/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iUqM5S6/; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUqM5S6/"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4d2fe2056so649178a12.2
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 16:11:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790464279; cv=none;
        d=google.com; s=arc-20260327;
        b=a3SARPVS6IqSUDTAle5Cqykkc7+x5OBzyv3RSdq41w73lU2r2Iu/zFgO3Q2quttBtq
         y+Qpbsm0jU54sNWPvZzxXOtVVjiJv5lwhkiJl65uN53qVSGz/oceIzHcipeHq6oVKNXl
         SzRgIfAyxABxa54xLAMcFKqoesuYW5xldf9XVCWGINnr9StpMbwk8CftFzZ/FF1620Vv
         EzOYYajRFBsl67caKLuFAekk6NMsb9BYguSylH5Vs2rjTXQuAmca+d1N8jhkihjR3CeS
         ZHccyjCVvmqiZxBEUlDSh4fka8AMzbrVo70Gt5VFr0qvrqoplobPeZnTPEqoek8LuijF
         qKHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=q9c11yhyxHWfQbJUuPKbPTVPsBQh0G6SIrvthdlXbL4=;
        fh=okC+ffmPnwP9v8VGQE1L9pF5jMl5wfp1spON8Ne0s+k=;
        b=bQerSDlcH2VR8toDnq2WKMhAoGIXzozjC48KbF5i05+a97i3mjoC6wOLldRQ65Ewr8
         CAMCTgLRsVNCEF2jPGMnop4Cunhchek27cQdyIY3XSEoaBJpVYY8M0b96GFyGSD14gAl
         yvhaHhaez7fQNv3yxsu8gHWb+7asE6Uq11PTwwwHdTfFUgeGKEomm3+GLzUDtIjPCApT
         k08ZCkDoVD3lMJxEAVLNnR2vgXwY1f1rOa4ZgHh5kWWQ/CV2Jnp/4Q6dlI+bqfbyBlbd
         VX+wVc5ml9d30MZOey0rSHbm96Yl18IOVM8bPRFrJD8JF6g0keGliX1V1Z4/CNgwZtD6
         Bvhg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790464279; x=1791069079; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q9c11yhyxHWfQbJUuPKbPTVPsBQh0G6SIrvthdlXbL4=;
        b=iUqM5S6/fOIaRM8BhMxArx7tsUsT3fMUuhf8DUgmcufJ17gAcScJgHhc2HGnykWBIq
         q9gyp//AE/tWpbPgHd2rASdSRSCOMV84QNBGksX3a8dkgQPNM7jqHgzY0C4i0jdVN/Ah
         W6MiWmXc/yp8fdrmjXXDAoBGCf/euUdBgRmtcfU0WWCQV4DOfUefRas/6HGLx6HpoKaj
         2lD7QZV/ptmnJxr3eT7ThS31cYOAMpg/DffY3cLPM8WP/eFj+310MHx1c2FnKh0q30mA
         9SiYTAhO/eJ6j/8AoNFMna/I3jrA1le4+48/XKmIXYARAcHS3ZVaTX3Tx8sIJP7HFMJ0
         MsuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790464279; x=1791069079;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=q9c11yhyxHWfQbJUuPKbPTVPsBQh0G6SIrvthdlXbL4=;
        b=BomX2mh22C9kakU3mRuExGS8gmS8bl13nDmNF9466P9WbBVrak5/h6PJgj28jfimr9
         quA7EWG7WW0pgplGRoVWUn+mOdJv1n8Bo3QXzWW2+iDqeXumD45Rb3183WOHHCzix6No
         ho3yK/Z1Ih3DkRCXcc023kHPsyAIsEAFdaWRsQB9knn8zs4UNsxUMA8+xJxgXmyNT0eB
         ggJSFFp/kBjnQxA9+ils2KGkWq/dZB3NcLz3OqIjkQyfvGINGjJVgh9904DiNX9UQ5e9
         qEs0sQjE0w76Bh8uYorT2qtg2OgtFnXekJ8y7oOnVGvmjQvJF7PtXvcZove8ZNdC/lvd
         zzWw==
X-Gm-Message-State: AFuF++mqhVR9ppOhn/TFUeitgHWONiuUw0cjSOv1Oo3NPSz3IoLDrUVp
	DTKFGpOetESNJtg03zuRoR3ftKOlWwDKSbapUxcy8YpIJh732UKTsRTCEdMyI+dmrUuW+P16ekb
	vnkjqBTX7JYNcKFA/UVEw/4JWaqIJjiG0cEam
X-Gm-Gg: AYBFou2tmk4KEbAOJNsEuPpWQXNCkB1R9TmZwcZgukggafLGrYfKwrOeVZRR5tPJ/Ic
	mQw3zyuOKrkvt7wXDFyaexL3Ia/1UbwF9sQyNKWUxza9Kzg7gFJ9b4LRtGydAnCuYSki18Lj3hk
	GbOguhf8f0kCCfzUSBUSWNiGrGmk5kSCDGBiFtqhkKNsRN9F4b2RHgZ/4Km/3zHSh2WBiua7lrl
	NIDdpcIFsdcdDKWMhmDDbFUHKLSeeSza4BFOuJrlCMk8WkUX5IU4fHvQwSqWlyo1Cq4VzX96B/k
	eBkcBdOnCgQjESX6/12Ijgh7pwFtxNCtKGdpxLKAb2uyDTE0fJLmPldm
X-Received: by 2002:a05:6a21:a08:b0:3d4:52bd:b89d with SMTP id
 adf61e73a8af0-3de0e7566cdmr9449520637.23.1790464279450; Sat, 26 Sep 2026
 16:11:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Chris <hoopyfrood42@gmail.com>
Date: Sat, 26 Sep 2026 19:11:08 -0400
X-Gm-Features: AclHuK_rTru9_GY3ulLt7WeB63iAuq9E3S6Me3PyY71tz8QSyP5tB9qLMpIZYAM
Message-ID: <CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com>
Subject: [BUG] wifi: mt76: mt7925u: survey busy time is 0xADBEEF per update,
 booked to a stale channel (monitor mode)
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"

Hi,


On an mt7925u adapter in monitor mode, the channel survey
(iw dev <if> survey dump) does not measure anything: all counters are
booked to one channel whatever channel is tuned, and "channel busy
time" grows by a constant 11386.6 ms per update, which is 0xDEADBEEF
masked with MT_MIB_SDR9_BUSY_MASK. Details below; I can test patches.

System
------
Device:   Netgear Nighthawk A9000, USB 0846:9072, driver mt7925u
          (on a USB 2.0 host)
Kernel:   7.0.0-31-generic (Ubuntu 26.04.1 LTS)
Firmware: HW/SW Version: 0x8a108a10, Build Time: 20260605184651a
          WM Firmware Version: ____000000, Build Time: 20260605184805
Setup:    a single monitor interface (NetworkManager does not manage
          the device), retuned with "iw dev <if> set freq ..." about
          once a second.

What happens
------------
"iw dev <if> survey dump" lists 98 channels. All read 0 except
5955 MHz (6 GHz channel 1), which is never marked [in use], and whose
counters grow whatever channel the radio is on:

  time          tuned to   active (ms)  busy (ms)   +active  +busy
  18:23:48.404  2462 MHz   9571269      415246784
  18:23:49.477  5845 MHz   9572344      415349263   1075     102479
  18:23:50.599  5865 MHz   9573464      415497289   1120     148026
  18:23:51.649  5660 MHz   9574519      415576995   1055      79706
  18:23:53.000  6295 MHz   9575865      415679475   1346     102480
  18:23:54.050  5955 MHz   9576917      415816114   1052     136639
  18:23:55.097  6615 MHz   9577967      415907207   1050      91093

- "channel active time" advances with wall-clock time.
- "channel busy time" advances in exact multiples of 11386.6 ms
  (79706 = 7x, 91093 = 8x, 102479 = 9x, 136639 = 12x,
  148026 = 13x), on busy and idle channels alike, so busy is now
  ~43x active.
- "channel receive time" and "channel transmit time" stay at
  247 ms and 24 ms although frames are received continuously.
- No noise value is reported.

Analysis
--------
From reading drivers/net/wireless/mediatek/mt76 in current mainline
(not verified on the chip beyond the numbers above):

1. Busy: 11386607 us = 0xADBEEF = 0xDEADBEEF & GENMASK(23, 0).
   mt792x_phy_update_channel() adds
   mt76_get_field(dev, MT_MIB_SDR9(0), MT_MIB_SDR9_BUSY_MASK) to
   cc_busy on every update, so the MT_MIB_SDR9 read appears to
   return 0xDEADBEEF on this device. MT_WF_MIB_BASE() in
   mt792x_regs.h is shared with mt7921; I have not checked whether
   that address, or its access over USB, is valid for mt7925.

2. Channel: mt76_update_survey() and mt792x_phy_update_channel()
   book the counters to phy->chan_state, which only
   __mt76_set_channel() moves. For a monitor interface, mt7925
   retunes through mt7925_change_chanctx() ->
   mt7925_mcu_config_sniffer(), which never calls
   __mt76_set_channel(), so the counters stay on whatever channel
   chan_state was left on: 5955 MHz here, through every retune and
   through taking the interface down and up again (which does not
   reset them either).

3. Active: mt76_update_survey_active_time() adds host time to the
   same stale state, hence active ~= wall-clock time on one channel.

Effect: channel utilisation from this adapter's survey is
meaningless: one channel reads far over 100% busy, every other 0.

Possible directions (untested)
------------------------------
- Move phy->chan_state (and survey_time) to the new channel when the
  sniffer channel changes in mt7925_change_chanctx().
- Check the MIB counter address/access for mt7925(u), or read the
  counters from firmware as mt7996 does (MCU_UNI_CMD_GET_MIB_INFO),
  if the mt7925 firmware supports it.

To reproduce
------------
  ip link set <if> down
  iw dev <if> set type monitor
  ip link set <if> up
  iw dev <if> set freq 2437
  iw dev <if> survey dump        # note the one non-zero entry
  iw dev <if> set freq 5180 80 5210
  sleep 2
  iw dev <if> survey dump        # that entry again: busy grows by
                                                 # multiples of 11386.6 ms

Those steps here (only the non-zero survey entry shown):

  after "set freq 2437":
    5955 MHz: active 11927456 ms, busy 521734332 ms, rx 247 ms, tx 24 ms
  after "set freq 5180 80 5210" and 2 s:
    5955 MHz: active 11929867 ms, busy 521882358 ms, rx 247 ms, tx 24 ms
    (+2411 ms active, +148026 ms busy = 13 x 11386.6)

and then held on 2437 MHz, a dump a second:

  time                 active (ms)  busy (ms)     +active  +busy
  19:03:08.317  11929934     521939291
  19:03:09.360  11930980     522041771   1046     102480
  19:03:10.407  11932023     522144250   1043     102479
  19:03:11.454  11933072     522246730   1049     102480
  19:03:12.500  11934118     522349209   1046     102479
  19:03:13.544  11935161     522451688   1043     102479
  19:03:14.587  11936229     522554168   1068     102480
  19:03:15.659  11937307     522656647   1078     102479
  19:03:16.734  11938350     522747740   1043      91093
  19:03:17.806  11939423     522850220   1073     102480


Thanks,
Chris Kelly
