Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [178.154.239.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF314AA1E2;
	Fri,  4 Sep 2026 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788532107; cv=none; b=JRrBhmxXVqiVZsr2Gc8FaTS4r6GH/h+v5EvUSqrGT/12NKG+Im6HqrmHO1jQKgeezjIoz9MKUfLeUI2uxBKb5dN+HCegp3nmo/W6SZgOYdKwAqip8XbiIe+/R0rF6Y9qC4crE30MjZ4NMDKuub/VyvYbs+cJI9xkZ+Mkena/SbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788532107; c=relaxed/simple;
	bh=e/HmegveW9ysx/4ZtuFa4RwBMP859OyT8t8cNAJMhIQ=;
	h=From:To:Cc:Subject:MIME-Version:Date:Message-Id:Content-Type; b=Jf8koajZQIuajMw6ceK1WIkavij8bXWB2CSVW6mApyNfwG1FevIUVL/SsQml+IfXyW6M/nvEVjZ7bNKUt+2eE42uPYVIajR6yIqxf7Z2F5GkJDJRRGc0pBbMWkaBRflRn/QKZ3DZwnVHzJJvXpygBmwV/71c/unVLYeNB2Zr4JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=VaauQKUq; arc=none smtp.client-ip=178.154.239.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="VaauQKUq"
Received: from mail-nwsmtp-mxback-production-main-691.iva.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-691.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1589:0:640:596:0])
	by forward101a.mail.yandex.net (postfix) with ESMTPS id 94DCF80D17;
	Fri, 04 Sep 2026 17:28:15 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c0c:752d:0:640:91d2:0 [2a02:6b8:c0c:752d:0:640:91d2:0])
	by mail-nwsmtp-mxback-production-main-691.iva.yp-c.yandex.net (mxback) with HTTPS id vRKeX66vl0U0-DQkt58Xi;
	Fri, 04 Sep 2026 17:28:15 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1788532095; bh=r41Xe1mrwIPlvXiNA3j++3Eu8PLXhMgnYzML5OVQBWE=;
	h=Message-Id:Date:Subject:To:From:Cc;
	b=VaauQKUqGzQ1uzeeGxwIZrsB18rEkZZ5dw2BBYqpNRy1skJpkrub9fnN5xgRkoh7R
	 +U1KSZyCpuD3yEajTYVd0aHkTV4OLvSw++4naxtL2jC7wTWnLd0VNxiHF8tFlSF4Jm
	 Xo45Nn+JadGrsLHThQAAgIEmoo8KyuVFfTqeN1To=
Authentication-Results: mail-nwsmtp-mxback-production-main-691.iva.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-68.iva.yp-c.yandex.net (sendbernar) with HTTPS id 59ee03733a089c59512294a09661e3f4;
	Fri, 04 Sep 2026 17:28:14 +0300
From: Ilya K <me@0upti.me>
To: linux-mediatek@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 04 Sep 2026 17:28:14 +0300
Message-Id: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Hey folks,

Not really sure where to report this, but I've encountered some "interesting" issues on my bpi-r4 running kernel 7.2 and up.

The first issue is that after a while the firmware on the mt7996e sometimes seemingly just locks up. 
As it usually is with those things, there's not much debug info available, so all I get is

[58764.004954] mt7996e 0000:01:00.0: Message 00130022 (seq 12) timeout

This has happened before, but very rarely, and now it seems to happen consistently at least once a day or so, on
the exact same setup that is stable for weeks on end with 7.1. I have not attempted a bisect yet because
1) I kinda need my network to actually work reliably and 2) it happens so inconsistently that it's hard to
pin down a good commit.

The other issue is that the kernel then fully explodes trying to recover from this, in two different ways 
depending on whether WED is enabled or disabled: with WED on, it tries to double free a page somewhere on the 
teardown path, and with WED off it just wedges seemingly all of nl80211 and any process that happened to be talking to it.

I'm attaching the logs for both cases, hopefully this helps figure out what's going on, and happy to do more testing if
needed.

For posterity, my current kernel tree is basically vanilla + just enough changes to get bpi-r4 10G ports working on NixOS:
- 7.1 branch: https://github.com/K900/linux/tree/bpi-r4-71
- 7.2 branch: https://github.com/K900/linux/tree/bpi-r4-72

(there are exactly zero *80211/mt76/mt7996e changes).

Oh, I've also tried pulling the latest firmware from vendor OpenWRT feed and that did not help matters at all.

Any help in figuring this out would be greatly appreciated!

- Ilya

