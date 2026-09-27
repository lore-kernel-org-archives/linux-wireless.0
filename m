Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E5819F137
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 06:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790489301; cv=none; b=l124jT6ojnshE1dREq4DuPC+tpyZ9A9vMheoOLYNwkRcMu8rfeJH/OauUnO/gbPXUE6a+t99iCKo82+YQfvh2bux+U8nF40tRU3RR9jIF3MRstVhscMFSF2oGppNJiSIwkDcB6BVp5ke2L2P4D67WRuj9wZaX5+BW/ntrBMFVkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790489301; c=relaxed/simple;
	bh=6J+MJhLSDkheoGdEp9RwygPvROxLQLV3t+9bH/mYs5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHcXsGpF01LOV5tv59BF6QrLn4G4qOaM+ioGw6fCvq0ho6/E/4JWuB2QIhj+B+jcVfxmn4bwziAv4Ura+2+y7jtX0NXmIeLtxeK1TbVevU+NA/Ld0N+wBQ/V21mbFtaKHJIG+L22iAIwfrccAgiWcq3lNV4UCU3gDc/V8xmDoKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=Rf98YM1V; arc=none smtp.client-ip=91.218.175.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="Rf98YM1V"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6J+MJhLSDkheoGdEp9RwygPvROxLQLV3t+9bH/mYs5Q=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790489296; v=1; x=1791094096;
 b=Rf98YM1VxEzQvEqovVeau/XRtCXVWC7wXRYI9aeAye4GLXxXjibwB8SepwNJ4RSxM1j3E5GX
 YD97z7BX9gTLrOb6hZ7D9u1yGJ4JoEaBNY60Co75UuHvDpmxTQQgmJUGXTZtnmVIpJt4DN9FmyU
 sVmDfq6tyEWHqE5okPSl6WTF9WmzneoC/jqyll8hAL8UwL+awymZH9KQQEsW1zR6xF677USMgYD
 982TrtXPgZag7/xgPYTDD/coHPRdMMpFXlVM3vjDd7un0eFVLGyZbngXUNDzBgV5rrj+70+rT9R
 wVfQQ4LZOuqdb6+NWYL5yEOzNsB2wB2uRxD1pjlUlUCmg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 96aae62fded4b97b;
	Sun, 27 Sep 2026 06:08:16 +0000
X-Mizu-Trace-ID: 96aae62fded4b97b
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Pablo Diaz <pablo.diazv@pucp.edu.pe>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: Re: [BUG] mt7921e/MT7902: firmware programs near-zero Tx power for all 20/40 MHz rates -> assoc fails except at close range
Date: Sat, 26 Sep 2026 23:08:13 -0700
Message-ID: <20260927060813.64257-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CA+Hv-Vr2w1qqGgPtZVJo8F=Lu+VtL16QokTAhaXaTCSfObtABw@mail.gmail.com>
References: <CA+Hv-VqAQ38g9hGf+-nBcpRNZrcowicSejRQKgBswPOR-o+adQ@mail.gmail.com> <CA+Hv-VrxZV6yg5eBBRsUrNFOzCx9upS735RDO-pfPatUEdWz4w@mail.gmail.com> <20260823180814.4081175-1-lucid_duck@justthetip.ca> <CA+Hv-VqrxKWETcegx09-=v7udVO0Rk1CY9nPjw8sDK3mzgw-JQ@mail.gmail.com> <20260905063728.31929-1-lucid_duck@justthetip.ca> <CA+Hv-Vr2w1qqGgPtZVJo8F=Lu+VtL16QokTAhaXaTCSfObtABw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pablo,

The 0xff fix went in. Junjie Cao sent it, Felix applied it on 16
September as 0b94e87ad404 on his mt76 fixes branch. Not in mainline yet.

> If the next revision preserves the tested pwr=0xff behavior, please feel
> free to add:
>
>   Tested-by: Pablo Diaz <pablo.diazv@pucp.edu.pe>

It preserves it, and your tag is not on it. The patch went out on its
own thread and you were not copied. I should have caught that, since I
asked you for the test, apologies.

Your second question is still open in the code. An isolated offset=0xff
is not treated as absent, the offset is added and the sum clamped at 127
so it cannot wrap. Your row returns before that.

Devin
