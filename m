Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2FE4973AB;
	Mon, 28 Sep 2026 10:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790590531; cv=none; b=LcfKXQc2LlZKdYd8qo6Cf94IxkUsyLSpWRK/qmat90K3TooBze/PIcbxQTbKoOVqR3rPUFxFydVVl5TenmKbjrsCNNE9cJwxob0awxtWncqOKKouPQt3cQ9inQv9EmJyV9w7aXivIthXMKtSoswrO1wsQ6gKTZF31Y7Mk8HVBec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790590531; c=relaxed/simple;
	bh=xJmD7Ggat0xCtmwzsYD9DrfBO9Jd+BpGgLq+9l+05Kw=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bybFK1loyAcs5QXb0Ym5t6AU9n85/LoK1ahCFPRMZCWBXJeoYeHjku18yYggmglZUNEvNg/VzeXyntPrJitCzBkwQY9r8z0BPZALGNvpL1on5nzxiGtwyk6EeI9VjxsdpjNj4rV0nfoK18UGmWusx8npZ4oz4K1c0ts+4vXr3MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nIKDVUAU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nIKDVUAU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=xJmD7Ggat0xCtmwzsYD9DrfBO9Jd+BpGgLq+9l+05Kw=;
	t=1790590529; x=1791800129; b=nIKDVUAUn6Q8Rls3IQUzagn6k0gf7Yfe18DEZjmsq4CFJXD
	LtlyPSnNZjKRPy7zy64jkK66p1M0vMmP0/XA+XgY8FBJUSBWawVYUdlkZda7EeheEKbIheH8hO0RR
	lzpjni3wayGbv/iHmYmY+armcJCLa9fu1RIiHKRDhLWPAEfR1DLPt85eLJMVnlJ1NTXxcvRXLezq5
	QfiVrSz3VicdnDMIC0Aq144mLLg8lpvXCdWjd5lvxan/U3xpUyia2zOtOCDRQz2kQSXTrq67N6k4G
	YBfiBwVnbtSmjfteHi+kzJ5yhpSHZAO1UZbZVV+G7hmcpvlBMbOzgAF4eJAjDcHg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xB8OL-0000000DS2R-1LI7;
	Mon, 28 Sep 2026 12:15:25 +0200
Message-ID: <9b3efaebb9f5460f6bfaaa284fd235e76c940361.camel@sipsolutions.net>
Subject: Re: [PATCH 1/1] wifi: mac80211: ignore PM bit in non-bufferable
 MMPDUs for PS start
From: Johannes Berg <johannes@sipsolutions.net>
To: Lee Jones <lee@kernel.org>, Emmanuel Grumbach
 <emmanuel.grumbach@intel.com>,  Luca Coelho <luciano.coelho@intel.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Sep 2026 12:15:23 +0200
In-Reply-To: <20260928100508.3487525-1-lee@kernel.org>
References: <20260928100508.3487525-1-lee@kernel.org>
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

On Mon, 2026-09-28 at 10:05 +0000, Lee Jones wrote:
> Per IEEE 802.11, the Power Management subfield in the Frame Control
> field is reserved in non-bufferable management frames (such as
> Authentication, Association Request, and Reassociation Request) and a
> station remains in Active mode during authentication and association.
>=20
> When commit 9fef65443388 ("mac80211: always update the PM state of a
> peer on MGMT / DATA frames") allowed non-bufferable management frames
> to update peer power-save state so that re-authenticating stations
> could transition from doze to awake (sta_ps_end()), it also allowed
> non-bufferable management frames with the Power Management bit set to
> transition an awake station into power-save mode (sta_ps_start()).
>=20
> Restrict wake-to-doze transitions (sta_ps_start()) in
> ieee80211_rx_h_sta_process() to data, action, disassociation, and
> deauthentication frames using hdr->frame_control (avoiding inspecting
> encrypted action frame payloads prior to ieee80211_rx_h_decrypt()) while
> preserving doze-to-wake transitions (sta_ps_end()).
>=20

This doesn't make sense to me - you don't really say why you're making
this change other than saying what the spec says, but then you're
explicitly not spec compliant both ways - without any explanation either
way?

johannes
