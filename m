Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792577655;
	b=0n5+SWnKGXt6xojRz4+VB5N0M9BMPDpk0jVKuzCeTqVsgYs7Mkk8fUbdkziu0geFyrTh
	 w5hbu4X5Mg7ODD8twfJbdRmh0zjo64Eqs2Ibga7zfjY9KjCrZ2HJlm+oYvg5BWUQ6gsrH
	 PFOPLBcU5QIQrL6v6OBdWjnHyhR2yMfFK4WXllPNyz80oYm9B1DECGtIvsMFK4gsJHCdJ
	 mv0/6oplvXe/i7mcx3LNMsb2JV/yo9BDBiCxRny1cId/SYR8gyaLuL8GUMdeGEoraHLJw
	 Gd3SYOS5MqybZ8OO7m/P/aGbATUfWOFDKs6Pbg34uAFOqeVNI3HeYp0+IzI/RoSGVaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792577655;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FbF3paBbiX8XkFyM35gCpVzdlhaapsOpxybEvJf8GWc=;
	b=eLeiFsNQ9S4cNqj5f1aOIlEwnj/0BqgPlRDBImZCI39wbbiLTer8gMeji6UFiTXnp2aU
	 kyWSVgCMucYTGF7QkwpzgDtfofXXvh/yEgPMbYotuh1p+2F1WVMXrX5jgSWMpBMdMb6+F
	 BVNbmtCzJFx0J2L9flDQHWnBLpGL4h6y24wgSbgTdEo4tINuviGNhmjTdPuLLl8WZBOQn
	 yqaNrnYylVZrUs5Ivu25m5181hs+r0OsukvDu6Dj/I5vRj7e6ijPrq1XtbAtM/w5cfzhe
	 qUng8WsiGnoShkfg/Pap50mezSHtH1iftAERp2d4QhLDBQfmXC23WB0/scLb32Cl+Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aDNxCbxs;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE98606A322
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:14:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAE98606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aDNxCbxs
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48bbb06e746so277937f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 03:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792577653; x=1793182453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FbF3paBbiX8XkFyM35gCpVzdlhaapsOpxybEvJf8GWc=;
        b=aDNxCbxsF95zFiMewnev/K2wny+BQRzVHIbTcBuDM2HEZXVbqljneyTqsFqv2NhlI1
         uckFo6StYC8yYzlP/0KRMHtvTxqbhfyLGJPsfFPv50ugnopyY0tVBUHc1G4hCIHoOQJz
         DzqPGC8zaBGs3dvIqsQV2ONVvmiChBWm9lMcYGjwjHaLNwJ3ULi/pn0p9iaL92czfDyx
         ce3qGX77LSA2lhmZGWZgbsqaNzChSDmUu288/brmzUcQx/qrdzSGKU3GqJqwy/8wVzoj
         WBWVn/qADVcQJwxObKdKelppiMLMgFfsOji3IxCM2qg3WNRgbNPjWlfPMG055ne50dbF
         VSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792577653; x=1793182453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FbF3paBbiX8XkFyM35gCpVzdlhaapsOpxybEvJf8GWc=;
        b=005smAfuV39d5Lo1b/wPzbE42qdf5+yN5afSHJcAI6IzrWEQVkVe5mAQJETJywP1wx
         AZz/i670ZCPeWRs1UTjoO012DpW4luCWJLo2aY4K4y7Ce8ke4t5HPCdWftFOB547Rj4u
         Xwzyaa00MmBhyKFrEV96G4hEbkul7vzzvI2DaqPLogUA/l8gfeoGu8HaYT8sncLPQqtw
         iB7ov5XntwwiYIRzMb7xY/Ci8h6oDhzvhxU6FjgiYva30f/t6y9Jfz2lRmvYlRo1OAQZ
         2hiNnpt5RoN9ZprLgXhInPgf/YowA2Oz/ZxRxne9eBCp/NlLkPrd8U3ss6UNmdXgtZNY
         TznQ==
X-Gm-Message-State: AFq9FYLRWAbFGDsSCSLDpmdnP+iS8SSH14a03KB8jilSEV50wpJ8AWCX
	TmWQS6GHO4nNvzuPu6o7VJvs7PPYv4tA8a3P4I8K50IUvMiDq/sJFg1t
