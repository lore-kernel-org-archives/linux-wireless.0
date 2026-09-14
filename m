Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49776411FA1
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 21:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789421266; cv=none; b=Gc26kxjRSGrTV4S43Fmw/p2N21C1ZQE3BGOyMPCyYQdZ+4bqAgLmlPaPRvuVqAZe2hrhLKsc2KL3HhGuGiE4ysBnO1DtEAvKzH66ah+BZtlsYuSU3oqj0e5wTiZMJ5fpC/+CJB5v3tMzW/4m+psWekEYVlJo0TXliqEsr0sdgog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789421266; c=relaxed/simple;
	bh=Kq9f06NVVGDL9EUefa+l6ziWNZYmyLU8s0uuUdKy+wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tbIzF5guNtILkLYOsxMRYeYFnTbigWOtf8P38jM/Qvv33pR6VKw1Hkvi+Ptr7wtguyoezDZdAFeSch3lA06bFG2R4MEHCGia/22jdgV4XjIi+GRi4Gh7F+KosogD4MUqB8IEp00ryCoC/Svb5rm301mQE78GBflvSkogwfHeSoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=ckrwptyJ; arc=none smtp.client-ip=91.218.175.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="ckrwptyJ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Kq9f06NVVGDL9EUefa+l6ziWNZYmyLU8s0uuUdKy+wI=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789421258; v=1; x=1790026058;
 b=ckrwptyJ2IrabQG0QfyXoeT/eB/DEcmQFUEF3S/X+hutG1JjnSkTpFoN3vw2qPwUDO50/l5v
 j/hNYd5dZKDb24xTdw/E4Qr5xD4wsm+qgVmnzsddQDzeF7hUuzUonl+lQ6XmnZH/eHX7D7WcOlE
 7ECnSKgCAWzjTvtiHg+5irWiv1dt2D2HUGAzhngJe3wGuEQntMk93p/vPIX9swe/krpxlLCdScT
 dLyoCry0PUkTWA/t+XwxdS3aKogP+sCMiDjOflBFwDo9nuguCk2fHAt7iteKUjpZlayeZ2MmIYu
 AB94sV9UfpYf+9FsHNK2VEY/aKRGpDn8tTdeQWOrgbF1Q==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1fda61994051b6a7;
	Mon, 14 Sep 2026 21:27:28 +0000
X-Mizu-Trace-ID: 1fda61994051b6a7
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: moosager <moosager90@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: mt7921e: failure to reset causes network drop
Date: Mon, 14 Sep 2026 14:27:26 -0700
Message-ID: <20260914212726.15728-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aqVwl7fe5zHVYXT9@fedora.fritz.box>
References: <anG46qbvCqCHGF-f@fedora.fritz.box> <20260910055018.29328-1-lucid_duck@justthetip.ca> <aqVwl7fe5zHVYXT9@fedora.fritz.box>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

moosager,

Thanks for confirming the ruling-out list, and the Bluetooth detail is
worth having on the thread.

On which tree. Patchwork says accepted, which means a maintainer took it
and says nothing about mainline. That is why you could not find it.

	openwrt/mt76   8e856ad93d3a   mt7921, applied 27 August
	               4f2aa9910e0c   mt7925, applied 27 August
	mainline       neither, checked today

Mainline still ignores the return in both of those resets, and I would
not put a date on when that changes.

Your Tested-by went on the mt7921 one.

Devin

On Sat, 12 Sep 2026, moosager wrote:

> Hi Devin,
>
> > On debugging further, I had the same ownership handshake fail on a mini PC
> > here. What that ruled out, so you can skip them: in-tree against out-of-tree
> > builds, a PCI bus reset, remove and rescan, and a cold boot. The Bluetooth
> > half of the same chip kept working throughout, so the silicon was alive and
> > only the WiFi side was stuck.
>
> I can confirm these are the things I've had to rule out with my testing as well.
> I can also attest to the fact that the Bluetooth half of the chip works
> regardless of the Wi-Fi's state (I should've mentioned that earlier): I've used
> my laptop for a while with mt7921e unloaded, all the while Bluetooth was working
> the whole time.
>
> > There is a patch for it that the maintainer has taken
>
> Good, though I don't see which tree it has been merged in, I'm sure I'll see it
> soon in a future release.
>
> > It sits downstream of your bad read though, so it will not stop the
> > register going wrong in the first place.
>
> True, I will stress that the root cause has not been found yet and this chip is
> still unusable for me (and others).
>
> Sorry for the late reply, I'll test the output of lspci as well when I get the
> chance to debug this further.
