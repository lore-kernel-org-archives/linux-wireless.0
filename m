Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942EC360EF2
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 07:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788594262; cv=pass; b=QigX7sMZwqZj71y8YGMCeVUBmcLqqP8g2P9xpHe/uyUlWMXFVGOFmi9N+tBThv4qh+xVmpIK8KxKdQBKPQPoWs6mIpnXxvUmtnKBteIz3YyxIYmOhjz1QNN8Nmi8drMhd45hDAsmqG65h4uz16Scf9TLMUfW3Pl5UfddirZfddU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788594262; c=relaxed/simple;
	bh=AS4zUv2lSqlxaqJrjKhNRa84Js4d1yg7rGIaJqWavJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b+DSUe4rjlGgkI3AWNL8QZ9IJ/K8qOkyYD4OWaVFZPUTfnX/wUucZI7ZQKVLmEXfcz9ypfVoMCFzgOBxkX7a2uS8zS6TiZEf2hqsxrtwmKExvjs5SQ2kRFRNoPv1KsvE5o9L8fBADJa4pC5YjQiEPcHo9HermeuBTaokpSg4lrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pucp.edu.pe; spf=pass smtp.mailfrom=pucp.edu.pe; dkim=pass (2048-bit key) header.d=pucp.edu.pe header.i=@pucp.edu.pe header.b=QLAIc2Nx; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pucp.edu.pe
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pucp.edu.pe
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pucp.edu.pe header.i=@pucp.edu.pe header.b="QLAIc2Nx"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6b1bcd9e00bso1619396eaf.2
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 00:44:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788594256; cv=none;
        d=google.com; s=arc-20260327;
        b=SKr0Ca18K+1MWzOMXB1YX0iqnXeNl+fh+QHBRwCxQiLmNBspxr8rD0RC+ib5BOR3JD
         c4vzhW8yqoqZHfPBvVeiYTcdArEdn406HumDpgYT0RCLwYFbI5sB5YvdStVB7zknfuSX
         q0jy87Qs7S9wEEkw4mtLSyoX0j1pOsa8NsYaja4DJPLnpP2yIH8mKBJXlyDs9en7GgKL
         FQhQORQe6jND9+PeK8zDoAN9GsYkVzQPVEU49liLNnbQrIaPLXNF+qKGPN/nTiPkon3x
         SQg63qlcfQllxoAvfC2A9BCpDoWJSmZTA3bXU5CJUtKqMADLc7Tjsn+d9nLNPmzf82Bt
         wMPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=VKumv+C9LGxhNDX3eja7TBvB8EC8/joW6ajq8nUXt6c=;
        fh=KmMyK0B5GYhuJz2QwUuVD9H4K7FQGuLp1oeaBBdVNRM=;
        b=owtTQvu7Vh+WrCbunlEz7vvhpXmazAau8pqVIdvMxHI/x6B3KqubbfL3Nm04yzaQER
         teDN2Azw6XxwD69kftdRzKqpJmyGhA6R9sJZ7EB28AqkHrjIR86YXCMH8wD4Ho2FPuPs
         EO2MbrHNXn7fgllGR1h0i3I3Hfa7mCA2FepVXg5CAfoErWMmRNJG6BI8ajpFmst8LaI/
         9rCW2+X7C8Hfb9Yu+QCmvMd99S/9pXBUAWzl0BQbnTMVcWoCi5G2wNQ/12nSa7Bc/+Z3
         tsrt71HAirXtc7iG/ZvsYjxJ/SOI2eL0L11RcofYjDBMqQXaEkrk5A5VKo62cdu+N+Da
         cFiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pucp.edu.pe; s=google; t=1788594256; x=1789199056; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VKumv+C9LGxhNDX3eja7TBvB8EC8/joW6ajq8nUXt6c=;
        b=QLAIc2Nxxkd5HOcm04nDqKxCaXE2MIVOsHHyRU6Kv7nVDjI+hKGKrzB3x1vqntax3O
         JIxbdb0IDDnk+VsffZGRztwjw3w16O2bfqld6+KzIad8g3nyAr5Tl0ze6Ln30ZjnbdYc
         nwGyHLnG+eQQt5bLAn9YdWMspP2bgqa4aYQFYGpilunmYQHyh6M6LQ73AnZGfZFE+xj+
         52qB/YNuIF2my6FeWpW51w6kvyYa1ZxB/nouQz2PMWw6uMHAeL62IiW9aoCA7aOsoPOV
         GTF1ivruenznxSXnXUn4Kzb+PYDYR5WvqBQqvYqe8eLDuKr/mCWGcpf5gWZmbQ2ndO6y
         nLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788594256; x=1789199056;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VKumv+C9LGxhNDX3eja7TBvB8EC8/joW6ajq8nUXt6c=;
        b=gVUB4Sn/OSIAw4ix0SJYiNHTBfqTJJ2VJxwyUTMkAuKE13O/3k0+grjSoAMOnLaWKu
         rRyiTZJP0tBbj0zh0kOmHte1DFhHdPak7hqf3ldWguCZRcjiRdu+IureR0U518rw15ZE
         zUejshgoliJ5qlymTJcsrEdPKmivub0RjhGYLWPt3Ry/okTeKPYUfZUU6hFU0KkgTMKH
         71bip8ZpIqNRSvNGbkQYBO111rHXpkYG0SAx1etO9FG2F0CVD0ZRFyDnQ61hINuFxMbH
         97EMwodlLybp0liOdbskCqmOJCFTH39PV/eUCKeLvt9SSOkJBOM0ynGDyfXdbn+xIaZF
         cBnQ==
