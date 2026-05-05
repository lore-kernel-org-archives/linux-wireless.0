Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D403246FE
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2026 10:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777976482; cv=none; b=N4u6fxUN/xdPbsn0XbshMz/0Wa+EK3yU22ar9f773Lfg3aeCk9UWEkK4TgzlioxMGdKmQG87uU5+KXxi73iv7dyOEoT++EJVgdvXMMEZCH5kKDMfTJRRL3xmGbrx+NcMUmU7jnLwkaVEku6kJd4A/AoMvqLcVwX1QYRCqaaYX2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777976482; c=relaxed/simple;
	bh=MpnWS41ynyb3wJhRKbT6t0+0HM7QrOJwtRSMJennjo0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gyvs0ayXEjhfU6OE7Fi8okTqrvxThkmD2IQxR1GD2NfbcybCbNiovYgpOUdhfde7vpaHqArhav+sgDMOxXm2W2oOk+mFhh8LvQivQyU+hexgHoPOm3LIerjvUqcEbaDOpGyN1tOopx1eLGKFY+WcGSEaVvl9RMC8ClSETYuSFw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=TFpwLBJR; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="TFpwLBJR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MpnWS41ynyb3wJhRKbT6t0+0HM7QrOJwtRSMJennjo0=;
	t=1777976480; x=1779186080; b=TFpwLBJR75awlg1+4SeEbfUH2BS3N/zwu8VnytWx4vIfZxs
	uQLV5YDFy+z/wpDsBlt/PiJ2fmmYjIvY+szJ6Llc3zbIytoMwxByOAftpSQP5h9g7jOsGCxnoLEBR
	fO0973e8JX7/pD5K1Lwrr6HuZfu/S2IhcKwMaZEP6Aq0nF90D9BGziixXJFARhv0ktDVBB+DE34Yn
	8XBvPoc/2zvdMCbgkA3nw1/KFO5joLeqzT6K2D4pXhSFe6vYKXvL3dcZxxW9kgv2fHmdUaa705FIF
	Tgn3iIuh/PVUW56z3cAHM1xLJSGkaYlNla9K4Drqdp1III8tpvJbmoDhrU41mQDQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wKCtx-0000000FzR2-0fMv;
	Tue, 05 May 2026 12:21:17 +0200
Message-ID: <f127429e45d55ff29822856c892556966589e217.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 0/2] wifi: cfg80211/mac80211: optimize
 station info handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Sarika Sharma <sarika.sharma@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 May 2026 12:21:16 +0200
In-Reply-To: <20260430053810.2088793-1-sarika.sharma@oss.qualcomm.com>
References: <20260430053810.2088793-1-sarika.sharma@oss.qualcomm.com>
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

On Thu, 2026-04-30 at 11:08 +0530, Sarika Sharma wrote:
> This series improve memory and logic efficiency in cfg80211 and
> mac80211 during NL80211_CMD_GET_STATION. Allocate link_sinfo and
> link tidstats objects only for valid links to reduce memory usage.
> Avoid setting non-MLO applicable fields for MLO stations to
> eliminate redundant operations and simplify the code path.

OK ... so taking a closer look now.

There's altogether too much going on in these patches - the first one is
really cfg80211 only and should be tagged as such (API updates across
consumers don't count), and I'm not sure the cfg80211_free_link_sinfo()
refactoring is useful - but if so maybe it should be NULL checked
inside?

The second patch *should* be mac80211 only, but magically removes also
the cfg80211 code ... I guess I can see that's no longer needed, but it
might better be a separate commit that explains that.

And finally, given that all of this is entirely dead code since my
commit c3f8d13357de ("wifi: nl80211: completely disable per-link stats
for now"), I'm not really all that interested in optimising it.

If you care so much about memory consumption then we can just delete the
code. If you actually care about exposing the information to userspace
(e.g. for the, entirely broken, MLO_SIGNAL_POLL in wpa_s) then you
should really fix those issues, and maybe then figure out any memory
issues.

johannes
