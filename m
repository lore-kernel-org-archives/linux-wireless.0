Received: from mail.w13.tutanota.de (mail.w13.tutanota.de [185.205.69.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E153B1035
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 18:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.205.69.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783361719; cv=none; b=NdiKZ69P4j90coiRUT3Tq2oqclK9zwFQRjun3kNEI5tw6h0I8LzMFfeC5fFn4mUZaY8zKftq1YYDZJzBkU6tgYTQeQAAdlhRFGXHNCl0oRR7bY/v/iNw+CcTLgwEfj5VPc9rYELVMqZJ6nBIQI92kreNngzI3HssvYO8uGu98Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783361719; c=relaxed/simple;
	bh=5O5qhfX6ulkq+VFdKia/M3YAA6lGVvBfplcOkRw7VfI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=ShLomx/FTErnNIQ92IlyrG8ldqQqSrpqCl2PCrvgCMhyrCtDgWZnAtXbSzpWOdJCx8Dq8VLvq84qenwMp7yTBBq3iAJD73yFJbb6S9ilfdhrrMvqzEfBs7MZb8ufUxpCTItVmhp4DCvlOO8B36bG3YcBAqBGpscIdZCZbVvNCPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutamail.com; spf=pass smtp.mailfrom=tutamail.com; dkim=pass (2048-bit key) header.d=tutamail.com header.i=@tutamail.com header.b=sUGNLaef; arc=none smtp.client-ip=185.205.69.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutamail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutamail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutamail.com header.i=@tutamail.com header.b="sUGNLaef"
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w13.tutanota.de (Postfix) with ESMTP id 5E36A159D1ABF
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 20:15:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783361710;
	s=s1; d=tutamail.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
	bh=5O5qhfX6ulkq+VFdKia/M3YAA6lGVvBfplcOkRw7VfI=;
	b=sUGNLaefrvZ5bjtEfXiCrICy5Ot/G+NWUm8bD7M2yDkFxhxpJwD3rCFEoU0D2g76
	w6GJZFIvRrXeDfs/u70VyePVb+0Nh+X5531gJ30EbXu2UzhoyNibO+5eOiIqM/eaAe2
	/+XKBhbWJsCEVgBqkYmek/hZbzyLkK9gG4ESNptrtl99PYDeA6HpcLc2whISmfFGjIt
	PwrtBf1Bz+HltxaOCsmV8/e0f0RreV2LZGwwervPHiekZj9HSjvXNfo3qrDxYLxqYwA
	0of6yy0/SxtEGYIFONK4Iuo15uSmNCyPyQXe86g0IHhVDM7VJwrblEUSmChkJ0zh2RU
	Ac5klU2VzQ==
Date: Mon, 6 Jul 2026 20:15:10 +0200 (CEST)
From: cybersnow_2001@tutamail.com
To: John Scott <jscott@posteo.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Message-ID: <OwscydZ--F-9@tutamail.com>
In-Reply-To: <c2163c6ee67e982fd95d1f965ecf0b853f687214.camel@posteo.net>
References: <OwQQjLm--J-9@tutamail.com> <c2163c6ee67e982fd95d1f965ecf0b853f687214.camel@posteo.net>
Subject: Re: Atheros AR9280 / AR7010 Initial low scaning signal range
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: 0148cefbf77245a42b8d92790169c2e5f3889e2ac922109814e9377b88997be23fd058959082c4e525ef1b19740c34b7ef4478cd506e389835ad86d84f5ca78a4f:TurnOnPrivacy!:tutamail

Thanks for looking at it. Here is what I could find on the Web about the same issue. Someone said Kernel 6.4 and earlier worked. You might try with Debian Live DVD Buster, Bullseye and others distro if you want. I tried to use an older firmware of Atheros v1.3 instead of 1.4, same problem. I wonder if there are older firmware... But I'm not sure if this is related to the firmware. It might be more about the kernel 80211 modules... Or it might be an electronic issue coming from the chip itself. I need to do a cold/freeze and very hot test to see if it solve the issue...
https://discussion.fedoraproject.org/t/need-help-with-weak-wifi-signal-on-fedora-with-qualcomm-atheros-card/87854
https://www.spinics.net/lists/linux-wireless/msg90423.html
https://forum.mikrotik.com/t/ar9280-low-speed/62030
https://forums.freebsd.org/threads/atheros-ar9280-wifi-not-working.68357/
https://forum.opnsense.org/index.php?topic=28266.0
https://forum.mikrotik.com/t/compex-wle200nx-atheros-ar9280/166217/3
https://forum.netgate.com/topic/83364/atheros-ar9280-testing-settings-craziness-success-ymmv/2
https://forums.tomshardware.com/threads/qualcomm-atheros-ar9287-terrible-range.2687938/
https://forum.netgate.com/topic/53616/atheros-ar9280-ath0-stuck-beacon-resetting-bmiss-count-4-hangs-later/2
https://forums.linuxmint.com/viewtopic.php?t=299646



Jul 4, 2026, 17:25 by jscott@posteo.net:

> On Wed, 2026-07-01 at 04:08 +0200, cybersnow_2001@tutamail.com wrote:
>
>> I've read in another forum that people experienced the same issue after a kernel update, maybe after 6.8. What do you think?
>>
>
> I think I can partially reproduce the problem. I have a Sony UWA-BR100 on Debian Trixie (kernel 6.12.94) and a wireless scan only shows very few access points, never more than -65 dBm or so. The access point for my home, being the closest one to me, actually has the *worst* signal strength value reported as -80 dBm consistently. A scan for access points does show 5GHz ones, but it chose to connect to my AP on 2.4GHz (which may or may not be legitimate; iwd normally joins the 5GHz ones when I'm using dual-band NICs). I did not observe any circumstance in which the reported signal became better, though.
>
> With a TP-Link TL-WN822N v2 (still AR7010, but the 2.4GHz-only AR9287 instead of dual-band AR9280), everything is excellent, so indeed it seems only the AR9280 devices are affected.
> Could you share that forum link? I'm not sure I'll get around to it but my next steps would be to bisect the kernel using a virtual machine and USB pass-through. This is strange indeed...
>

