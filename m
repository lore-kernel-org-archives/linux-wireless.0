Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38703A4F50;
	Fri,  4 Sep 2026 07:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505209; cv=none; b=QP/NNREfmmxTmqb4K6OhY77OE0wKWV1gXVQDmvzZ9g9uK1JXb/rd7lksBlul1+9jOwWMWzss1F1bB7X+JUankIpVJrhO7rESOCvTvOy1jqPwovWPQoxdNY9KuJlurGcIH62XNuH8h2Yd9uUoq1N/OfhM3aB+9iCP97oMv1m1ch4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505209; c=relaxed/simple;
	bh=HdP1e9LEi5R4f0ioMOHcHU9Ul+kojzvDxwkVthFrZjE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dwZjCaRDKKBRCjI+I203SV2kaFdDXSITZhRvssBv25Zbx98E3UhDUF7Dacx2Guy7WAncz3sfu56JSb9Z5EdG1d75CNVPK08lQcThAxIcmAk9keSnM3mgh8wzyA6036sHNt2kA2nyAhbOLqq7zxrWynEcLdTv8UdnVgVzDv1p20k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=wZwbsK/X; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="wZwbsK/X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=HdP1e9LEi5R4f0ioMOHcHU9Ul+kojzvDxwkVthFrZjE=;
	t=1788505207; x=1789714807; b=wZwbsK/X6j1YGdOg/0+lXIVxw29ymmE+klWm8B8Zc7HIcwe
	DgG4YB7bC1LtRp5ZRcXubkhwPryQYm6ATsbeD1Kfb22bFR0r8qircarfOobvKccanvT3Pe/xwAjxJ
	N+cJ+S/9fOItfCgeRHKoftKWRGfkS5UpyAwjyaJ30o5E0+2JD0rFCuw5qUrn2CHk/SluuLE6E1AmK
	F/Cu5muLHaSwpzW8X//dkSQdYm/BJIPYM9dkNcM9PVNyvqRnRRPh6syIsV44p8yyR2aEe3AxlTJjt
	Z6bDDLVnRhLrLpDYZUDdwfhSz1ItaG56uYmUDayI+LfvH8HB6jfZezmSqt1Zo/DA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2Nu7-00000001DpE-3w8w;
	Fri, 04 Sep 2026 09:00:04 +0200
Message-ID: <b641fcfecbb189227da60e2a886c798b5463e0ad.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: p54: Use flexible array for channel
 list
From: Johannes Berg <johannes@sipsolutions.net>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>, Kees Cook
 <kees@kernel.org>,  "Gustavo A. R. Silva"	 <gustavoars@kernel.org>, open
 list <linux-kernel@vger.kernel.org>, "open list:KERNEL HARDENING (not
 covered by other  ""areas):Keyword:\\b__counted_by(_le|_be)?\\b"	
 <linux-hardening@vger.kernel.org>
Date: Fri, 04 Sep 2026 09:00:02 +0200
In-Reply-To: <20260511075640.446181-1-rosenp@gmail.com>
References: <20260511075640.446181-1-rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-05-11 at 00:56 -0700, Rosen Penev wrote:
> Store generated channel entries in the p54 channel list allocation
> instead of allocating them separately.


Somehow this was still on my list, despite mostly having decided to
ignore these __counted_by() things ...

And you clearly didn't even run the code or pay attention to what you
were doing, since p54_update_channel_param() has a bug that this would
have exposed.

johannes

