Received: from mail-vs2-f35.google.com (mail-vs2-f35.google.com [74.125.227.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033BE47DD6E
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 10:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790937910; cv=pass; b=m78GEDwHTKdxdM7eOX4U2E2hUUJ/CJPKEYEIp2Ok5zQGsNWAfzJ504oPL0Ld43TuYEIlNufoByebjGijRCEVibMHHY+k7tWGQQxP9B65x297zPPHyADI2rE3voWc4kf+rS23Wcx/Kk5MizJSdx5CdLjkCBKGT/mNjhDN4poNnDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790937910; c=relaxed/simple;
	bh=RMW1S/w84MpDzUDHWdyQSao1BRRlj+PxT3yRhEJvAOM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=NhglOTIEcKw+ooTX/OMQOmLjqJ3u2XiQS2GjVeYjy/BospDLiEfVwb6akgMT5hWBhFs1nDgqxmo5MD8PAwe0WBtoT9jNG6tVoPUp8cGeu9nO9UeOPFtcMhcZSXGcn4rUO+lqTrX7esL3TtOzUmuefQfqufKO+hcgdfgN/v5/+Qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M6DEaBVt; arc=pass smtp.client-ip=74.125.227.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M6DEaBVt"
Received: by mail-vs2-f35.google.com with SMTP id ada2fe7eead31-7bf9eb881f7so1082542137.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 03:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790937908; cv=none;
        d=google.com; s=arc-20260327;
        b=oQ9e0Ps0FS+3FKy+kCqPPL2wkqF0kw64AmctpbxxJsRSWeELUO72TRW+gDbsQjFfAl
         PdTX0/PdbX+lWT/SYdmFsqOE/iM+lSHlb5VcemJJnfk4EGylSvE1ny5Tcg/f+cf8cdrZ
         eOX8+xW/o49N2ufTM5ThcJUaZqU5ycmgXSmMFgi96YFvRTTWgNqOjstZxrxgijx0ZdnI
         b6ZpVtyS0hAvQtQfd0/qQezK8ovqRTxSezXvUspRpF6Sr5nhHN0hF3vgXCTNaSOmu74v
         sNUxVUuIJRzROcTCvms+fxOuX1HdGPRutdw4t9LW1YmzN/2rGx1VSkyH8aJh0hKjl/HK
         mPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=NvsDI9OStdZYXScGSi/orF65l/6sbhTFh+TJKJ7Fcqo=;
        fh=SB+iNamqw04pSbLtNx3lJQeGsQjT1FLlR/rGwc0pBlI=;
        b=I3qK//4D9Brmb0JDI8+JHk/WXobLF70FPCK9PLndhGjaY8wkRuwBBUWUi1DIBgqcdG
         L4p1esaAGbhoGfk40wOkPt78kfh8y9MiG69eiROjGLEGJ7SDZcLoDOmEph2KkqSN8PRS
         ycyvcKJ2Ca0F/D1wvS49EoaWyqUaT3CcxBNbcnlHQkc5P0DkvNX9fQLrDfdP5zXoofQA
         ArVWSAeyrljTRFipCsZE+P37B7E0u76UDXAqMMQBXvMwCglc6rak4jtQTu8cMspzVS6d
         g9djIf+JDhqp6lrnAeT7Qzk0/TbEIVg/yADR9ibNrwXHOBEr9CaZ09W6w3rSNxnvLZAp
         aYTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790937908; x=1791542708; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NvsDI9OStdZYXScGSi/orF65l/6sbhTFh+TJKJ7Fcqo=;
        b=M6DEaBVt7gLP74p2i/1rSy9TtK/EM85ulIln8zZOWC7Fy3BvCeY8Li6XDp86L0AeXL
         i+cC9YDhepB5tY65jOP4esO8bOjHKNAlrftmP0lZ/2uv3xYBA09Angp88gRKmN59ZmKL
         kiJjKyJKWF9iND/Mb6da9ymZGCXms2p9NVv0BZlPBt24WVb6ZlMV3XNdJWlwtgwpNWk9
         nkDalj9JSwbbHBvktfRanGJihYGJXGlw5e6eMVV/rkEgpAnjtxcWX5LWwPXKVeoeLcEZ
         SYk3bnjxdfqMoaQCbIYw4cKjGKCm/GzOf6CFMoMLqR2JXYiGOIDzeOECkeSD75j2/pQw
         /WRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790937908; x=1791542708;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NvsDI9OStdZYXScGSi/orF65l/6sbhTFh+TJKJ7Fcqo=;
        b=UzFKNausMUI0VVe9TmY9qdsUPPcDipeD6sffE116lNzZsQp/Rvi+MtxQ2tePRdxC/2
         FkQ3dr54GGOnRO7nfXxoRqKq2ovzH9jeLGOVdv9myPtjxkJDcZd5g+Ry2GYuY1i1GkPX
         VinPSWRE5hrFCsGT6By4lXBd2crLRe+uZTRO0fu11+BjxpOs76lcy31BJHTyk6h2n80V
         4NGrxeFL7gUDYyi2ZFJxRI03JQicLhhdeVIq5/FrLo4wTUB6NudvUrNqBwJtIrULL9pV
         JIHrfiFBkjpblGsSNmYsEIPzxqHPeqrVYaoONc1gJVVy2U99ISlt2WL7aE2EJ55ln2/u
         zTww==
X-Gm-Message-State: AFq9FYI/n8VNLf1iCwYze6kBCQVWYbxvTZVXDOCkmN3Kfv4G0wc5hBY3
	wtYuMhrVc63/zhvQaMDDhRfqcdZXnNv2qr+0Ojp7c8u+fdNpxXblwTGfrBLgF1g6znzdJ6NlP6e
	E1+3OgJfXwq/6c+N0kI5ZLxk7gACnw5VikB6vi6PT0Q==
X-Gm-Gg: AYBFou1aI1Iq5UC0mfiwzpsS5vWjuHbizsjgka6TfHStLuKFe4NJls8FAnUpDMpyZG2
	b0+bWSyH3KT1AqsxmsAgJSeSM337qni6Zsxx82KZI1nMFAiIc0mAn2wjKtLB4cn9LfYKr6aMZf+
	27Vl4GJYBeW+DMA1UheaWfJRbjlUPGI6h9ZmFI99Fphft6xSPWB1/GHIensIUOXpYAeSho4p6E2
	YKmsmV8prsy153eK3jSQiRPI6tNf2ZjxlAQQhRCDN/E/Smd4mObjBA86kvvntwX3uWy81t8Dp11
	b9jdS/jqcVBBpKBkDj3SCzaLRUSor7lYSdGbUf4EYYPc1yGjfeDwiu8=
X-Received: by 2002:a05:6102:5121:b0:7b4:6e46:4cb6 with SMTP id
 ada2fe7eead31-7c0f498c5fdmr671089137.6.1790937907743; Fri, 02 Oct 2026
 03:45:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Arttu Pitou At <arttu.pitou@gmail.com>
Date: Fri, 2 Oct 2026 17:44:35 +0700
X-Gm-Features: AclHuK8ZZ3xv2ZvObBYo4EhsiYKzhiCNdOaHfYxeOUlh-c0TKMy_rwUMjJOXN9E
Message-ID: <CAFnd8PdQA-1WHd_w4ODdXnN-+XiQDfLr4FNMYNXXHzOZY56XPA@mail.gmail.com>
Subject: wireless-regdb: Cambodia (KH) entry omits TRC-approved 5725-5850 MHz
 WLAN band
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org, info@trc.gov.kh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I am reporting an apparent omission in the Cambodia (KH) regulatory
database entry.

The current wireless-regdb KH entry is:

country KH: DFS-ETSI
        (2402 - 2482 @ 40), (20)
        (5170 - 5250 @ 80), (20), AUTO-BW
        (5250 - 5330 @ 80), (20), DFS, AUTO-BW
        (5490 - 5710 @ 160), (27), DFS

There is no rule covering the 5725-5850 MHz WLAN band.

However, the Telecommunication Regulator of Cambodia issued Type
Approval Certificate RF-TA-2022-1104 in 2022 for the Astronautics
AFS6460 Connectivity Module.

The certificate explicitly lists these WLAN Tx/Rx ranges:

    2400 - 2483.5 MHz
    5150 - 5350 MHz
    5470 - 5725 MHz
    5725 - 5850 MHz

Source:
https://www.astronautics.com/wp-content/uploads/2022/11/Cambodia-RadioCerti=
ficate-AFS6460.pdf

I encountered this as a real interoperability failure rather than by
auditing db.txt.

An ISP-supplied Huawei HG8145V5 access point in Phnom Penh operates on
5745 MHz (channel 149) and advertises a Country Information Element of
KH.

On Ubuntu 24.04.5, Linux 6.8.0-139-generic, using the in-kernel rtw88
driver with an RTL8821CE client, the sequence is reproducible:

    CTRL-EVENT-REGDOM-CHANGE init=3DCOUNTRY_IE type=3DCOUNTRY alpha2=3DKH
    CTRL-EVENT-CONNECTED
    ~5 seconds later:
        nl80211: kernel reports: Channel is disabled
    ~55 seconds later:
        CTRL-EVENT-DISCONNECTED reason=3D3 locally_generated=3D1
        CTRL-EVENT-REGDOM-CHANGE init=3DCORE type=3DWORLD

The client then reconnects, receives the KH Country IE again, and the
cycle repeats approximately once per minute.

For example:

    10:10:18 COUNTRY_IE alpha2=3DKH
    10:10:18 CONNECTED
    10:10:23 Channel is disabled
    10:11:18 DISCONNECTED reason=3D3 locally_generated=3D1
    10:11:18 REGDOM WORLD

    10:11:23 COUNTRY_IE alpha2=3DKH
    10:11:23 CONNECTED
    10:11:28 Channel is disabled

Channel 149 at 5745 MHz falls within the 5725-5850 MHz WLAN range
explicitly listed by the 2022 TRC Type Approval Certificate.

I am happy to prepare and submit the corresponding db.txt patch.

The certificate establishes the permitted WLAN frequency range, but it
does not state a general Cambodian maximum EIRP for that range, so I
have deliberately not guessed a power limit for the regulatory
database entry.

If there is an existing convention or source used for the KH power
limits, I can incorporate that into the patch.

Signed-off-by: Arttu Pitou At

Arttu Pitou At - =E1=9E=A2=E1=9E=B6=E1=9E=8F=E1=9E=96=E1=9E=B7=E1=9E=91=E1=
=9E=BC
Edu | AI & Cloud Architecture | DevOps | Cybersecurity
Phnom Penh, Cambodia
Website: https://working-draft.org
