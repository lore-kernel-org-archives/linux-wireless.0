Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792509876;
	b=C+rqa8NDh/Ybf7mF5SQh7/cejnvCeTh37jz0ZZJKy2Zsp6EDnskBqJx+TBLNGR7+T63v
	 1LXroKebQAD4TEKZX5093G/vzNvMThjuQHtY8PUDgyChHOuJld/dVgqfT44pkKlQN8hEn
	 sthciN1Tkhcy0Mmxd87CmrJwoYpsGgb3zm/0p4ntBHxmsiduQ2u1QsJrQUlzCxojbt6SU
	 ZMT2xJ/69FLw7Y9zY8lN81BBgY153QtMvHyv9dbnJilDisbxwTDZFR5DQ2vldGML2ppc4
	 2r5hfLkTzfoWWPAVXC6Qm+6eZB5LK/l9uPKJuRiWvvVV4iHFshFyP4GTZwavIDMZVhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792509876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Yo7lFEBSYN02LBZv7O1t6La9fyqMBtHX6dJoSLmRutM=;
	b=HtMOS4I/TI1vI5zXnFt2VXaYaXXOJeI3MhRqYnDRVsrYvd4xuPWlWmdIUT4h5t/+m8OZ
	 5HzlIrJNDZXsXptpRa4D0llS31ky0A3kWLbf8Zy9vNYPPEJPNtuMVCxSIVrA2SySCS9Dc
	 VVVNvTpbxIdT0D+DU3G/5ByxeezVHDvYi5W9W046lnNFegRiNdqDyQsjDZMmqVoGUr/La
	 8OL01V18hC2D7AjYVxZUWfnDJAR2EUbHx54Y+wRMhYdCsIytYdZpxAs6viN7h+Lu6Hszv
	 gIBXzBxe4dfqAWdd7uXd8kujzP56plpZI6i706x8CzM0+yZP1j/pl3phvEpFFJP3ipA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VMGpowgT;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9DF606A31D
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 15:24:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E9DF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VMGpowgT
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c34bff61551so478536066b.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792509874; x=1793114674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yo7lFEBSYN02LBZv7O1t6La9fyqMBtHX6dJoSLmRutM=;
        b=VMGpowgTivqWykR+z+tts82RoCt0Akfn8flpv2XxtrBtP26GbPmJCZWmVTx8WbEFi+
         fioWB3I4YB+s3XApsYejzO4LJkwOyzOrLnaVLkTP3YPFHtaWEXo78twbytbLdwNsEM7D
         /x6r8bREvJmScJvoImna/VWFOA/LuVKhmJ7IfdeCw1ijNu6UaEYdC7yk+9nL/mL5Rz+5
         b26BR/j/icX2nurs1k/9nNU+7K89piSbe4xm3GOzBEzELxZJy0d8vadZTryCrnp78d7E
         N+hF4dGzbdlGX5K16Gy4iwcHnrlSUr8VO3QsSA8flZ0VR8s6OWH6iHj+xY4D85x8z5vz
         lFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792509874; x=1793114674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yo7lFEBSYN02LBZv7O1t6La9fyqMBtHX6dJoSLmRutM=;
        b=wOkXNOVQWzbyxdThRErDsXBuRftxxLiWHxFQAzDDx8nlAOnSijurWlB+yC+IGSo6E+
         RjRT81wufQhsDQTWLNhRv5+Gkodjp7E4H/jyNJ6iT4hz6GS5zHu56aESLxhlLdALgyTx
         5fCZTz9O71E1JB0ZCX8kLGgR0u9Wi33zOvTLi87HmjP0B0MOBAq2ettG4YCGdGGVMbeX
         rnsNiHK+M2EnJkgOMBPElBlZkgqWygga77eARvnQigmeY3LweJsbggLdguhrlB5diPkY
         VoGscfV9gnEw/gcn4wmrNbec8C86bExQV/HS1kzH04v0sdzvX2q0CpcFK1vhCsMUC7bv
         c47g==
