Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208F045519D
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791561932; cv=none; b=NGetl90iDDMTS4O3cu2P0bn42Az4GHpwWQ5xqpWRvtR9cjzfa5q3LCVcPeq67lLtiLLafsn/iI2MXm9LLd2EDY6RMSs2UcBJqgoFgm59gCF2Dwv1xqXSzCs+qqfe5sz5Pc+3VH+/6JP0FCbDAUQjDujKU24Q/GzP00yp5vYruEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791561932; c=relaxed/simple;
	bh=hkkDcj2yAbKWAvC8VsW9NNt3qNxSibNeGXbwS2Oen4s=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YF3u3xL5Yh67ciKDFPM1yYWesb7/tuxQAxNgpX7fuiTz1wi7gCTB+AALZR/+QZglc7RFj7J6gRb8L7to5ny2BKEPR+I0ywcSqsMc0AeZ3pyppRR6qiyuZ2UwCnU8tVU/RlDcvExu4qCXczg1mS5vPib/LRxhfSs5Ql2V6MxxsPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Qd2W/7hW; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Qd2W/7hW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=mPEpIuHqoRiTznxBPyi1zvE7X2BKKbfJp0nBL3SxjPM=;
	t=1791561931; x=1792771531; b=Qd2W/7hWBysIM3ZszYtzHtuAFqbZ64tqT0DaQnA7GSzXhK1
	klHspOW4+LJPXCl3W85zgj1y2BjVNT2f3wxjTj5V0GEqtCZCntLetIbLzm7sh2/Fcs3+/oATWn5mC
	9qOFZwsXqz4xSo8hj5VO42rIgsDu4c0E8QQjoy+ghxon/ITBgbAveyTzVB8xcFgicjXuR+VISJ3z0
	sjsbdF0MrdH2iGPjcICd9qpl8jF1WS9f12v+Ek4wGrZBM6m5XVoUQct40iQy6NHm4+XjmYzadKy7s
	g291+KmDQBpxu8Dla5oIWkSPtK5cEM2YdudohG1g49Tou9A4j5/AXaKP0RuPrDwQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFD68-0000000Ao12-0pN4
	for linux-wireless@vger.kernel.org;
	Fri, 09 Oct 2026 18:05:28 +0200
Message-ID: <20c60c055382b8c1cb7e147b7af25d5dd270d59c.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 03/12] wifi: mac80211: implement lockless beacon
 updates
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 09 Oct 2026 18:05:27 +0200
In-Reply-To: <20261004234504.dc783ba26923.Icfbcd157ac2bdeccfcc74a9f4c3997d3010ec0a9@changeid>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
	 <20261004234504.dc783ba26923.Icfbcd157ac2bdeccfcc74a9f4c3997d3010ec0a9@changeid>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Sun, 2026-10-04 at 23:40 +0200, Johannes Berg wrote:
> The regular beacon update can no longer reliably access
> the old beacon across the allocation (or we'd have to do
> all those atomically), so if userspace does both at the
> same time, we may send a corrupt beacon due to min() in
> the copy. This won't happen with hostapd even if it were
> to race, since it always sends both head and tail.

Heh. Aloka got really lucky, I went to rebase this now and it conflicts
pretty badly - not just patch wise but semantically - with the MBSSID
old beacon data fix.

This should never happen, but if a normal locked update is running while
an unlocked update replaces the beacon (including head, tail and mbssid
data), then the locked update cannot use the old beacon head, tail or
mbssid data at the same time, it might go away concurrently.

For the head/tail I basically said above that doesn't matter, we'll send
garbage if hostapd is causing garbage (just use whichever head/tail we
find, min() on the size); for the MBSSID data that doesn't really work,
the MBSSID fix said:

    Hostapd passes two Beacon templates to kernel for CSA and CCA -
    (1) beacon_csa/beacon_color_change used during the countdown.
    (2) beacon_after/beacon_next used after the countdown completes.
    Hostapd relies on the kernel to include the old MBSSID elements
    while sending beacon_csa/beacon_color_change templates to the
    driver.

So ... where does that leave us here.

I think the only good solution is to say this race will never happen
anyway, hostapd clearly won't do update-beacon and set-beacon at the
same time for the same interface. But we have to protect memory safety
in the kernel anyway.

So I think I'll change this to track "is a locked beacon update in
progress", and then an unlocked beacon update just returns -EAGAIN if it
finds (under the spinlock) that to be true. Presumably that'll never
happen, but if it does then it'll be correct. It also means that
unlocked beacon updates always have to come with their own MBSSID data.

johannes
