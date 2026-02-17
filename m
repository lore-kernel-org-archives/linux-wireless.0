Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7845D334698
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2026 11:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771328512; cv=none; b=PRPtXgqP8GBfwp46+F3dmytB96zTtWh2WVV7zWGP7sNncx8AleRbPIW0nqskKkggNkSCSPL7dUq5BE3/raQD1gZFFfzLfKwkGe1nrxiCDDWQXU/XjF/hD9kSfcXTs7Z+bHR6JNdtlRqovQUkgSyY92WAMS9a2OYFDltqHbadq1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771328512; c=relaxed/simple;
	bh=/Qrug7C+8i1GbcO0ptty3XvHTLbxYp94FInCYKlW4+c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JpCvYCNzhgtX9bg5q3uW81fL3eVuM5Tur8ts2twsnOFGI6ITuXZ6C9Knya8MUeDwbiphnJEG9k/RhGm4D9Nf4UWC+C4/2wtMKhbB3pilMd8UVWP1Lv6585CWo415l42tAwM1DAyy+EsHVBoJztiNFhN//pCCYMwOC0gAH9Ahk+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Y6jrVJ/6; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Y6jrVJ/6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/Qrug7C+8i1GbcO0ptty3XvHTLbxYp94FInCYKlW4+c=;
	t=1771328511; x=1772538111; b=Y6jrVJ/6TTCQovaf1I4wmnYlEZGZf70pVShxS9u/tFHBfU8
	xF18b2rISdt8HvF2ciiauJgYW2r/JlyWLfxhQHf++qAB0eJIrjNXcxqqFN/QuCbNvnUIg0VNElmAx
	IcogUz1zt+feBLliP+plIA3xP1sXJr6C2Ahx9Ox668wqkXS67povyv4kKWHpJoOyFGBTpqCAnBurY
	jyZqcf8TlcezPV94yPl6bWH9P2b5O08Vkglm9l4LaFJ2MP7bsx1ClBXpRACRsuvVn0x53N0WBNq5+
	si1JO4jTcf04/ZBtQHV2NI6cisWxJybtJByxgyc9xMk/8UQ7i7ju1kczzhsWmJyg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vsJSf-0000000BMtj-0Zx5;
	Tue, 17 Feb 2026 12:41:49 +0100
Message-ID: <ed4316fdadf5b25e9e27df355ea14eee1efd7181.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 1/3] wifi: cfg80211: Add support for
 S1G Response Indication Configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Ria Thomas <ria.thomas@morsemicro.com>
Cc: linux-wireless@vger.kernel.org, lachlan.hodges@morsemicro.com, 
	arien.judge@morsemicro.com, pradeep.reddy@morsemicro.com,
 simon@morsemicro.com
Date: Tue, 17 Feb 2026 12:41:48 +0100
In-Reply-To: <20260212084351.aqswgnvnuepun6em@1207> (sfid-20260212_094358_698471_E6882E0E)
References: <20251209062424.3926297-1-ria.thomas@morsemicro.com>
	 <20251209062424.3926297-2-ria.thomas@morsemicro.com>
	 <9eb13765529bac88337ab2fd1a13769fa4519f52.camel@sipsolutions.net>
	 <20260109040041.tnk7e6uewo24u3tr@1207>
	 <048c2715d08822d7f79b082cbe332f982d8ced61.camel@sipsolutions.net>
	 <20260206061139.6fdwaazvk4swpreo@1207>
	 <ec999f04a965006dea6bd8e7380996b6fca980b4.camel@sipsolutions.net>
	 <20260212084351.aqswgnvnuepun6em@1207>
	 (sfid-20260212_094358_698471_E6882E0E)
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

Hi,

> > But we still need to decide where it should live, although in
> > that case I'd be more willing to accept an interface setting despite
> > the lifetime issues.)
> >=20
>=20
> We think it makes the most sense to treat Response Indication as an
> interface-level setting=C2=A0 as it avoids introducing peer-specific stat=
e
> that is neither negotiated nor maintained by the protocol.

Fair. I don't really think it makes a huge difference - this state is
not negotiated nor maintained by the protocol at the interface level
either, after all :-) In a way I don't think it's a good argument either
way I guess, but if it's only a debug config I also don't care much (and
we already have things like tkip_mic_test that are in a way similar.)

> That said as the response indication is only a test configuration there
> is expected to be some changes to the upcoming patches. I would preferabl=
y
> submit the response indication configuration as a single patch and NDP
> ADDBA/DELBA negotiations as a different patch. This would open up two dif=
ferent
> new mail chains for two patches which is different from the current one.

Sure, if it can be separated I have no issues with that.

johannes
