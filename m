Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2099533DEFE;
	Wed, 22 Apr 2026 19:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776884792; cv=none; b=WwDLCV5ySsHOK7bf71/PfD7h8qtk7WatYiOiJDhmE2QaIkh4qLJ9g1pBzdfiY6AHttCAPpUMrApy7p4rC5s181IjXgsYRBFQICTW9bn/Cepg8Wkft6UwCZPeaBSUx87OWB0ihE5fmxOnGT1pmWXrpuMtUefTPKvxFnixJ0fAg5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776884792; c=relaxed/simple;
	bh=5t4ZoPviliKuKdYhL0gnl7koeNrpssgKuvjjXu59Ofs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pgbex+/q2W1jnNXTlaqyjbCbwXHu/wFBvcfcgNjG4VksFcsXs5T4pJJMaKkZ3BgmWEBT7HDRC7NBI1Bx8uXV4QYdsuL6ZkjuyjRhqLv86r+2RX4dbV0atJGKPz7I3cgcUL1hByzW2odK7xQ9C+79geVplteIB0k8FRiQ+FxxL6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NwhMu4bB; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NwhMu4bB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=XNvXL+h8MBHy+4KpaY/b4FF58OsfMwUcG5tMZd/vCH4=;
	t=1776884782; x=1778094382; b=NwhMu4bBTodRrkCAD3pmzLvavmTMFm1r9ZgbFzVo5iG+Dcj
	jOKJhNfuA0qKoQvLvlDQnA1PgehxfeAnor0CXfA1atqsnFV5fs50el2MReZIh0AaA3PlwMir6eIZp
	DaOLsDnzGF+6ubCit8AuTm//+05p9vGRBHaFOEnzzz/9YaD69pzGtWyYu4spRxEQCR8c1cmDU9wUJ
	Szt4RfVldQxlui0hEy0Nx8irnAJcoZ9tE3p+V77MoA5pzASHedugm999wYuTZxjIcsNJibJYma1kR
	/AfXg7b0aR5nzcmEU9Twf+g6CrPl1wIUpO3aS9vt2uXXYsVRkMtOmrVWL156KplQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wFctl-00000006SoT-02IJ;
	Wed, 22 Apr 2026 21:06:09 +0200
Message-ID: <247e926c76f01aaf13793d39492a2734ef11cf12.camel@sipsolutions.net>
Subject: Re: [PATCH v3 3/6] wifi: mwifiex: fix OOB read from firmware
 sta_count in station list response
From: Johannes Berg <johannes@sipsolutions.net>
To: Tristan Madani <tristmd@gmail.com>, Brian Norris
 <briannorris@chromium.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Tristan
 Madani <tristan@talencesecurity.com>
Date: Wed, 22 Apr 2026 21:06:08 +0200
In-Reply-To: <20260421134938.331334-4-tristmd@gmail.com> (sfid-20260421_154945_925411_F2F09AE8)
References: <20260421134938.331334-1-tristmd@gmail.com>
	 <20260421134938.331334-4-tristmd@gmail.com>
	 (sfid-20260421_154945_925411_F2F09AE8)
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

On Tue, 2026-04-21 at 13:49 +0000, Tristan Madani wrote:
> From: Tristan Madani <tristan@talencesecurity.com>
>=20
> The firmware-controlled sta_count (u16) is used as an unbounded loop
> counter for iterating station info entries. An inflated count drives
> reads past the response buffer into kernel heap memory.
>=20
> Add a check that sta_count fits within the response size.
>=20
> Fixes: b21783e94e20 ("mwifiex: add sta_list firmware command")
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
> ---
> Changes in v3:
>   - Regenerated from wireless-next with proper git format-patch to
>     produce valid index hashes (v2 had post-processed index lines).

For the record, that wasn't the problem. I _think_ the problem was that
your post-processing also skipped whitespace-only lines, which are very
relevant in patches.

johannes
