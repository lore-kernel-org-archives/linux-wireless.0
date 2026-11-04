Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755690;
	b=XYz8Y3Dhex2CPD+0K23AkQ4be7PGL27zH2y62bmHL2yc8YgRnq69P1eDqXPqF3Myh+vT
	 UJSIeVuIhjVSKUmClZmoEB46GZY5XRajmoyT9ZLAivdwjFDOpdfdytXtck08DWQ6qIHfu
	 /4EyiJ6H3xCYZ8/fVV7qWwcaN8vbm7pr7FZKWAsoVFGl6rGM8rfnbRghLuMrNopxdyvWM
	 VsB7kZLakwBLyBvV7VGiLEKhfNE+rrYPd0IhwmitBnY3dkM14AsU6uxRnIY+leIIPw9rE
	 zOxoVgm2c7+ugMyq+xu59CEXV3EYRfasQxk78EC26jhu7H8y+MTxqC9Jmz4Tnau2LFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755690;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xJq2fm+aIUQbyb4skHpbNL4ev8kenfJ0MBmpQ0uQelk=;
	b=1A/H+8LvyxCO7ZCGtC5Bo3UjuqEqEe5+U+z/OqIWDkBEZ9p6mQq4POIqDQCfLWa6CQFK
	 OKTrQXHLzxydTb9GEQEn6bK5SJB5RAS+5tQHJzSZWGco56yde9e+0jtggl08/sbb+XIGB
	 P6PxafqdZkeiswk2C+qW5v+Qdelv6e0m5wSLIyBVaFjVJ8ITiFPrxG478mmRDaN+4OPBE
	 m4fUTvKT1eR0YOtvPDw7wd4xEdtklZ7Dk4rZmZXbqO2IHDjkVyo/akGmmKAHK8E0CER9d
	 E0ptnHG7wcoCsO6lfdGblGtF+FeWZlsG19G8O74zscwO9kBD1zQNa/q2+yXzULExxZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="qVUS8Z/X";
	arc=none smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C774C606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:28:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C774C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qVUS8Z/X
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8a070781f63so104791b3a.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793755689; x=1794360489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xJq2fm+aIUQbyb4skHpbNL4ev8kenfJ0MBmpQ0uQelk=;
        b=qVUS8Z/X5TkN8b7smZDgvVLIfCyiBRGPZ1aXB2p08B4+kr2B4huxsm6R1CEYLRHnIS
         tKi8lTYxyxV1OoNi4LpH94UWo0pgcfYjuVyxauFswQFzpzSOCMCVQ+Bk/yyg/3RAN1FS
         sHWnd7nzD/4z+1jgMp+FKsRikgDjSNcn8yjkrGfCUq25+93uCUlt8wxhCWUaq4o6U3qg
         LgvGoEC6Yp9CVAN2EOPpAnXugibRU7meXeJYT6xEMc40a9u5ixtC+7oVY9d0uF10Aenl
         j6496oZmz/FNrub7bb5UkPKdnjAKUTJEQwr+fh2APSUBBnVxpVv3icjNGBBZ0eTqPtPd
         OnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755689; x=1794360489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xJq2fm+aIUQbyb4skHpbNL4ev8kenfJ0MBmpQ0uQelk=;
        b=Yy5hySyO8xbEpj5dKHDUU7Fv33iasAx8IRpDL52IXW8DiobNlWec+uv+fO4rEUAEl6
         9q1lWdtJEHz13T+LfSb3/kvI8GA7uAZdtNf/k65ws0w7vgcWprxcD/EIKJjGh0sRTbL0
         PjYnDMLDhyVvtHQaZnQz3E/yqDHLh5NDy+WE7oz9OiXSRFP7ET4Z9E4/R+YR3HLn8QcD
         4AXW8J73v13aaMvCkzVw7KmmHZBpmip9UifE7gmPsXaRoTGWYP7TnF761KyCmYJgraIq
         Yv3wCHYFc2N5x1RyU6qs5/wn60Bp5rzKI1+huP3xYStXqkZwRBL99cAqNBtG7taPxtGe
         dZcw==
