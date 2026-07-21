Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5382E1F06;
	Tue, 21 Jul 2026 16:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649638; cv=none; b=V6QvekCSl3e9fV03YsFzjGGWNoxAXB0/8WKQeNttF1GBsALVRgJ/+rGsANic9b2dlJPWG4gZRo887tuLfbICmWl3IkhKDvdjLLCDjO2l+EiGvDiAzU2aFWwo78vELq3RN3qDvXBcPcwmuKHSTx6sDHuLIwvgkUkg/yxthG8th6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649638; c=relaxed/simple;
	bh=syOoirWRee4fAFDMiZjS7z2YwCPaHvO8bo3bmPwdvzQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fiIxFOPfow6GA3EaX0q9P1MO2NiEE40HvFTpB0SdG4kyIir0pORpN67CRqgFPqqzQmhaSJdkglMzfJOAPkdrRj7BjKayIGX4dWBgPwRpSUbY3yGDXZnzPCq2v50WFEbJ0WwoZ6i4iGqkCKfh2KRg2A0O+YM5+RIdgWsMzPZHpJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=N02fHBAu; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="N02fHBAu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=y8JnPlEgVBx9Wo+Ky4UlFY/h3kbkBte306ipmIU+3p0=;
	t=1784649636; x=1785859236; b=N02fHBAu+7sh9gWtNThFe3CGmy93hxJ05uKgMkZ71dgjIFm
	dJeh8zG6hjc4vyvDNI3xqkougU5e2eOTk/nZmbkme/XLyfcwh++FuaOGHv4TgHj+C+moF0ccDmmn2
	pV/Efs83IH3c6gm15IUr6quqjsARfFk5sDQjwwroKXq08CfjknpeTwACUbFdkhV3WeCpFzTWnRQtJ
	y3I5OoXShH5ry53G1vOlKpJQf4oIHCjEH5UJZUEPZKPJEu9/HrIqskmjIe2BtlcrAzZKJd+QXRVjQ
	mDsJ9soKdfENi3Mf6EZf6+rzAvqk9qXV1XohFmvj8L2Tn9Y6z8t0SGOfeUuvObIQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmCtS-000000029Cx-141a;
	Tue, 21 Jul 2026 18:00:30 +0200
Message-ID: <573e7a49f4e9763b0cdb22bb4fc875bca1335c70.camel@sipsolutions.net>
Subject: Re: [PATCH 0/8] wifi: fix PMSR lifetime and frame validation issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miri Korenblit	
 <miriam.rachel.korenblit@intel.com>, Brian Norris
 <briannorris@chromium.org>,  Francesco Dolcini <francesco@dolcini.it>,
 Jaewan Kim <jaewan@google.com>, Daniel Gabay <daniel.gabay@intel.com>, 
 Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Benjamin Berg
 <benjamin.berg@intel.com>, Anjaneyulu	
 <pagadala.yesu.anjaneyulu@intel.com>, Peddolla Harshavardhan Reddy	
 <peddolla.reddy@oss.qualcomm.com>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 John Crispin <john@phrozen.org>, Avinash Patil <patila@marvell.com>, Cathy
 Luo <cluo@marvell.com>, "John W. Linville" <linville@tuxdriver.com>, Aloka
 Dixit <quic_alokad@quicinc.com>
Date: Tue, 21 Jul 2026 18:00:28 +0200
In-Reply-To: <20260708195911.84365-1-enderaoelyther@gmail.com> (sfid-20260708_215930_683827_CD8CF763)
References: <20260708195911.84365-1-enderaoelyther@gmail.com>
	 (sfid-20260708_215930_683827_CD8CF763)
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

On Thu, 2026-07-09 at 03:59 +0800, Zhao Li wrote:
> Hi,
>=20
> This series fixes a set of PMSR lifetime and management-frame
> validation issues found while reviewing the wireless stack.

This is honestly a bit messy as a series, covering all kinds of drivers
and CC'ing everyone. It'd be a lot simpler for everyone if you just sent
them all individually, or at least per subsystem, putting only the ones
that depend on each other together.

> Zhao Li (8):
>   wifi: mac80211_hwsim: clear PMSR request state on abort
>   wifi: mac80211_hwsim: authenticate PMSR report senders

I'm going to look at these only for wireless-next later, I don't think
hwsim is all that relevant in deployed systems.

>   wifi: iwlwifi: mld: abort active PMSR requests

I don't know about this, Miri should look (I think she said it was
handled already or so in patchwork).

>   wifi: cfg80211: guard optional PMSR nominal time

That one vaguely seems like I should apply it now.

>   wifi: mac80211: validate probe response countdown offsets

I think this one is falling into a typical LLM pattern patching trap, it
describes [0] as being out-of-bounds for some allocated data, and
neglects that the offsets have already been checked by cfg80211. Please
describe more why it's actually an issue beyond "there's a similar
pattern elsewhere".

>   wifi: mac80211: validate S1G TWT params before driver setup

I don't know about this, you should probably resend it. Anyway I'm not
loosing sleep over it since there's no driver with the callback, tracing
is mostly not enabled, and while a potential 12 bytes OOB read at the
end of the SKB is a bug, it's not a very important one since there
should be stuff there anyway.

>   wifi: mwifiex: validate action frame fixed fields

Francesco should look at that - again, sending it all together makes
this really hard - but it seems to me it should use MIN_ACTION_SIZE()?

>   wifi: nl80211: clean up color-change beacon data on errors

In this one it seems it'd be much simpler to allocate the memory first,
i.e. change the order of operations rather than complicate the cleanup?

johannes
