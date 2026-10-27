Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793087747;
	b=Q+qWlkTiLi/NGztuyqDYnpOEMk76imilnpeLpL0DdAi6DHzeJTuiA5MXEWvsZEc7P3Pn
	 Jgxy/qQUvZX1TJrZybVMyFypbjjKCcO14k9CfNvh56A4HM04yEBCcCgRmng9GQV9cXjxH
	 EOC3CxioXlbsOLM4WLdFQHGQGiLxHHU1c+dx71/pHVvRMlvxjpc8IotLGVPuBlXNDTGF4
	 Kc9myfKkGh+ur67wsWX63RuEmq+od9M/oEOWh6XBrXWr/lRJzDRKCRtmRCXGjMJaT0DmG
	 R6Xo7n/jG1LOPmI2zF28NzmJ2Kwb3LpbQLCQvKnbS1tz0DrznHr/NnBRRKO31a/GrsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793087747;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cSQTlLG50jQwGPTwtgCEXwH2UrPpxUH5zGtovPPmNz4=;
	b=QMZA1frKQjvAHlcEfDEwdE4ayddNlFKhHTA40JiqDZ7Mf0tGppgBXgjUC1hXo4sl9b0y
	 kLy2Vk2syd4G2Y3HuJ1VG8lhfGtcpQYuSuIQoXchVaUWQYQ2pWymCwZ3J14pOiOZB9++E
	 1GF/r4MtmCwHUTPgHsFq/NrMDtpl5BM5qKPS+bAKKYWrK5s11y7ep8SDgv9hjESW8I3qZ
	 eh8MD4Rg2Np2KceISTqce7S/QEYTjrOnBU4kLzv9kCzMMBfBC1J6JazJd+WymQX5RTO9d
	 r7UNC1FGu2ed9YKdLo1c2rpnpUYlFp7A4z/1ppz+WHMC80aSopxhLu/tLFTrT0bQ0Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=HzDJhZxV;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5909606A323
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 07:55:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5909606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=HzDJhZxV
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b3dd83e779so6544029a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 00:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1793087745; x=1793692545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cSQTlLG50jQwGPTwtgCEXwH2UrPpxUH5zGtovPPmNz4=;
        b=HzDJhZxVmtoQCAIggABmVlcSobIRd0cIL4P2kRfRYD/60boqaR67vwUxeWu0eDUx8r
         sLCkB8xmm7Lei0wUk8Dk3pl+Sx9KJNH+Qb03JhgXh6SlKX9Kep+TrvS5nzczwIPfPbFG
         mUrrGXQm1L5LA+MiotqMX6uKlHe61wCO3sP9JXle/nS38aub8Zy+6JcOFzPuGk/y//3o
         OgE94EAukQeGnYeILirR2O8nuvp+F8HxR2XmK6OXILvdpCd9K3pWOXfbV7TAtzSer0bg
         nSZvil1UCqh9siPkmM/tC4eAr6KjGLE3h2EDNoi4KirWpPu78gafAP5caeDY7eVghR5j
         DNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793087745; x=1793692545;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cSQTlLG50jQwGPTwtgCEXwH2UrPpxUH5zGtovPPmNz4=;
        b=2fIP2SR9mVr6JawzNWTOjIjPI1leB2IC4Ed+DbdD3cFDp3t4uYGnW8ZXVJg6UUflHA
         PDgFdsvh2u0DPHuD305Zg9Y/3rNVCj0PRsMiFe9D6FSqumRn4AQj+T1rbC6VhjklMA/D
         JxZdQD9ROCQ40rPFp8IZ7NfoTWqQ6gaL/Tvq3XlEAhZsinSycVMKyC+OA+VTTdHjcAaK
         2KxB+jpavvJiAm1e3jB6hKcfYF6qtLYDsIirSO01P+AO5xQH5UyS4hZbKz9DkXXRL4GO
         t9zvFnG8JPco1b3p3wbC+iLfkjLvWX6kAMqJuTq6tJJ7hbBIxy8Fy3EqjKJMREuvm0jU
         Y++Q==
X-Forwarded-Encrypted: i=1; AKwUvBxf9i7rpuSMYWWomUHoi1152yXCFb1GiJwCXukNuczTb6TdoLpMDUs+Rrmj+QvCH2bstcDlJ41V6Le5akoVzw==@vger.kernel.org
X-Gm-Message-State: AFq9FYI08WGx3PrvsmpHWRbHQnpvZdRAUaysW7mmr/3YMIz8A7mrZYBt
	QvwjPeXAtUpR149HXqMFwnHUFkK0K6mvNoLoos6WfvPRm2TmuRHPbLw8C93eXcotKg==
