Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C69929CE9
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 01:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789866300; cv=pass; b=S3YTDFtg0aAHTzZhZzDXGEMb8aIFF1gH6DT+JHZ3TxNDBMUH1Arc9amwyy4NYEouOw/NHJ7ROlqomc23pjXwOBMBUrXaJ//AlfMl51TMDfmucAoccLnIGy+dvbdiA7dUsaUNFxpx4u7cRNLzXkPSkin8RCSwTH56jO8DUFAVKH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789866300; c=relaxed/simple;
	bh=V/WPATiDKq5j2pSXafPDKz/BGN8f/W15iVhvDi/7Svc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=bR6jQqrINWasEA1uu5SQtunH2v5zfMpN23KLttlQO7R0QyXcJzI1NsxPCRC+MdJevdaIesCVSXjCsdM+xJodbwoc0r9BosUlIALk+s0IHEUGyc7+iyetuqtDC/ZI9blq8TzAvjoC7iCpc85Y3iesEzjTD8Kpt0mTGB7xaJbGfQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=naturesafe.com.br; spf=none smtp.mailfrom=naturesafe.com.br; dkim=pass (2048-bit key) header.d=naturesafe-com-br.20251104.gappssmtp.com header.i=@naturesafe-com-br.20251104.gappssmtp.com header.b=wld36nFg; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=naturesafe.com.br
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=naturesafe.com.br
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naturesafe-com-br.20251104.gappssmtp.com header.i=@naturesafe-com-br.20251104.gappssmtp.com header.b="wld36nFg"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9984f9adcso3333812a12.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 18:04:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789866297; cv=none;
        d=google.com; s=arc-20260327;
        b=Qixda3qTsmtnmtsuk1zIG5emQqMyK4EbqNONpWFfJuaEX7mszrxlBBp6B1rS5af+PC
         VUYcJuDPn/0Ma3MixaWQfzGc610F5XOo9SRU5OxJ5gntItUiQbSQqUnjb2ytXE+7MIU2
         B9h0GcxvR2D2OzAWzaulqFSDXbPfrzfWxEboHz0C3ca/smJvsxFprhbnkzbD8riVOGbZ
         88zYx6j4RmcDIjsOptZ1fJ84yI62w2uyTA4F27tc92CMZhj3cglrwl1ZdBla3A3Ddbbf
         kPwWvTI/qOH1xSVyUeefI3bZYA9+Y1KBJ41m0U7kQ46CdZEWJ/UFsqragc6Z29YS2hGF
         BVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=4mSKeJA053EylhwvY22bogojFZ/zl4zkW6KmKPvAKEM=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=ZZAqw/OLho6UIFEx5LI/pZNtaVa6YdnRrO/JlS0Zy1RKCEJ0G4xch2O4ArsOn2g+2Z
         itw0pnDZ8jh6gjumMImKc1yyfAuEADa6TzxvW9H3xkcIoIu/apOs1bJoDDEYorOLMGhc
         mSEUPhwxbGs251bt0qAFRPXXLSufm06pGEinZRbNo3LVdTaJxwqPCeykFXEcTfibjcX6
         sBuR1ZyCUMcc0+hbvnThPxbfSfT02BCYXtEky105L4lQuiEQ2lTsPryZEPwZ+hgrjUfA
         rGeVadjsP0t4hHDKgqwQwRtq+wOXeoNlrsbHltRGoZmv7XJc6CTnlvvXdR+70GbmVWGg
         s6bw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=naturesafe-com-br.20251104.gappssmtp.com; s=20251104; t=1789866297; x=1790471097; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4mSKeJA053EylhwvY22bogojFZ/zl4zkW6KmKPvAKEM=;
        b=wld36nFgXesE3LtVtzUqZBusUqIgT7jcWH1P/LcE7nSz2OqOPu6GnhtFK7o6Bt/tE+
         Zb3bESVETu7Z9L6iVPJ73EdoDunbt/HDZxC0n8H5jRLdYeQQxUOREMk2SUpMXJVUC9AS
         IItZwSV4Lpn0jiUeLUg0xG6hj0YpXs2A4BLo7BoTxmrB/qp19tOFMhrJaDaqVcgCTfN8
         PaX4nT6fGWqWDE+TuBVx5q6DTAVcApAa4GNjCxIZTcTbYeGMNuPXXgXTZJLTbs4mTkYq
         jp48m2EFzSICw7Xa/vOR8D1O0ZtLpfLFNt/qqxxCEEePjIIFMF3I9FDhLRa/lLns/JvA
         xWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789866297; x=1790471097;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4mSKeJA053EylhwvY22bogojFZ/zl4zkW6KmKPvAKEM=;
        b=KDW6bqBtEPiYxmE5qXUmc790NPljsaVqHjVKBy1994Z35D191Xtl0zriEBYZ2IycwO
         o7wgQDsB3zoym+r7b8Uao03vbpYY4i5+3nEbsErIocWr18YwiY7S51JuUif5Tke/g5Xw
         PKVRrj4EnS+5vB1ZK5rdG1rnwBxMjAoSqEUe90wRgDA+CFk/81dPDRobHvrwKJjtC3u3
         LnttcelmWxfUtsRTq0YpQCr/BvVA8uOepKuWknkSkscwK8SMEVE4BvUPaqJp0JmWhj7+
         afKYXjyxcJvuVQcDkSOrQcM3P6j3ENOQBkrI2IYktD6aFuVWvbGODOcCHmqFRA1qTwlK
         1cIA==
