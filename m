Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1199B3EBF2D;
	Tue, 17 Feb 2026 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771336778; cv=none; b=FHDaBTHVMuotEdsviOY6xB7OBN/EW6umEqoy50d4cUiMqq5HEC1PoiwOEFfVSMJE0QzGI5etcCOqJk+lqBBKbI2wvXcuI7VYNcfpp/KbiL9owOJx+i9xCMXujSi9macIZlx319kCL+elY7Yr/DuvtOexucJUmEQoCJBme/evT38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771336778; c=relaxed/simple;
	bh=boaERLXryXzFhxR64saNu+R655qeK11Ene3W2f6KjZY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WmwuR/uX81V/dCx3JYKSgUtN4Hso7yeCZruUPUKdH5MvG/sRW+imOxGoytZsJGJJfcRsYaHgXRik99EG5O3NMObmMRRX7IGXD8eDXxjDhMAcKuhxyVcyvYgE2zcXTTCWF9UoYUXTKEUnpeESLpDb6M2J66AF7s6Y050QMk3FUPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ejmsNw22; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ejmsNw22"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=boaERLXryXzFhxR64saNu+R655qeK11Ene3W2f6KjZY=;
	t=1771336777; x=1772546377; b=ejmsNw22hQoJPDpblEayE1MaErJfUpFgPjwe3QCApALH+A5
	UDhXGxiXsbNdUf2uAGmOu8SlzZUispWfYEFzPTfaW3jFjrxWSoZ4gl5+EIKfG80FMShg3M8gnasPv
	sAgQLaWr/AStb/7FC4WskMT/FqsFG0oIUQWfedV6wDG6+8AnS7Ocp8VimJBndcUVYgQ6sr6EAB9RX
	Vckvl5oWtEXA5EpSxSAzBvjaZuK7zfxG5t/VnhCGrBLRUasw+S/LyYqBIg3Mr479yBlnrGs6k67k+
	eOAv1YHIRLbYkEatCuqBK1oWwJ19l3U/QUxe6syHKPB9nzUofE4yrgYIGI/TmW6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vsLby-0000000BQMp-3UYv;
	Tue, 17 Feb 2026 14:59:35 +0100
Message-ID: <d142f76473a03c76c780390f0352ffbb03566e48.camel@sipsolutions.net>
Subject: Re: [PATCH wireless] wifi: mac80211: Fix ADDBA update when HW
 supports reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Remi Pommarel <repk@triplefau.lt>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 17 Feb 2026 14:59:34 +0100
In-Reply-To: <aZRnlPA_uY9uWuKr@pilgrim>
References: 
	<5806bab7e46506d3c300ab4eb66989d42936aeb0.1771323902.git.repk@triplefau.lt>
	 <f1243e86eea72999581d33c6f97ff9015ce71542.camel@sipsolutions.net>
	 <aZRnlPA_uY9uWuKr@pilgrim>
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

On Tue, 2026-02-17 at 14:05 +0100, Remi Pommarel wrote:
> On Tue, Feb 17, 2026 at 12:30:08PM +0100, Johannes Berg wrote:
> > On Tue, 2026-02-17 at 11:36 +0100, Remi Pommarel wrote:
> > > Commit f89e07d4cf26 ("mac80211: agg-rx: refuse ADDBA Request with tim=
eout
> > > update") added a check to fail when ADDBA update would change the
> > > timeout param.
> > >=20
> > > This param is kept in tid_ampdu_rx context which is only allocated on=
 HW
> > > that do not set SUPPORTS_REORDERING_BUFFER. Because the timeout check
> > > was done regardless of this param, ADDBA update always failed on thos=
e
> > > HW.
> >=20
> > Seems like a legit problem, but
> >=20
> > > Fix this by only checking tid_ampdu_rx->timeout only when
> > > SUPPORTS_REORDERING_BUFFER is not set.
> >=20
> > that doesn't seem right? Especially the way you implemented it, it won'=
t
> > even respond at all when it's an update and SUPPORTS_REORDERING_BUFFER
> > is set.
>=20
> I could be wrong but I think the patch format here make it difficult to
> read. If it's an update and SUPPORTS_REORDERING_BUFFER is set, the
> following "if" in the code (not fully visible in the diff here) will end
> calling drv_ampdu_action().

Yes, but it will be IEEE80211_AMPDU_RX_START which isn't really intended
by the state machine/API between mac80211/driver. So that doesn't seem
right.

> That is another way of fixing that yes, but the question here is, don't
> we want the driver to decide if it wants to support timeout update ?

Not really, there's no driver that _can_ to support it now, and it seems
unlikely any driver would _want_ to support it.

And if so it should probably not be IEEE80211_AMPDU_RX_START but rather
some new IEEE80211_AMPDU_RX_UPDATE thing. But I don't think any driver
would implement it, I don't see why anyone would want to, this flow is
in the spec but never really used.

johannes
