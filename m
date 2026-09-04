Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC5B519938
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788546613; cv=none; b=klEaz5fchSavvZLtE30H1KAEYM8Dma4/6/mX7Uo4rtB8CQu2wpQ+v9gNp/o0hc4Ugp66yoFcKTK75iU+HwfXZyp3P83yRMoRM5O5soPC5BwJLKLy4VMPyN1EHV09UqlCPiuEYzYLLpV6dv/C8Fw7QTGHoGPz/VB8VG1kfz5FtXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788546613; c=relaxed/simple;
	bh=JOVPX9mJAgEY9P9QUcV5TYqqDHNJ6DeCWFPOQgxN+pI=;
	h=Date:Message-ID:From:To:Cc:Subject:Content-Type; b=plLrPnxjfUTJA+wJoSdvT2+215ZAkfLue6qXlTWHzkIqrYzfyS0jWdcDSqIDS2qu6DHQijx//AerqpwpDCNlz607Z81DQGsANWchjmUmIdYzx8mkDpJs2/vbRHgpwaf2SBMd30Z4J2WVsInXtaDb8xDqmFT/oQG9y4eyURGhegE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eT0grXNi; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eT0grXNi"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3969e82ff8fso1444855a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788546611; x=1789151411; darn=vger.kernel.org;
        h=content-type:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+FVQDqwY4yOK1b7Ca/fCnzSAexkd6ZecfuH5u7/amtQ=;
        b=eT0grXNin5B+/3XjRy670vKlljmvt6SV5cw4fzS+hR3290PB7zqqpbox5RyPuAXEKn
         ixhyjDE5A33xHzgd/weK9y8Gr0gOMHI1n48ts1xZRdGOsx6JXOmENrAcb72eYczdDfAU
         xjRKHjhHOI5ey4X7quJegkRN1cC7VMwFMLDLOurHBLTabwvC1G9IeDZhqZ1dhkd+DJLj
         vn6S+mHvpAc4kKm7dWphgFj5jW2IYT1x5KadDzzQh3WtPbe3kywdlbVSsTobzKe4Nxy+
         xYSo3Ip1CuS27lTwU5Pnjqjk1XV7wj8meIBZ7aX2r8sde1/AOK1U+a2/dzBaO6m4RXTq
         5s6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788546611; x=1789151411;
        h=content-type:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+FVQDqwY4yOK1b7Ca/fCnzSAexkd6ZecfuH5u7/amtQ=;
        b=ksTq0RdlRjz124tq/5XuJg0GBuBVNr1HcAWZRX/714aEVM5j6bvv4jmUzT4FT00R6d
         pQYkuHwF0ijogDrKCpxP/as+Tsni/QZp4w8N7YBRrdsk2N0WQMdYNHsnwr0jc+C2HFZ/
         rXnOnMh7qG7PiUWvH9P8/KSnQ4PyrRJCbyY1l5VjrmA2jkDmUYzHu4brsYFlNwn3yX0a
         8YYhFuCaUIqxSUccG5i6cem9+n5zQ07uXZQ7hB2ra1KFXv4vthwCG+BgnC7AV9J0Kzbz
         2A0sx76PcaX73e7X/rP4C8Hh5YWaM7ujBhg+GYyA+NuHHEe2wc/PXrcD5SrEVNke3edq
         AKFg==
X-Gm-Message-State: AFuF++m3Te/iyl66+qBdCo6dyXNAiL5My9/y9dzH12gAqx08ksays99B
	ukwx+u+d4ufRFJ2NRwZBxxMNaYcLpjtpNZA8SD9BgpMtg3+oohDt4vbymCS2gcsPgTk=
X-Gm-Gg: AYBFou2uJARc0hBtc4/d5oRqKrk3xmMKxoVwRIxP9iN1ut12w5OEh9tpkpnN8twHo3R
	XmoAfvUSlylVJl9dk7ZrB1k6sfZCaWDpCRtD6T2OAUWNzcQSWFTYcvXlwDt8sUGHPOAWZ99JnND
	4+AmABr+o/HLXl690j9HdXrcbDbhWDn7vmFhX2xl1EQKYzNUTRm3gBHYMsfB4C29ijIzLLiNd/s
	1x/6JCdTPOHJLFxZM5XVWCFOhj9JQp/odye5Uub5X/NyD/YrAyCU5d06JxhH/+/b0N2kuzMI6/1
	3mhQeReC+1irGMO3wdMeFxKLEUoBonPe7qlmYFBtxDAtd0UE2THFEhDHj7S+OQ/UShWq1gLvzo8
	txmc1D4awhKmZeDAPVW2WAwP+GHvJ1PxjDKS/76eP+8OAzv38oWLR7cUiuFTjNoxl9Kv1+F7p7C
	7Pa6qFFYhn+KINz66i1cx5M+IOam8uycffZ+CdPGZF/YxrovQ6aNHusDaZa86h5/tJiRKS6CiyW
	hVeKY5GmBKAdiI9l4z3C6nWAsvJQORHlD+/UBG8inCrRwyY1cwjFIglc6YOL2lGqob2omP1awU6
	/pVtn1TcUrK8dRIyBXhoZA==