X-Forwarded-Encrypted: i=1; AKwUvBzJLHNw/mR9r2JL23rCnFlaoKfmtUKlyb1Mow9id13u02Ehp+UF6E09uBjtwzgfiHRubeKj81jKYjgtfA7KGA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9tzwGcMdWSFpks7/tklWpxiSPF/aAK7hIVCncbJRkdZB4l4MdZ
	7dXtOt52FO/aeKpeLiITpovrbU9C/4H5uvbCNBbPSnFjDM3uMTRQZ5MVZcmF2aNjl+o=
X-Gm-Gg: AYBFou0TodYimQCzE75/ZU2Vz7B9eH9eL866aEsXhgnfv6KYhVw2SdBwRnFPWJUJE7p
	dQdaxa3zKu5e3q0B2oc/PfBBRGTYkQpOkFrG65vUYbr9oNNPVgNSERia+5w7Da22zWHvx7IyYIU
	KzsKryd1ve1/dT04rEJsaqz4+ok3jG0DNtaE7cwE87Xaf0ELIqD6qASqhk8adrf33zFLIvVRfKL
	yci8JTWBfob68SVFLCKP3PbmirLySl7ftBqBH4lIcl/smbkdfUa2xl5lgO4R8OUcdWdYt9/yEPe
	YTZzCylJnKZWgyL4ZNL5vTNC3uKKfzuwr9yVVf2DzYu3291Pz66kd2X+wYvU0dEDxjhRWVorx52
	4GU5hVEHf4s435snDHXk6CUf/c9r78/rNZqrerVRa/jwGsimzYSE4r4M7F7YHptw36ed0m8F/4O
	N+uLyZlZhH4ovgc18Z42r3FbDWYn94g/IhIajJeIhPGKnb7dOBipIlUYdUajK1wXCdF9mm37Zqe
	XushdKlct2DtfJfiEac8Ei3E4PRfPMijqBbNZtKFzD802prQsGYNtCpLy9XT0RXvUZK06CaIPbE
	beSBy476M0CQDgugD4gPfQERAMH+FIxSh02jZ4PvzzasBvh0CRUTwI0x/4ddlcSD53Djh2/QR9C
	3DhC+JVn5ncCb0wjvw+U7SmbTmelwTEbGPIpdGroQWuCs5i0=
X-Received: by 2002:a05:6a20:a11f:b0:3e2:819f:8a6d with SMTP id adf61e73a8af0-3e928d469f1mr13470464637.18.1793755689147;
        Tue, 03 Nov 2026 17:28:09 -0800 (PST)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb469814b4sm300794a12.26.2026.11.03.17.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:28:08 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/7] wifi: mm81x: rate selection improvements
Date: Wed,  4 Nov 2026 12:27:49 +1100
Message-ID: <20261104012756.510424-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
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

Hi,

Some improvements to the rate selection algorithm, especially at
lower bandwidths (i.e. 1MHz and 2MHz).

lachlan

Lachlan Hodges (2):
  wifi: mm81x: don't rewrite MCS0 rate entries to MCS10
  wifi: mm81x: use the default mac80211 TCP pacing shift

Nev Young (3):
  wifi: mm81x: mmrc: update evidence only for processed rates
  wifi: mm81x: mmrc: precompute lookaround candidates once per cycle
  wifi: mm81x: mmrc: cap the third retry rate at MCS4

Sam Chapman (2):
  wifi: mm81x: mmrc: don't credit failed frames as successes
  wifi: mm81x: mmrc: widen attempts field to hold firmware retry counts

 drivers/net/wireless/morsemicro/mm81x/mac.c  |  94 -------
 drivers/net/wireless/morsemicro/mm81x/mmrc.c | 257 +++++++++----------
 drivers/net/wireless/morsemicro/mm81x/mmrc.h |  13 +-
 drivers/net/wireless/morsemicro/mm81x/rc.c   |  14 +-
 4 files changed, 144 insertions(+), 234 deletions(-)

-- 
2.43.0

