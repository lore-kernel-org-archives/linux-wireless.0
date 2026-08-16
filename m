Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE761A6817
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 20:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786911356; cv=none; b=cI2mBpWgipGJPhitw2Sfid1Kx0eOY2xquftLqLGarn9o7L8onZ8w2FTMcY15IH9atNuFYF26QL6/rLPmhGfsY2ZXulevJiVXKL6lOGnr+8CKCHahbSS3mtX5NauBKB/eV/cuYEfgKtX5PBj4ol+KTLqfaXF+ZViuwRqWGiVWuLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786911356; c=relaxed/simple;
	bh=YLNFw0AG3etdwrl7ND3i6NgBpPAWyLQnnXdqNZDEzAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEEhvw8uxwGGVKRNCKd6VMKZVmWb/srbTmHk4DZ7SyGycd+a73c1KC0n+TQ2XUgxT9MxiYXecklF640AQd0jLBDV2BLVTZz2EHLnb/d+t4QI9xD4rOMUEgx6HINopPQj8i1gPhSY/QwhkEg1JJx+x5M/72WjxRYsDsJaUsDvtLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mPl7pPXy; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mPl7pPXy"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49800c6a846so31432765e9.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 13:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786911354; x=1787516154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hTar65Rimo56P+5q1sfLQwgooJmuM6Drj27jozp+ukw=;
        b=mPl7pPXyYGRUH7q/JMFRxHfVMUmZFoOLhkukwTPOd4fR7wWR/Dt+9P530BXm3SKfvt
         3OkuFr9mZCT2Qu5JRZFgOJ8vQ8sC61hykI678xecxHgB6/d42S6s9p4IT4NrLvq1MzYC
         pCoj1zB8LE5uQfPEN+qfsJW01zNNI3J8hnhOXN3BMYKfhOp6XLm48dTeM3Fh5xkJJ1is
         FfrVZ032/X1fMAbD5aM3vfaBmbhiFPTOjec8Fp81iWHuuIVOvobYILisvWxEzTXWn0in
         Ql0LqFtXML3uQoq3v+12gd6G+fSbUhAMJy7tqhyHNfqUPuZ/A4JDLuUDtH0RQ6zYFtRX
         rMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786911354; x=1787516154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hTar65Rimo56P+5q1sfLQwgooJmuM6Drj27jozp+ukw=;
        b=QnLya309Evk4fSs/OEBdgdVoxH1iNmWYYfKLsAoaINxwhrzwMvwh0XSMFyISbo8xJU
         /dVtEC4FjK5N0SCxkWjQBqm/44k+PpnVV2MtMmXZUjRrAnRRADNHJS2UKYPvOxHt23Ld
         4ANwD2CHOu/ChchW1Q3AwWVF0/N+nRWhOIvPKniMtKDBFzgCiKeJbjnavLKlx751xg0+
         cYA2h5qOGwgDmBTMMT1iU6gOc7G4zp6aFTADqEH0rzxQQMJSqokI2g6RFu01iR4pHA4v
         gp1Dfa3zgF+DgFFeKgZ0YmYiejwhQaccc4N1lM8pFP+4qAA9bm/WSPlIowsCH0SmwPzj
         NIGQ==
X-Gm-Message-State: AOJu0Yy3FfhEURfAeBePJ6UplKyB5GeHhxTepOFOJDei3E2ZpvodtB6e
	1ayqZI/KmmD4K84YQmlHHBoXzLrvdEMkUWHMycC3OvWGzdBrWliylBne
X-Gm-Gg: AR+sD11PJLqrF6py1K7Wogi36D1Va3/PsX8kANxCQGxvp0EGPRTdqHAP0c6lhAYnEfN
	Q0LvNlZaCpAoNp+3/ucy+uJ1GrsxH9W64ambIKmFuI+7Owwe/HrM6UcjP1m9tr6yLhLhaVC63NL
	HtQVjLbrkW6EyBKSesVID3fiCJDxwapuGiqhV64Vqj4B6BOh7SQrOTp3/lfe2JBQwHNp0388RUm
	8NvDR+Xq6sFGTTfrUFNb/+q01Wz6b7g8+nheyj87SzMwTrdWBrrPO/oomhWbW0EH50MfhePN0jB
	IODV5mqPVYwv+ykeYMjceFntM1FM+rfxiUOcj9gx+zbinCgElQ1ypj6ak77ays51SQEQPjY++FX
	csUk2azO4beTQ9CJPOG1hmixpLuFb+3zeltKGCyIXPHytNdTxsh4hacjvR9NTWw/V4hsN8vfGKs
	z0YVgCBSwWP4azBPF9ey4pDKKxHsUWrTHd/wOGj1Hn0hn5t662kYBUGHWUOVe6u9wiEwgLq1hHq
	w5y
X-Received: by 2002:a05:600c:1d1a:b0:495:779a:ed33 with SMTP id 5b1f17b1804b1-49987937fa8mr291351105e9.7.1786911353587;
        Sun, 16 Aug 2026 13:15:53 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999610ecf4sm65027975e9.7.2026.08.16.13.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 13:15:53 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via the AC queues
Date: Sun, 16 Aug 2026 22:15:52 +0200
Message-ID: <20260816201552.291195-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <9367d61a-bdc7-4d11-a424-428950d74f60@gmail.com>
References: <20260813131845.1330003-1-mehmet.fide@gmail.com> <4bb13bf2-8588-4235-a1ec-b82e6668c982@gmail.com> <9367d61a-bdc7-4d11-a424-428950d74f60@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Bitterblue,

You don't need real mDNS/SSDP - the driver keys the routing purely on the
destination address of the frame, so any multicast/broadcast the AP
transmits takes the same path. Real Windows/Apple clients get you there on
their own eventually (that is how we first hit it), but here is a
deterministic recipe.

Setup: RTL8822BU in AP mode (hostapd), DTIM 1, at least one station
associated so the BSS is live.

Generate the load from the AP host, egressing the wlan interface (use the
bridge/interface that carries the BSS, and your subnet's broadcast
address):

  # ~100 broadcast frames/s out of the AP
  ping -I wlan0 -b -i 0.01 192.168.42.255

Multicast works the same, e.g. "ping -I wlan0 -i 0.01 224.0.0.251", or a
UDP loop to the SSDP group 239.255.255.250:1900.

The firmware drains the HIGH queue at beacon pace - in my measurements
about a dozen frames/s at DTIM 1 - so ~100/s overruns it at once. The
shared TX page pool then bleeds down; I polled the free-page count
(register 0x240) and watched it fall from ~1800 to low double digits
within a minute. Once it bottoms out, new stations can no longer
associate (their auth/assoc responses queue behind the backlog) and
"error beacon valid" starts logging, because the reserved-page download
needs pages from the same exhausted pool. The AP keeps beaconing, so from
the air it looks like a silent receive stall; only a reboot recovers.

Two knobs confirm it is the queue and nothing else: raise DTIM (e.g. 3)
and the HIGH queue drains even slower, so the pool empties faster; drop
the ping rate below ~12/s and it never fills.

(This is on the v1 thread; the current revision is the v3 I sent as
"route bmc frames via the high queue only for DTIM delivery", which keeps
the after-DTIM path only for genuinely buffered multicast. The
reproduction above applies to both.)

Best regards,
Mehmet