X-Received: by 2002:a17:90b:582d:b0:399:e97:8d5a with SMTP id 98e67ed59e1d1-39b2627fe18mr11352035a91.25.1788546610758;
        Fri, 04 Sep 2026 11:30:10 -0700 (PDT)
Received: from localhost ([122.179.130.175])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-333959d5f69sm8000538eec.0.2026.09.04.11.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:30:09 -0700 (PDT)
Date: Sat, 05 Sep 2026 00:00:06 +0530
Message-ID: <cab32383bff0af2e4b31a86422d20d71.ankitdange37@gmail.com>
From: Ankit Dange <ankitdange37@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org
Subject: wireless-regdb: IN DFS ranges result in DFS_UNSET and prevent mt76 CAC
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

Hi,

I am seeing an immediate DFS/CAC failure on an OpenWrt 24.10.0 based
system using MT7915E/mt76 with country code IN.

Environment:

  Device: YunCore AX820
  SoC: MediaTek MT7621
  Wi-Fi: MediaTek MT7915E
  OpenWrt: 24.10.0 r28427-6df0e3d02a
  Kernel: 6.6.73
  mt76: 2025.01.14~8e4f72b6
  wireless-regdb: 2024.10.07

The India entry in db.txt is:

  country IN:
      (2402 - 2482 @ 40), (30)
      (5150 - 5250 @ 80), (30)
      (5250 - 5350 @ 80), (24), DFS
      (5470 - 5725 @ 160), (24), DFS
      (5725 - 5875 @ 80), (30)

The DFS frequency ranges are marked with DFS, but the country entry does
not specify DFS-FCC, DFS-ETSI, or DFS-JP.

On the device:

  iw reg get

reports:

  country IN: DFS-UNSET

When I configure channel 100, hostapd reports:

  phy1-ap0: interface state COUNTRY_UPDATE->DFS
  phy1-ap0: DFS-CAC-START freq=5500 chan=100 sec_chan=0,
             width=0, seg0=0, seg1=0, cac_time=60s
  DFS start_dfs_cac() failed, -1
  phy1-ap0: interface state DFS->DISABLED
  phy1-ap0: AP-DISABLED

The failure is immediate; CAC does not run for 60 seconds.

I added temporary instrumentation in mt76. During a transition from
working non-DFS channel 157 to DFS channel 100, I see:

  DFSDBG: region=0 dfs_state=1 prev_state=0

The relevant mt76 enum is:

  enum mt76_dfs_state {
      MT_DFS_STATE_UNKNOWN,
      MT_DFS_STATE_DISABLED,
      MT_DFS_STATE_CAC,
      MT_DFS_STATE_ACTIVE,
  };

Therefore the runtime values correspond to:

  prev_state = 0 = MT_DFS_STATE_UNKNOWN
  dfs_state  = 1 = MT_DFS_STATE_DISABLED

The relevant mt76 function is:

  enum mt76_dfs_state mt76_phy_dfs_state(struct mt76_phy *phy)
  {
      struct ieee80211_hw *hw = phy->hw;
      struct mt76_dev *dev = phy->dev;

      if (dev->region == NL80211_DFS_UNSET ||
          test_bit(MT76_SCANNING, &phy->state))
          return MT_DFS_STATE_DISABLED;

      if (!phy->radar_enabled) {
          if ((hw->conf.flags & IEEE80211_CONF_MONITOR) &&
              (phy->chandef.chan->flags & IEEE80211_CHAN_RADAR))
              return MT_DFS_STATE_ACTIVE;

          return MT_DFS_STATE_DISABLED;
      }

      if (!cfg80211_reg_can_beacon(hw->wiphy, &phy->chandef,
                                   NL80211_IFTYPE_AP))
          return MT_DFS_STATE_CAC;

      return MT_DFS_STATE_ACTIVE;
  }

Since the regulatory state is NL80211_DFS_UNSET, mt76 returns
MT_DFS_STATE_DISABLED before CAC handling.

I also instrumented the later MT7915 radar initialization functions:

  mt7915_dfs_init_radar_specs()
  mt7915_dfs_start_radar_detector()

These were not reached during the failing CAC attempt.

The observed flow is therefore:

  country IN
    -> DFS-UNSET
    -> mt76 returns MT_DFS_STATE_DISABLED
    -> radar detector/CAC is not started
    -> hostapd start_dfs_cac() fails

I reproduced this with:

  channel 100 / HT20
  channel 100 / HE80
  channel 52 / HT20

Non-DFS channel 157 works normally.

There is also an existing OpenWrt report with the same symptom:

  https://github.com/openwrt/openwrt/issues/20699

My questions are:

1. Is it intentional that India has DFS-required ranges but no
   DFS-FCC, DFS-ETSI, or DFS-JP region?

2. If NL80211_DFS_UNSET is intentional, how are drivers such as mt76
   expected to perform DFS CAC?

3. Is mt76 expected to disable DFS when the regulatory region is
   NL80211_DFS_UNSET?

4. Should the India regulatory entry be updated, or is there another
   intended mechanism for selecting the appropriate DFS radar profile?

I have not forced DFS-FCC, DFS-ETSI, or DFS-JP locally because I do not
want to select a radar profile without regulatory justification.

I can provide complete "iw reg get" output, "iw phy" output, hostapd
logs, and the temporary mt76 instrumentation patch if useful.

Thanks,
Ankit Dange
