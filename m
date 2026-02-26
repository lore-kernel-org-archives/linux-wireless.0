Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C604D392813
	for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2026 08:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772094991; cv=none; b=kxyrVMfVYc8rrwf+DijA+Jl8rvNsS8JICBRYa/pdiA69CtKgoKUQZlVMe27NQ788NbocenYdU7aTgjR+LfV0xhqIdnX802VyHs2uPKfklHZCsXWwmWQ/xeyb22d/6oL6PrDWClFmDBwZu51AppUVhC85NwXNfXA3fyVcFzY04zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772094991; c=relaxed/simple;
	bh=kW7w2x971Lcqzu1KP1lM7Q1thTB1+Bko5DnsV1tMJDY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T1dUt07zIKP3w5aUlRO0Ift681mSxljw/JSF1th1a4KaUrAUxepEdbCpS2ElPdjGQkGcuCuXn5VIo7KiUkc1crqHTy87eMgvsMgnRGQAHhdEarIw2R1/ZRlG8Ie0yVbfrh5EF6FsWBxWIHCi1cqseBpylJrxN2jzxzAB3g6kOAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=r1mU2Ofq; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="r1mU2Ofq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=kW7w2x971Lcqzu1KP1lM7Q1thTB1+Bko5DnsV1tMJDY=;
	t=1772094989; x=1773304589; b=r1mU2OfqNctRIAsd/95+LhdoZE4E1PeS1KcKGXR+Mp4NrAk
	PO8ab/PZif41tZ9Jqvh5/dL61ZoLk2nehcsivFcpFIlfpVT5uKSSTm5S3Uyl4WHY86/N+HAQ3htkw
	kP/encFUjV2jbAE9uoLMnVZqMoGqITZ5Cs+TxwHiyGzMBBaP3D15UrOmQfPzKNVr3boEvngYf5e2a
	wI9ovBEAwakFzwR8yruR0pYz2lUU3I/5sHJgtAHUO063gFyrYaw08j24NnvSlgxI8h/IC2dtJYWmb
	9ZjRcxEAG+dMrVef1tueG/kRKlA6ys+4KUIs7ITWC3Uhaluaea6jEaPnFmJblGkw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vvWrB-00000002Hao-2sfh;
	Thu, 26 Feb 2026 09:36:25 +0100
Message-ID: <3ecb3d440ed3ab4fe4cd3765e0c8457ef58fd6b6.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 3/3] wifi: mac80211_hwsim: Advertise
 support for IEEE 802.1X authentication protocol
From: Johannes Berg <johannes@sipsolutions.net>
To: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Feb 2026 09:36:24 +0100
In-Reply-To: <20260226065442.4182232-4-kavita.kavita@oss.qualcomm.com>
References: <20260226065442.4182232-1-kavita.kavita@oss.qualcomm.com>
	 <20260226065442.4182232-4-kavita.kavita@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-02-26 at 12:24 +0530, Kavita Kavita wrote:
> Advertise support for the IEEE 802.1X authentication protocol in
> mac80211_hwsim to enable testing scenarios.

Do we even need this in drivers vs. mac80211 just setting it?

All the code for it is in mac80211, so it shouldn't matter?

I'd actually argue NL80211_EXT_FEATURE_EPPKE is the same, mac80211
should set it instead of the driver (I didn't merge [1] yet anyway) and
only NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION should be in the driver?


[1] https://patchwork.kernel.org/project/linux-wireless/patch/2026011411190=
0.2196941-10-kavita.kavita@oss.qualcomm.com/

johannes