X-Gm-Message-State: AFuF++kvp0nuqovK3ekkQ6gbiKYsETTlbWjoz96f9LIHLcE0hgjAZUgQ
	MYygaCbYrIFeHca46Jx7I/WLJzqmn44vNm6HUJysdUlNiqu3/jM5CwC/B+flDn1XmVJc1LMLakU
	39ta1NJdkt7SfbNjiePJ/+t8A7xGg07PGOxmUwXNJthnGFdYPqpAS
X-Gm-Gg: AYBFou0xtha8iR0r1FV7fLLyVwPI48KKwjAEC09N30vF/f3fuw7Gt58Ysmpc/ky9bUv
	Q0vtQpYH1GBoXoPjrvlOiKQO4EtemePPjOWJsjR2iVWoXjA3AiPG+8T/8hiwK0k4KYHR7+sCdK5
	l/OXmijzpHNqXeXuhORjlcFIAi6ElG/EoAz0eRYSS5FJ7SdVPeGI5Tuyis8kxS+xzuqWkSORcKe
	TrGeysKV0r+S85Sx6N+0lvp/CMMR6qhuyGuRB0UQsZfecDY+z8ACad9dgwTobRsUp6oFzmkRns1
	kLRxg/L7SijLIAIQ41z++SLd0LH3ozbPzGnU4I3HZhp4vutBkQadIR+64QcI8x1ZewK7L6gTkce
	nBpd41U8gBC6A
X-Received: by 2002:a05:6402:400a:b0:6a9:98dd:afd0 with SMTP id
 4fb4d7f45d1cf-6aa569a1e28mr5115357a12.40.1789866296847; Sat, 19 Sep 2026
 18:04:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Francisco Hoffmann Colombo <xicohoffmann@naturesafe.com.br>
Date: Sat, 19 Sep 2026 22:04:45 -0300
X-Gm-Features: AcwNN1XGNmKPc1JPQDptyRPxJWcHLNXhX9Vk0u7lzZHpqebvCpK4knluRgZxn8Q
Message-ID: <CAEdC-tgam1Wkgaad4TrC-K9tpy80Hs-Co8=BLEX5F2e=fag3Rw@mail.gmail.com>
Subject: [BUG] mac80211/minstrel_ht: VHT160 TX rates are never selected
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am seeing what appears to be a long-standing limitation in mac80211
Minstrel VHT rate control: VHT160 TX rates are never selected because
Minstrel does not define 160 MHz VHT rate groups.

Hardware / software:

- Router: Xiaomi Redmi Router AC2100 - Chipset: MediaTek MT7615
- OpenWrt: 25.12.2
- Kernel: 6.12.74
- Driver: mt76 / mt7615e
- Mode: AP
- Band: 5 GHz - Channel: 36
- Width: VHT160
- Client: Samsung Galaxy S24
                                                                  The
AP PHY is correctly configured for 160 MHz:

    Interface phy1-ap0
            type AP
            channel 36 (5180 MHz), width: 160 MHz, center1: 5250 MHz

However, the AP only transmits to the station at 80 MHz while
receiving at 160 MHz:

    tx bitrate: 526.6 MBit/s VHT-MCS 6 80MHz VHT-NSS 2
    rx bitrate: 866.7 MBit/s VHT-MCS 9 160MHz short GI VHT-NSS 1

The same behavior is visible from the client side:

    signal: -28 dBm
    rx bitrate: 520.0 MBit/s VHT-MCS 5 80MHz short GI VHT-NSS 2
    tx bitrate: 1560.0 MBit/s VHT-MCS 8 160MHz short GI VHT-NSS 2

The same client can use VHT160 in both directions with another AP.

Looking at net/mac80211/rc80211_minstrel_ht.c, Minstrel VHT appears to
define only:

    #define BW_20 0
    #define BW_40 1
    #define BW_80 2

and does not appear to generate IEEE80211_TX_RC_160_MHZ_WIDTH.

The MT7615 driver itself handles IEEE80211_TX_RC_160_MHZ_WIDTH and
converts it to bw = 3.

Corresponding mt76 report:
https://github.com/openwrt/mt76/issues/1134

A mt76 contributor confirmed this is a known limitation and referenced:
https://github.com/openwrt/mt76/issues/465

Would adding proper VHT160 Minstrel groups and generation of
IEEE80211_TX_RC_160_MHZ_WIDTH be the correct approach to fix this?

Thanks,
Francisco