X-Gm-Gg: AYBFou299OonIy3LmpCxipd4msTU5vsqQahwU6XoDnuIm62dd5aBQeCjqQjYRa8mvWf
	lm4bzVIRrbBkfNBmZmrHnEFMLu0Q5yB44annSv3/uGEHIZsS6BlSPnAADzrHNqxMnVdBNyhHZtL
	MHckcDKB6yWSe5Sp5TxUm1X++1RsxpWIaT/igel7K5BRNlyEUpYru1csGLdzig0P+G1BL5/zSta
	SQ2fVJDRWojnxI9o4pRG4496dXp8ehCyoe+4hSmR4DwjMjCztXVtg6Dc/AXDeCo9ktr7BGZUyHb
	y/ul0Q5YkJvVlqeSBrztJAiJPLtpiLsoTmonZ1v/fc0o1nkFke+KODBIVhcOwLhiic/5bSpiXJG
	ae/9NufTHZB7vB1/7i55RxJDRxG+bpyQyE+gGh7jKCnfmlhxWrKvAFU840PDL4Qx+3eUAGxsWCN
	JlU4Z6UAyXZ98tHt87BMy6V5h6th1SZq+r2agD5CVmyVbE6nifPnW2AoGprzdsELG3Nhe9mW2dM
	PxBXudOYYGOu9Yx4K+FMGRXVMa0mHnd7slvpIBbcLqmxFIhC2VjfHBkTpkH5kxLjkzMCH65LKRL
	wVP8pSZPb3jUY4PfxP9NwE0BzMJ7uzcKZ+1eZlDvPvVWCQ6b+k8pthsljhGhvidClPj7a93at0U
	9ZA==
X-Received: by 2002:a5d:584e:0:b0:48e:f07:160e with SMTP id ffacd0b85a97d-48e264f32edmr2988725f8f.38.1792577652829;
        Wed, 21 Oct 2026 03:14:12 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:e71c:400:f186:eea4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2584c3b0sm5000928f8f.57.2026.10.21.03.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 03:14:12 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when the rings are reset
Date: Wed, 21 Oct 2026 13:13:56 +0300
Message-ID: <20261021101356.1976617-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <3c588aeae8f74a8caa39aa2852bce437@realtek.com>
References: <3c588aeae8f74a8caa39aa2852bce437@realtek.com>
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

> I discussed internally, and we suggest to add ieee80211_wake_queues()
> and clear queue_stopped flags in rtw_pci_start().

Done, sent as v4, with restart_hw named in the subject as you asked.

One difference: the flags are reset unconditionally, the wake is not.
mac80211 keeps one non-refcounted DRIVER slot per queue, and
rtw_hw_scan_start() takes it shortly before it reaches rtw_pci_start()
from idle, so an unconditional wake would release the scan's stop too.
This does not resolve stop ownership when a ring stop and a scan stop
overlap; it only skips the wake when no ring was recorded as stopped.

What is measured and what is not: the controlled A/B is on v3. Two
builds differing by nothing but the patch, the ring filling on its own
under load with no TXPAUSE write, the restart the only thing I
triggered. Unpatched left the DRIVER stop dangling and the link dead;
patched woke the queue and traffic returned. v4 has not been through
that test - it sits earlier on the same start path, so I expect it to
cover the same case, but that is reasoning, not a measurement.

> Another test is to remove/insert driver ko.

Not done - my script stops at iface down/up, so it has never run on a
live wedge. I am adding it, by hand rather than unattended.

> (I suppose you did these tests without changing any behavior as was).

Mostly. Most captures are on the stock distribution driver. Two builds
differ: one carries a five-line debug.c change of mine, one is the
c95323ea9dfb revert you asked me to try.

> I need your help to summarize the dumps. I don't have much time to
> analyze them. Sorry.

A watchdog takes a capture when the gateway stops answering, reads the
TX ring indices and the mac80211 stop masks a few times seconds apart,
then walks a short recovery ladder.

They fall into two main groups: stalled TX rings, and a dead link
despite continuing ring progress. In the first the hardware read index
stops advancing while the ring fills behind it, and in a couple it had
filled and the queue was stopped - the state v4 clears. In this group
recovery was observed only after reconnect or interface down/up. The
second group is the larger one and I have nothing for it; that is what
the monitor capture would be for. The patch does not claim to address
every link loss.

What the captures do not give me is a case where the wake would have
recovered the link. The three with the BE stop bit I listed on 10
October are still the only ones in that state, and none is a clean
test: one had no ladder run against it, one is power-save-on, and in
the third the read index was still advancing.

Checks so far, in case they save you time. REG_TXPAUSE reads 0x00
except in the power-save-on captures. disable_aspm made no difference,
and it does not disable host ASPM anyway. The correctable PCIe receiver
errors appear on a healthy link too. The wedge also occurs with station
power save off, so enabling it is not required to reproduce the failure.

One observation I cannot place: HISR0 reads the same value in every
capture that samples it, with none of those bits covered by
irq_mask[0]. I have not established any connection to the link loss.

Two things in the dumps would mislead you. The fw_crash rung measured
nothing, as I flagged - those lines are my script's labels, not driver
output. And the "SINIF:" line is computed from the first sample only.

I can send you the raw captures if they would help.