X-Gm-Gg: AYBFou2TAIHp+Nxj3H75JRa5F4rsChvblxbylrpPVZav2KI6A6mRIwfPak9gtTfYfqD
	EjtG1SEU4fwJ7NnS6D8K70M1XkdiQBBupTHuWd6aDwuwHFjst4LNp0AL5PRFzLnELz/LHMrZ13o
	aw//3rFPV4757FyNAOctBQ2l6AiqXVxTtYLqzsjncLs/H46EOLLAGz2QAtvC27G5G0Oz9yemGEs
	L4uKb9SXgNx3BRb/gqYKEwFID8CNmqMVUMeJkaZokYR72rxr/D3IkVPW7JkoTOI9Foc/MZmFZFc
	m5Q+bKHiUb48q4GNF3ggcn2ooOPMhzxBTnAON5mBoIitp2Hsbqtxr7z0ts/R7rxYG4LBTL5pWOn
	RE9Nb/u+JjXXtXCN6QVOq248PfDhv1jSFDkA6WMkD4fg7791a9pcbW/0D9hQqhmU2zf48J7kJRT
	4yt2IBR8N2CNCCTsgnnydEe1n5jLxkBqJpHlbRgIq9bBODSSNhGIgayKDKP6TW3Tkj+eGcbz1Ca
	7WMO2+PO3W46evGzosmdN9mCg93x7WhowO8jFksuPLZAFDBbSkLsdJxySjma7ZpDT07dqE26sb8
	KUdjMVYNwrPd2BDG52HS6Wyu64vaJwoDD5NA90pzKzSGujzztTNVjMfes7SI+J8ijZdvb6UvICd
	c66iEK2Y0rtndyqarQ+txCL8p5gJveigS56zSaDW5bBSJERQZSa5uujgeZH9gSDfkRefDoXyyTH
	NETVuo0Jl/HeL1LQiIRfOsQML/Cyso6vhFIaZfv5lfekvh73QAEqrdKt7NPlPTntDFm4skmsP8e
	ryXSggVFdMwlfprQTaAztviwMGRGA==
X-Received: by 2002:aa7:c405:0:b0:6b1:c930:652a with SMTP id 4fb4d7f45d1cf-6b442fcbaf4mr7007086a12.7.1793087745215;
        Tue, 27 Oct 2026 00:55:45 -0700 (PDT)
Received: from Desktop (pd9513dae.dip0.t-ipconnect.de. [217.81.61.174])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b445971a9esm4669251a12.19.2026.10.27.00.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:55:44 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Semih Baskan <strst.gs@gmail.com>
Subject: [PATCH ath-next 0/3] wifi: ath11k: select the hardware mode
Date: Tue, 27 Oct 2026 08:55:41 +0100
Message-ID: <20261027075544.19144-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k always takes the highest priority hardware mode the firmware
advertises. On the Zyxel NBG7815 (IPQ8074) that is DBS+SBS: three
radios, with the eight 5 GHz chains split between two radios and no
160 MHz. With Zyxel's own board data the firmware also advertises DBS,
which gives one 5 GHz radio with all eight chains and 160 MHz, the
layout Zyxel specifies for the board. There is no way to ask for it.

1/3 adds the range check on the firmware's mode IDs that ath12k has.
2/3 drops the regulatory events the firmware sends for phys outside the
selected mode; with DBS on the NBG7815 the event for phy 2 hit the
WARN_ON() in ath11k_reg_handle_chan_list() on every firmware start.
3/3 adds a hw_mode module parameter; without it nothing changes.

Tested 1/3 and 3/3 on a Xiaomi AX3600, whose firmware advertises only
DBS: no change without the parameter, and hw_mode=0, 4 and 7 warn with
the advertised modes (0x2) and keep DBS. Semih Baskan tested the series on an NBG7815
(modes 0x12): hw_mode=1 gives two radios, the 5 GHz one with eight
chains and a 160 MHz AP, without the warning from 2/3; no parameter and
hw_mode=4 give the three radios as before. Both tests ran on OpenWrt's
ath11k (Linux 6.18 with backports 7.2); on ath-next the series is
build-tested.

I used Claude (Anthropic) to help write these patches.

Julius Bairaktaris (2):
  wifi: ath11k: skip unknown hardware modes
  wifi: ath11k: add a module parameter to select the hardware mode

Semih Baskan (1):
  wifi: ath11k: ignore regulatory info of phys outside the hw mode

 drivers/net/wireless/ath/ath11k/core.c |  6 ++++++
 drivers/net/wireless/ath/ath11k/core.h |  1 +
 drivers/net/wireless/ath/ath11k/reg.c  | 14 +++++++++++++-
 drivers/net/wireless/ath/ath11k/wmi.c  | 25 ++++++++++++++++++++-----
 4 files changed, 40 insertions(+), 6 deletions(-)


base-commit: 2c50cd5d10e8723797f28c7978f1f61688e0c0d2
-- 
2.53.0

