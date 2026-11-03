Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793678741;
	b=RH2bnn0+vObjKihHGsj6UZ42rev8jDdUusDmMUguolO/Hjj8s1zwVivEC/nriahKujQq
	 9ZxWgUdCdJDrcbBKhtr4zATHAKG31feIdXPlYTR0XbsK5N1cBFJn61sM7kxQcNgSgyx1i
	 WofshCzdZRup4aUPWoeYI0AZDiT7+W4MCvnWSUREyRKEirSSgGHh5n0tEJUm6sSQTVYrv
	 xShcLbAkQetseT0ib/cNajA+yYVOq9wuODq2TsytScaJP4C8AfoEhAkeqcYXJl+OIFK4L
	 kTS/m/ib6FvIUTCUnESRa2zfniVcZ3CcuAWp3iTyprRflXhFt25Pr1Dyn8w4RnLM8jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793678741;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KH9rI+FTAkxuqkR13fgxbhWlIQGCWTpzaXY6qAYNOw8=;
	b=3JARK48v5psHA/mmlbSbX3qJCS+SLBaeptBu1SBuLaNhZka06OKD79Qv0zgabBsx2+QZ
	 tYj0fDhwe5DOxBUbFJ5H8dbSegAwt3quepFaPTiCYrDgojLXhcV+gTnpCxjDPFhoSl6Gv
	 +GmxFlmc9LoXQRhB4xPYIhuISHDydpz2dcaGEeRWBLyD515bOJzpDoO6wwIB9x1I1Vb/A
	 8wLqxq6J5UOIjmyi2g7ymr5I0dAU94n9Aa9l6Z7Uj84ySz0r/dlpieN1wFhGTu4UouTPN
	 vH2bRO9m3K3CBETN3chZmFDacv+4RS0GTWMrl7VjKdL3RzyNtmsSL1FKFsl0GZKQMQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VC4aHlJE;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A17D606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 04:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A17D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VC4aHlJE
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so2719809a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 20:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793678740; x=1794283540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KH9rI+FTAkxuqkR13fgxbhWlIQGCWTpzaXY6qAYNOw8=;
        b=VC4aHlJEECYQhQst69I1XrZOtM7Enman2NbHYbwiS7NNPJQy7OAJ3n64dwkk+SAD3Y
         JIQR8wMVlsnqEgmEimUKfo896/1Gv29hpHOkrOzZvaP3EDIQnW16NF2gh3eDa4IEa2y3
         sAlXbmlC2bn4jV+gPwdHDAPEuLyJNJpuvjVvbxodu3mdQMGW1yy88CNPfDcnTzH/FnE3
         VQDCbZnUm8qF9IcTLmV/4eEsBb7EI4qqXW/iGFNtK4C3b2L8xKbeY9dKXds+vojVsCaE
         sHuJbqoZhhV73ZyqyVSral7WrzhCF6CcvkJhJrYia76W3wFq17TmgiSwVzCBUVDPbn8v
         Z4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793678740; x=1794283540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KH9rI+FTAkxuqkR13fgxbhWlIQGCWTpzaXY6qAYNOw8=;
        b=W6IIugo4ubZ6ZY04s4Pdqi0hlhBrGq4ftAglk8Vh11HK1TAHU9eH1AG2wS25AZ4Mg1
         ArwAuAEUm24HYZlcRNLEv/CqKKXD6chrcLc4aAHc5L9R1pjrgNnRMWrB+PbezKynquy/
         BjdN20wZxOcQ41j+eql91cJepe+cywrdjYjxl2LkcpN5yv+OHwyl/n19sQR7SohxyN8i
         /BT4gjnvY0YNHFq3Lt03j/CtTXX6X2gyxq/zEYQbWigxX6yyWm/IpNc8r0gLPBdqDaEM
         kOAIwxHIbj98gbP/djhTmmfCnya87hJyU0Tklp0rrJw/Pg5HNdimL+Ic3mWzJLQIVUdd
         FOwA==
X-Forwarded-Encrypted: i=1; AKwUvBwxa9kqHMxXJNSLNeKaZqWAokzEtF4pNWcsB60XZGgpRXinEatrMBV7TvweXjSI1oDX0RDOYHsgcKgbZm7obA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/ZBx3hVOjuqYn2xig+dJQKFnpUGXD+Rim7wcdWtdBvxyE15bz+
	ibkLR4uDbFypaqyBW6VpAnGhp+RTrcrLHlMZgvPWS78tGfrSAYRpMxs=