X-Gm-Message-State: AFuF++klpkkPUhCNQGkNoen2Novim4yH07wseb63KcJe8+6qI7BA7bXi
	gLfu9YH5LG6z2wgkbgsRWqCKXNiVnEf0Zljo+xByC5aW0wngUkZCynVTGsIYNFP1ywZrpxKfCy6
	MDcPgzvXHKZAv81geNBe4Jw4aRvJQXa/66zXKJr2R4A==
X-Gm-Gg: AYBFou0xvo0AXFmoOmaamV+eT1vFPF0W6ZbiSPZ7Q/GMKCoQRBLHBitTNKWbPDQ88HP
	ZHc/igA2HUvyunFe0yI2PXbSihJ/MNEmONJ4MlfQp2vMw3NNzwCuBXyE+K8Fft8ScdQIuVVm7eq
	K2DHYUUP2GLEnVmsTCbbRCsuUnXaVrvmQ67XCx/pBBVHTx9ox4KkiQrAl9DTHdvaQ7ZCAZf8Bxz
	naRcK5qDBAgxHYwArMpKDnmNJW2iK+cE19BaUd8DzF+GijO/xGdENFHQXd72O2hsReCiSh+eEAW
	xjf9CCF/syzUW4Kv/YSEDna1w9Ubmn0KYN2dQyl8MCSKYaFU/7BEo6RPh2ngYQ+nsbWRearErnG
	L
X-Received: by 2002:a05:6820:16a2:b0:6b7:83c5:fded with SMTP id
 006d021491bc7-6b783c6032fmr5290544eaf.46.1788594256246; Sat, 05 Sep 2026
 00:44:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+Hv-VqrxKWETcegx09-=v7udVO0Rk1CY9nPjw8sDK3mzgw-JQ@mail.gmail.com>
 <20260905063728.31929-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260905063728.31929-1-lucid_duck@justthetip.ca>
