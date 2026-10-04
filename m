Received: from mail-qk1-f225.google.com (mail-qk1-f225.google.com [209.85.222.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC363414421
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 12:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791116931; cv=none; b=N3U3R3vV+OpJpTSWe2489edkqvPwEI+sQOMjHhE4BJa2SoZgDERas/0a29e6TYd+vxHWtfelZKvceQhPo60OvG7sTaX8jVPP4pwDAdCQaZ3NqG0DdL3jB+hFtzIL4MVfGDimkdn8O7DFOTC1yJy0mGxQpgABP+aPCCBQJd8zDE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791116931; c=relaxed/simple;
	bh=xqMc2nFRzl5bCD+ATJaS5tK92XhGJq67FhleE6gkzk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMomUZ0AIh3kbx/w6zve8wmQEQ4sCTUWHS0USY29PndVPYHarug8whUwJJFOSOZk2z0oXkBpExtMFvKwTffTHPR0HfU4lNrxHjLFFr2Myo1HLumatv514MPDwQ9UdkdPvlgSjYMDDsfnw7+By4pahXCo0bdvasc/6dXEWksK+G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cUnwRVsX; arc=none smtp.client-ip=209.85.222.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cUnwRVsX"
Received: by mail-qk1-f225.google.com with SMTP id af79cd13be357-93e50170ba7so73377685a.3
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791116929; x=1791721729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+8JCCrShX/OiK0rjMqICF2+soAKosuntY3aTL2G77+Q=;
        b=Ax9+dXEWj9Glflzj+wYcTa2Mhpgos1f8CaJOuZf5aKCmyp8mqJVBYo0BQJRq0Mmhcr
         0DA/3AtQxbB9hStSEAmmW6LcKInPcW2Ub+fGzrz5xhZu2QwWlEBo1WmXu9OubBr0Cm4Z
         rzMrw0VDrSxxWGtzfSHxaZPPcJ7HoEWMSWD0IMbDkMQXZBYbUMbtGz5/Q4wQIIWZshKK
         S+o+LW0+nJU/jtOQzK2eoRgL1i4JwnHzkkk5RN2UbuC3B5fKbcxi7xWaa+rclF9STFnF
         8fgh/wr57zHXF4dNrhgadEjyiv8KQHj28YDQ2TlyUJqmV/yCm3zNjAaa8vGURgYUosvP
         hwTg==
X-Forwarded-Encrypted: i=1; AKwUvBwpbtQwyvn8lMjcaY+Wl2fTsTcnKWwyzUKlk8ldN1ezTGAjtnsBmwYCSf2ABlIzi+XlQN62E5yXYdGcDtp+Jg==@vger.kernel.org
X-Gm-Message-State: AFuF++kYvuoHynW6WfhzBSBmxHSCCRmcHp5WdSJpIRSkojYPdWdHkyAF
	4TJMEY4OLFzfbXE+ZW0lBL8OJvgE2U/ukaNNjFdeqkTWWmMiAZamYQPOUSqPG5SLAlNk2q4XbH4
	p9ooMpHkUca9Kd1csQ1pk0EWWy3KKP1YlyK8F41g/QWXto1FPEewlU40B3WSexzOT9+Up2zej22
	bnqNZkPPaxnAt5HBZg1bc8vHIB3SZnYopGiaxuhinsCr+lKTbQBXslnYywDlYtIfHIGSPiMe7Gc
	6JvQ2oIrQnwHDLgqFwtC3aIAK0J
X-Gm-Gg: AYBFou1CsqSEXnlnEVTvPTKiHYIKPabqRkQiWcLJ6bT0KHPcoXFrNVvCVhlHCIbbUt3
	vf5/C0E38uHgvmEazm9jYe9XUA+sCkF5ex1jeARFMFMRZw3gA6utJnXmWLxZIcbRZ98Q01Bc2L/
	d5VygIScrZoGF64QrgnBnXNyOoJlzivjmHS3Z6DleENkMglYtO8uVjE+8U7HVdmUeOFPRTVZgnq
	mNl2+8JZnc+sGdycSiItfDlnndQbtSKZlU5nUeDSciOHyGuqVtI115x88B1/aoNl+pKlCToadzM
	ja3M1RDPoC4Ciq874bU2/t9kerqTw1hpIfXa0YoI7D6S3JExO7q5PVgO5/UtWGwhJVTY6LhuWkj
	HG+VOriqnTDEiGkQQ87G36hyI2nk82XPZlyv8un/UESYHyJqzotcvy9Saxax9MRZ323fIns1mDH
	mmQDasdxCiK5jK1FuYS/wiN0DCmjzfnXB59/bzC4FoUg==
X-Received: by 2002:a05:620a:318c:b0:939:6df9:6547 with SMTP id af79cd13be357-93e51097154mr802024585a.51.1791116928631;
        Sun, 04 Oct 2026 05:28:48 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93cca25f4e6sm298601985a.5.2026.10.04.05.28.48
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 05:28:48 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-14373747468so999236c88.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791116927; x=1791721727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+8JCCrShX/OiK0rjMqICF2+soAKosuntY3aTL2G77+Q=;
        b=cUnwRVsXsPG/PIB4q2PWtnoj1d69lRu5EODrr5HRM0LiCI+LTDSkS4g8mPkwFfr6z6
         xe2OAMWufzAZSESngP5t0ba2a2DU2NNGGMxAlnnPMWrVRqcj9Ml5RqvTIfXoQNqn8Pkm
         uXNNTcM3ml0SkKGUen0J6oGTpEbk+XnUxNBZY=
X-Forwarded-Encrypted: i=1; AKwUvByrYyYzRjGX2hMl+1aFc4p9uEFQFt8gctXJVcidojuKtUBjahaG3wUH4ix9nGGRV1v+1HrE+ZMaIXUTiie8XA==@vger.kernel.org
X-Received: by 2002:a05:7022:5f01:b0:153:e0b1:5b5 with SMTP id a92af1059eb24-153e0b107ffmr3054130c88.31.1791116926994;
        Sun, 04 Oct 2026 05:28:46 -0700 (PDT)
X-Received: by 2002:a05:7022:5f01:b0:153:e0b1:5b5 with SMTP id a92af1059eb24-153e0b107ffmr3054112c88.31.1791116926354;
        Sun, 04 Oct 2026 05:28:46 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-151fc39a7d1sm12234015c88.3.2026.10.04.05.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 05:28:45 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Benjamin Drung <benjamin.drung@canonical.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH 1/2] wifi: brcmfmac: Add per-board clm_blob firmware binaries
Date: Sun,  4 Oct 2026 05:28:40 -0700
Message-ID: <20261004122841.1391116-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260923203739.2560527-2-benjamin.drung@canonical.com>
References: <20260923203739.2560527-1-benjamin.drung@canonical.com> <20260923203739.2560527-2-benjamin.drung@canonical.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 9/23/2026 10:37 PM, Benjamin Drung wrote:
> On Ubuntu 26.10 these firmware file are missing inside the initrd when
> including the brcmfmac kernel module:
> 
> ```
> /usr/lib/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43430b0-sdio.raspberrypi,model-zero-2-w.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43436-sdio.raspberrypi,model-zero-2-w.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-a-plus.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-compute-module.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-compute-module.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,500.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43456-sdio.raspberrypi,4-compute-module.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43456-sdio.raspberrypi,400.clm_blob.zst
> ```
> 
> Commit 885f256f61f9 ("brcmfmac: Add clm_blob firmware files to modinfo")
> added clm_blob firmware binaries, but did not add them for per-board
> firmware binaries. So add a similar glob for the per-board firmware
> binaries.
> 
> Bug-Ubuntu: https://launchpad.net/bugs/2168109

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>
> Reviewed-by: Matthias Brugger <mbrugger@suse.com>