X-Gm-Gg: AYBFou2MtF7ufKDgEkXR+GJyycW1j04II6ACfmL5yX3E3oZ9eeSdkbWJ/yBuy6Yfc55
	ljn1TDzr0g18/CNgR6yb/wD8VzrohExsVY6BruRSp7aY/ozNf/01+BKAuysI8EyZ6CkjlOviCn9
	csQNUrRYCETPu/43KWtExWr7Bfp/7ie83f1f5vbEuGL0V7pGO9i9fHndw9Nq8WaGN7e2ogAQ7j8
	dejfiy9oFBmqkHPeoZ/e32EezvdyIfONCyCWJKyWOq79XNG1Y25Tejn5PE4ybeAzhfGdjHM/KZO
	iXFzvLYErGHtsK+459dPAa8qFTh9KEjKzXxpa/CuBfEaQz7ruzTucCfdJ7l+WrQFKf9XDZIMd5I
	extu3jdLN3MH8Yt8ePrEWDzW4viHenjCK0xmWEwZEu9TDwaUJoSLyVFpTUV5rdlgPLIiJH+Ba+M
	Ru29rCS6Dxv6DVdlQzhHayTnRqhgJGS6ConBK2ElUJsAHsbZYdvXIdDlcJ0uA2me06R+aQYVQpX
	SEgGglQGx8FdKCclt5OM05cSyu9rWeJuy8LCYxamLIHpEYgF7I33+jPO9eDIcAcF5Fh2WZwE/ZI
	xLT5P7X5NPLPAAKjfTEtul7uVMXOmbh07Sl+8Kg6Wcu9Yj/20sg98gntO/iknTV1BW/lWoX7OsE
	L/biboMPAr7YrFw==
X-Received: by 2002:a17:90b:53ce:b0:3ad:6090:a190 with SMTP id 98e67ed59e1d1-3ae89817b01mr10006990a91.41.1793678739857;
        Mon, 02 Nov 2026 20:05:39 -0800 (PST)
Received: from freddie-kane.lan ([71.212.222.246])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c5844acsm1965531a91.4.2026.11.02.20.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 20:05:38 -0800 (PST)
From: Burke Cates <burke.cates@gmail.com>
To: baochen.qiang@oss.qualcomm.com
Cc: Jeff Johnson <jjohnson@kernel.org>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org
Subject: Re: [PATCH ath-next v4 00/11] wifi: ath12k: resolve RX link id via logical link id on WCN7850/QCC2072
Date: Mon,  2 Nov 2026 20:05:33 -0800
Message-ID: <20261103040533.3388284-1-burke.cates@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
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

On Mon, Nov 02, 2026 at 02:38:09PM +0800, Baochen Qiang wrote:
> ath12k currently relies on hardware link id to resolve the link peer. This
> works for QCN9274, IPQ5332 and IPQ5424 but breaks WCN7850/QCC2072 which use
> logical link id instead.

Tested on an ASUS Zenbook A16 (UX3607OA, Snapdragon X2 Elite) with
the on-board QCC2072, on v7.4-rc1 plus c752394249f8, 02121aa4a012 and
1e678e37ff13 from ath.git and out-of-tree Glymur platform/board
patches, without Miaoqing's "fix MLO 4-way handshake timeout on
QCC2072". All 11 applied as posted.

A Wi-Fi 7 MLO SSID (SAE, PMF required, 2.4+5+6 GHz) that used to fail
with reason 15 connects as MLO with three links: 12 of 12
connect/disconnect cycles and 5 of 5 rejoins after s2idle resume,
ping OK each time. Non-MLO 5 GHz is unaffected. The firmware sends
PEER_EXTENDED, so the host allocation in 8/11 was not exercised.

Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00277-QCACOLSWPL_V1_TO_SILICONZ-1

Tested-by: Burke Cates <burke.cates@gmail.com> # ASUS Zenbook A16 (UX3607OA)

AI coding assistants helped run these tests and draft this reply; the
results are from the hardware runs.

Thanks,
Burke