From: Pablo Diaz <pablo.diazv@pucp.edu.pe>
Date: Sat, 5 Sep 2026 02:44:05 -0500
X-Gm-Features: AcwNN1Xw-GCdDvT-JxoSHth2fGD5jic5DngS_vLS_83LL23Ms1QnAxkD4I3D3Wk
Message-ID: <CA+Hv-Vr2w1qqGgPtZVJo8F=Lu+VtL16QokTAhaXaTCSfObtABw@mail.gmail.com>
Subject: Re: [BUG] mt7921e/MT7902: firmware programs near-zero Tx power for
 all 20/40 MHz rates -> assoc fails except at close range
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"

  Hi Devin, Huy, and MediaTek maintainers,

  I tested the proposed ACPI SAR changes on another affected MT7902 system and
  collected the runtime MTCL, MTDS and MTGS data.

  The main conclusion is that this system does not have a table-layout mismatch.
  Its MTDS and MTGS tables already match the v2 layouts selected by MTCL.
  Therefore, the table-layout validation change is useful for the separate
  mislabeled-table case, but it does not fix this particular machine by itself.

  The problem on this system is the raw 0xff value present in every pwr field of
  the selected MTGS geographic row. The driver converts that unsigned byte to
  s8, producing -1, and then uses it as the effective geographic power limit.

  Affected system:

    ASUS Vivobook X1605VA
    BIOS X1605VA.302, dated 2023-04-17
    MediaTek MT7902 [14c3:7902]
    AzureWave subsystem [1a3b:5520]
    mt7921e
    kernel 7.1.13-200.fc44.x86_64
    WM firmware build 20251212032127
    regulatory domain PE, mapped to NL80211_DFS_FCC

  Runtime ACPI values:

    MTCL: 19 bytes

      4d 54 43 4c 02 01 c1 cc 81 18 00 00 01 00 00 00
      08 00 00

    MTDS: 31 bytes

      4d 54 44 53 01 00 02 01 1e 1a 1a 1a 1a 1c 1c 1c
      1c 1c 1c 02 1e 1a 1a 1a 1a 1c 1c 1c 1c 1c 1c

    MTGS: 42 bytes

      4d 54 47 53 01 00 05 01 ff 00 ff 00 ff 00 02 ff
      ff ff ff ff ff 03 ff 00 ff 00 ff 00 00 ff 00 ff
      00 ff 00 03 ff 00 ff 00 ff 00

  Decoded information:

    MTCL version: 2
    MTDS layout: v2, nr_tbl=2
    MTGS layout: v2, nr_tbl=5

  The PE regulatory domain selects the first/FCC MTGS row:

    01 ff 00 ff 00 ff 00

  For every supported band, that row contains:

    2.4 GHz: pwr=0xff, offset=0x00
    5 GHz:   pwr=0xff, offset=0x00
    6 GHz:   pwr=0xff, offset=0x00

  The MTDS table is populated with limits between 26 and 30 half-dB units,
  corresponding to 13-15 dBm. Therefore, this is not a completely empty ACPI SAR
  template. Only the geographic pwr fields are filled with 0xff.

  With the normal parsing, and also with the table-layout change alone, the
  relevant 2.4 GHz power table remains:

    OFDM user: -1 -1 -1 -1 -1 -1 -1 -1
    OFDM tmac:  4  4  4  4  4  4  4  4

  No MTCL/layout mismatch is reported because the firmware tables already have
  the expected v2 sizes and entry counts.

  When the raw MTGS pwr byte is checked before conversion to s8, and 0xff is
  treated as an absent geographic limit, the resulting table becomes:

    CCK user:   30 30 30 30
    CCK tmac:   35 35 35 35

    OFDM user:  30 30 30 30 30 30 30 30
    OFDM tmac:  35 35 35 35 35 35 35 35

    HT20 user:  30 30 30 30 30 30 30 30
    HT20 tmac:   35 35 35 35 35 35 35 35

    VHT20 user: 30 30 30 30 30 30 30 30 30 30
    VHT20 tmac:  35 35 35 35 35 35 35 35 35 35

  This does not disable SAR and does not introduce an unlimited transmit-power
  value. It retains the valid dynamic MTDS limit instead of incorrectly
  clamping it with s8(-1).

  A 5 GHz network smoke test after applying this behavior also completed
  successfully:

    channel width: 80 MHz HE
    signal: approximately -70 dBm
    negotiated rates during transfer:
      TX up to approximately 144 Mbit/s
      RX up to approximately 432 Mbit/s
    forced Wi-Fi download:
      5,000,000 bytes in 0.735 seconds
      approximately 6.8 MB/s, or 54 Mbit/s

  The power-table change is the decisive result; the network transfer is only
  supporting evidence.

  For the implementation, the important point is to inspect the raw unsigned
  field before assigning it to s8. Conceptually:

    geo = band_pwr + idx;

    if (geo->pwr == 0xff)
            return dyn_power;

    geo_power = geo->pwr;

    if (geo->offset != 0xff)
            dyn_power += geo->offset;

    return min(geo_power, dyn_power);

  The pwr=0xff behavior is demonstrated by this machine. However, this system
  cannot establish the meaning of an isolated offset=0xff because the selected
  row has pwr=0xff and returns before applying the offset.

  Could MediaTek please clarify the firmware-defined semantics of these fields?

  1. Does MTGS pwr=0xff mean that no geographic power limit is provided?
  2. Does an isolated MTGS offset=0xff also mean that no offset is provided?
  3. Should the driver ignore the complete geographic band entry when pwr is
     0xff, while preserving the dynamic MTDS limit?
  4. Should firmware omit or disable MTGS instead of returning enabled rows
     containing 0xff power values?
  5. Is this MTGS content expected for the MT7902, or is it an OEM BIOS/ACPI
     table-generation error?

  The two proposed improvements appear complementary:

  1. Devin's layout validation protects systems whose MTDS or MTGS table shape
     does not agree with the version reported through MTCL.
  2. Huy's 0xff handling protects systems such as this one, where the table
     shape is valid but the selected geographic power entries contain the
     no-value sentinel.

  The combined code compiled with W=1 and passed checkpatch --strict with no
  errors or warnings. No kernel Oops, firmware crash or module-symbol error was
  observed. The temporary hexadecimal diagnostic logging used to collect the
  tables should not be included in the production change.

  I am reporting the runtime evidence and test results only. The layout work
  belongs to Devin and the MTGS 0xff handling was proposed by Huy; I am not
  claiming authorship of either change.

  If the next revision preserves the tested pwr=0xff behavior, please feel free
  to add:

    Tested-by: Pablo Diaz <pablo.diazv@pucp.edu.pe>

  Thanks,
  Pablo
