Received: from enxio.de (enxio.de [91.210.227.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642B93CD8B5
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 08:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.210.227.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788598708; cv=none; b=h2wtG4u4WK4Fbc+W0/mM1c2io5jRE0SdMWvtJ3BVbQSfrAPXr5wz6AHIMK9sE4xFeHg6L3x7Ch6oMCmbazxzYL+h/754OD44Tet9tWDLc9ZujVx/oMQDlnxpEBpB0S+purdm+mOvfN44YcF5vnKSSaRAOrRV5b4lFpOXmqn82Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788598708; c=relaxed/simple;
	bh=7ac71Qf5smvMd74myWY2LV6//fBf8iMplALhVwHNtXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsd2z+73qunhH5TqO9wv/1ArNbDNS0JYMf+jasUvKxE0kllRl+D7MOVZO1Fxp6whNXvM/fMjVV0o71a9mNF8mPx89IucWofGO61C8zcNEhHqhsWePsCD0/Owby1rFkMEZVN9DYQ/KnUIz88Fcoagq/onmkB9lh7vIfNFhNchSiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=enxio.de; spf=pass smtp.mailfrom=enxio.de; arc=none smtp.client-ip=91.210.227.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=enxio.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enxio.de
Received: from [95.157.48.181] (helo=roja.toh.cx)
	by enxio.de with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <thomas.hilber@enxio.de>)
	id 1x2mE3-00000009MnK-1uz5;
	Sat, 05 Sep 2026 10:58:15 +0200
Received: from localhost ([127.0.0.1])
	by roja.toh.cx with esmtp (Exim 4.94.2)
	(envelope-from <thomas.hilber@enxio.de>)
	id 1x2mE2-00FPKC-S9; Sat, 05 Sep 2026 10:58:14 +0200
From: Thomas Hilber <thomas.hilber@enxio.de>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com,
	linux-mediatek@lists.infradead.org
Subject: Re: AP drops STA data frames for ~130-170ms after 4-way handshake
 completes (ath9k_htc, mt76; not brcmfmac)
Date: Sat, 05 Sep 2026 10:49:46 +0200
Message-ID: <20260905084946.3643161@enxio.de>
In-Reply-To: <178842137902.19372.6968639520035628037@justthetip.ca>
References: <20260827074442.826644@enxio.de>
	<20260829232532.29622-1-lucid_duck@justthetip.ca>
	<20260830104236.521389@enxio.de>
	<20260830190028.20209-1-lucid_duck@justthetip.ca>
	<20260831054740.1543875@enxio.de>
	<178842137902.19372.6968639520035628037@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 2026-09-03 at 00:42 -0700, Devin Wittmayer wrote:
> So the measurement worth making is your key install.

Measured. It is not the key path.

Both tracepoints, paired by pid, taken during the same 150s window in which
the stall was being measured on the station side, so these are the same
associations and not a separate run:

                          station side              ath9k_htc set_key
                                                 (drv_set_key -> return)
  nohwcrypt=0   5.01 attempts, 134.4 ms      median 0.418 ms, max 0.663 ms
                n=183 cycles, 98% >1 attempt      n=394, none over 50 ms

  nohwcrypt=1   1.01 attempts,   3.8 ms      median 0.001 ms
                                                  (driver barely involved)

394 key installs, not one above 0.7 ms, while every association in the same
window was losing 134 ms. That is about 320x short of accounting for it, so
by your test the two-mechanisms reading holds.

One caveat I cannot close from here. ath9k_htc is a USB part and set_key
ends in a WMI write, so "drv_set_key returned" is only the driver call
returning. If that write were queued rather than acknowledged, the number
above would be measuring the queueing and not the install. Against that:
0.418 ms is about what a USB control round trip costs, and it is far too
slow to be a memory write, which is what it would look like if nothing went
out to the chip. So I think the key really is in the part when set_key
returns - but I have not read the WMI path to confirm it is synchronous,
and if someone who knows ath9k_htc says otherwise, this measurement is
worth nothing.

You are right about my 22.2 ms and I should not have offered it. Timing
first-frame delivery at the netdev can only ever time the frames that
survived, so it cannot distinguish deaf from slow. It was not evidence,
and I have dropped it.

Your induced window is a much better instrument than anything either of us
had before, and it is worth saying what it does and does not settle. It
shows that a slow key install produces this signature. It does not show
that a slow key install is what produces it on hardware where the install
is fast - and on ath9k_htc it now looks like it isn't. Both can be true.

Thanks also for the retraction on the reorder window; that saved me from
building on it. For what it is worth, my TID 7 sessions still show your
exact mismatch, declared SSN never arriving in about 97% of them - but at
the same rate in the arm with no stall, so it is a real pattern here that
simply does not track the symptom either.

Where that leaves ath9k_htc: association completes, the 4-way handshake
completes, hostapd authorizes the port, the key reaches the chip in under a
millisecond, the block-ack window opens on a sequence the station does send
- and the station's first several frames still do not come back. I am out
of hypotheses that I can test from outside the driver. If anyone on the
ath9k side wants a specific tracepoint or a debug patch exercised, I have a
bench that reproduces this on demand, roughly 250 associations per two
minutes, and I will run whatever you like.

Thomas