X-Forwarded-Encrypted: i=1; AKwUvByIiw+xw1Gegax1w/OvwmtOpjJw5SHh5QAaQtZy7VAlBc3dJaH2j3vvPdmAoVBMvbbIwCkqYhSesT3te1rwjA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLGsLgrBHKwDs7YnM3QweAfCRMeb9wrC64Z4hxq+em00wuTuVp5
	7llr+/Pna1+UG/6wTt0c6gChA/TvvZMoVspeDy2/pX8aWyhxivhYw9Dw
X-Gm-Gg: AYBFou1w41BiNp8s9WM4nAkyg2aeNqOBv2rqEcVMCBjwWFnD3pcogS5f/2xak/MfoQd
	LpTJ9AWYqgIvqpCv8ZEnZNKtCuR09J6pvuOxnTpUEfvEniYraR9GQM3SZk8wwdgTYMTm765zTS2
	4j4oo9QklBCL44exBeTAD1v0WHirIDmcs7J+woEotsqLU7NOYIE9nku6PahN3bRYJZe1aNNKXhD
	p2SWr+WKxlvpDxX7z3K6nFy7vJYfridYsevTqNHr/bo6BGODNp+Vl/LHaOogm5ZiI7/+dnTRgF2
	WprVBzQwT8oMmyJ1LcNbxfCsk5z6lWsmGqd6e7wr0xEDbUgG0nIneVb7+z/CnCEYhXGtf/0B4xZ
	eouLgSnxHuxvcga//fB2+5PVTcBRvuY0eeQeYNXX4k7XxzN0heQMOlnMYS0m3Dvbc+caYKCyG6j
	SH0/4o7lYqQ72PkcAnj5W1ShRdMtTRV6FmpyQR4LXZ9JmEwhe0BObliGHndoRzGAALHg4JGSXyp
	DSLQQXI/afpNEDnj6qRBcwfgWQEv+26/yOyMk0GOxcqU44vLEDyfBq7aVl3rzNwJUwwPdU/s/t6
	ppfZcTghZHV2e0A04EdMAwTjBUWTId7m
X-Received: by 2002:a17:907:d385:b0:c40:b59:1b with SMTP id a640c23a62f3a-c419fefec7bmr807389166b.44.1792509874132;
        Tue, 20 Oct 2026 08:24:34 -0700 (PDT)
Received: from Martyna-s-A34.localdomain (ip-80-113-116-3.ip.prioritytelecom.net. [80.113.116.3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40919bcfc5sm488110466b.59.2026.10.20.08.24.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Oct 2026 08:24:33 -0700 (PDT)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mehmet Fide <mehmet.fide@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Subject: [PATCH 0/2] wifi: ath9k: fix WMI command response handling
Date: Tue, 20 Oct 2026 17:24:10 +0200
Message-ID: <20261020152412.95560-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Both patches fix the ath9k_htc WMI command response path.

Patch 1 stops ath9k_wmi_rsp_callback() from copying bytes the device
did not send. It replaces the -EMSGSIZE approach that was reverted in
commit 90201351a862: short and empty responses still complete, and the
rest of the caller's buffer is zeroed.

Patch 2 stops responses from being accepted while no command is pending
(after completion, after a failed send, or with sequence number 0),
which could make a duplicate response write into the stack frame of a
caller that has already returned.

Testing: temporary KUnit tests (not included) drive the real
ath9k_wmi_ctrl_rx() and ath9k_wmi_cmd() against a fake HTC device in
x86_64 QEMU under KASAN, KMSAN, UBSAN and lockdep: short and empty
responses for all payload/buffer length combinations, duplicate and
late responses, failed sends, sequence number wrap, and a concurrent
stress test. Without the patches stale bytes reach the caller and KASAN
reports slab-use-after-free writes in ath9k_wmi_ctrl_rx(); with them the
tests pass with no reports. Builds cleanly with W=1 (GCC and Clang) and
sparse.

I don't have access to an ath9k_htc device, so this was not tested on
hardware. Mehmet, if you could give it a try on your AR9271 that would
be much appreciated.

The series applies on top of v7.3, which contains the revert; ath.git
does not have the revert yet.

Michail Andreas Michalopoulos (2):
  wifi: ath9k: don't read past short WMI command responses
  wifi: ath9k: drop WMI command responses when no command is pending

 drivers/net/wireless/ath/ath9k/wmi.c | 47 +++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 7 deletions(-)

-- 
2.43.0

