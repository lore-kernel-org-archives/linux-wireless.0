Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622200;
	b=Bf+qq/c5XXxjulPsp8r8GWXZq35Zk9EAn6En6m9iJnjGuDndXVyNLZeGfOSlhScocG3U
	 wWeIG8OxL9WBJ60rPTS6dj88F2+a3SKbU5baIFhuWjM4RNr48mH3htGBQAV1AkKCOZB1i
	 Z2K3T3Cuy8dCh+QmnbZh1YI+VZWHdtCx9UR3p9Xxo4PgVQ9qszCwthcfjMPUDkhnxIzRA
	 KihJ6Z+ZbZJ2RZB6vg/X9soqQoLze2OBGKUpFipuhoAEOpnk+VZ1EYd+cJK07NxWiiqcv
	 F5ia4jsyK+GfOejCb6QcQ//Cd36Vbry3gvdkvNoR2wE05n1r8JJcUSFanHnxVfrdlLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622200;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=3iOIXEmflTG6buskQdm9P4t1/QlWTCynkV6kHZ1H/SU=;
	b=GhtH0rgBv9GwhUwI48WplhQvT1jOQB2qjCSQa0jkwLIXxe/poLNFlARC/j7I5d/f3hc5
	 h5MAKgEQWsYWAi/YITyBU7XvQVwnSP5VqAiu8/cW4e/yi0kgajNnttXg3BzfJEwCuUfhD
	 akv77FNC76jewIzPvMaJuCwVjC8m0JXy0oKShkloQmcH/I8OgTCdqGGU8gfAz2NXhdGFt
	 ISs616K/hQzYFd+jl2w4lnuwSzjAUX1mcxoUi+EYr48cauCprmuewI4SaGEEfoBGAf1jY
	 RPqkqkd1kWXzK7ODgbDLtH0FCZa/nM8WuuAkv/eevMTNJPRlgMnl+nQXGBBBhOeFsJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nLb0neZG;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CDE60A5BE6
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:23:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72CDE60A5BE6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nLb0neZG
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so18348135e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793622199; x=1794226999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3iOIXEmflTG6buskQdm9P4t1/QlWTCynkV6kHZ1H/SU=;
        b=nLb0neZGvV479WoBpwIj25pg4oBMQzfLsX/vGfxHBPPiDY1cA13ZLlgn1/wgtcQQGa
         Oh1FlbOSDX8WkTKTJMRkn5iJPTchUVA4GqfUZtImC8ruihRuoP+4m5Zm1QMZvKzKHp7y
         Hyp7r7bLP7aevx1p/53mYyUnpdiM16zGmVI+jym1RoScThd0r6XWkvdRStIHHwwlJr21
         Zsl/j68kcCxWBeQ+Roe/anGUjTMpvruZh96erItD734yuS95manh5mosLywQGDsDAhz3
         c8XiDsiCnUE1M5/HHkQp2abQwA7g5YHuKaHgFNVBL/09nd8wvl552maXufFQUTNQAFT9
         r40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793622199; x=1794226999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3iOIXEmflTG6buskQdm9P4t1/QlWTCynkV6kHZ1H/SU=;
        b=PpCRh96QumrUbWCdGw5d8HASmZrprldsbYQsf2VmRTJZTUuPFIIcqRAFb0cSQ70wgy
         RtXW917T/yaw1zjZTk79s1FfK2jQME6ipgqB+cWheJZWujqRMceWDyqyJiQk5SQsX9bS
         jDpBqm4yKTOK86uYNFRzD/XHAbHWqyauLWmXtAty4zZr5nzTvs/ubPvMPKUhrnuSVbFJ
         NZIdxKsVyJFZ8Xpk9LLCxohBJA5d+8l6FAaQL3qHzG+Vo2RH1xK1JvLXkrKiaCpnRn23
         LDeO2MJcmiD0e6+5pDHZbU9X3fL8IFN/ciEJpzp4sLi+/HIu6Ql8UpsCtWGbAtcFFhro
         5/UA==
X-Gm-Message-State: AFq9FYI4VBi/8SRRYR+m+2Ll9x1GrsDLfkl3lkBWdHnwKKf2hZfu89eN
	w4jRb7rjRToQVzxZjUQPUIhN6T8HkeRBInSB6Olq2fqhTgQdZMciiUYttQdm
X-Gm-Gg: AYBFou1tNJPa9yOwCbLrW7abXqGFXBsHCCVsPZJrkKhg+Voqn1dsUDB1GcQ96viFFqv
	ZEa88Vf09+Qv3IlHTnqfOm67x2u4xU2qburt0PSMCUq2qPVP9c737pZwcQhh/axEh8gFg+Y9QB0
	DQEwJZDAGId4C0AfhEfEYO3qukxOp67dOIbktduYdHPfS37iRLEEkFjHDBuu/+OSwCwTnWu3C+J
	3b6tU494TH8RmGfJ0U7C8dRsWckl38mGnsSqjGIt48DFzw0xUcluRGiNGARPpmSmXGiNIc+uM1o
	hV6yjQfhnUr40Gc+mwjMOZDwHnvLTL3sVEhsj2p/Qxw2kEhjKK6nzBEhy7WRyjVuI+yxxHjQ3ky
	/y98Aet33BOjqvw9WdrE5PDsyjPX7upe9U6qFOqwFcWLgE5lyIhGigK+8rOsDsSA6d1woZWnDSm
	+xST94ggrPSM1NyzWLS6BPc+C9f/b8v2H/w5jtfRMFeW9svDM0bcMV+5XvUSUbtdxgzgi+Tmf+K
	PQY7ffR27Of/B4eh77VW7IHkV+wMXEGsK9WRIm15bGGfiCxlFHqFz5hBhVrGgtX1J0Y/I9LiA==
X-Received: by 2002:a05:600c:198c:b0:4a1:fc98:1cb1 with SMTP id 5b1f17b1804b1-4ac15584c05mr237157175e9.2.1793622198548;
        Mon, 02 Nov 2026 04:23:18 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf67aa704sm255490595e9.8.2026.11.02.04.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:23:13 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	fariyaf@gmail.com,
	linville@tuxdriver.com,
	kvalo@kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 0/2] wifi: zero-pad SDIO writes to avoid leaking heap data
Date: Mon,  2 Nov 2026 12:23:09 +0000
Message-ID: <20261102122311.181075-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
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

From: Tristan Madani <tristan@talencesecurity.com>

Several wireless drivers round up the length passed to
sdio_memcpy_toio() / sdio_writesb() for alignment purposes but do not
clear the padding bytes.  The SDIO controller then reads past the
original buffer into adjacent heap memory, sending stale kernel data to
the wireless device.

Fix brcmfmac (4-byte alignment) and rsi (block alignment) by
zero-filling the gap before the write.

A third patch for rtw88 hits the same class of bug but needs a rebase
and will follow separately.

Tristan Madani (2):
  wifi: brcmfmac: zero-pad SDIO write to 4-byte boundary
  wifi: rsi: zero-pad SDIO TX to block boundary

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 3 +++
 drivers/net/wireless/rsi/rsi_91x_sdio.c                   | 3 +++
 2 files changed, 6 insertions(+)

-- 
2.47.3
