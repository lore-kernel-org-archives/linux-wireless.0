Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0EE335091
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2026 09:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974755; cv=none; b=C0LO/KwAQcGObfH8fb+DcUpilXHpjohZYUnI+6F8IxvC+NhdKFt/cj5ivz6ZAj23R2hLbbT3PvBp3eplqSAGKxm0jnhbP7Gkob2gz7U/i58d4O1EUAA4SYChCyBg9o/fBQGrXDLKe5dWdhx9EX0FLghyZ6AuX/1zotGymmqWUuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974755; c=relaxed/simple;
	bh=CJBkTOM5ihIMN69niUPgRcfbM/5c6Jkz+xTl+356rpQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pe7L49Ezstl+NYM1GPfYEo1jY22zyUy1fLSvFVmSCOrZKoLkTbiXHqAGosVGr6lF4i7SUMsxsVUvWSnC2rUTsQa8rGxJG3f3I5WNEd828Jb4YOtqlqYDkQd9ZF+JNexsQCKl3ZXaoX08rY5Xh3y6gUFZKzRNiakZCejJA6wMdtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=V8JMWATj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="V8JMWATj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Sd9tBpOvG/gt7v7BBop4+ghXyOYPnSTwQxeED8QfyyI=;
	t=1777974752; x=1779184352; b=V8JMWATjD+rucADSbP2Rwvj8y+KMtCupSNz6t6xjPyNEZmM
	hfnkoApZmOqKKYkTxBmu7r363wHhKtpR5eD42O8E2QOrBGo9fw3muYypyyEW3t1+JjHcj+ASHc5L6
	BX7sPUhaSIkJCkhLInBgTUtkSFIn/pDzieb5cKXpOxo+iosDCMM0hGANUnLTWnERr6BznDRZYYNx2
	Fxp+Pd3L5vzSGgjxr89HvfFqbSB4JFtzWgCgkgB4y0anZDB0yraV4hnvx2BNINHrAo0RDSOAlcXUo
	ZWKpLuPrDwDs5UlScQBuz1CMZowk/K4y8v0VG16U0qrA0y01h2ji0qf/yjTYWIHQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wKCRz-0000000FxA8-2uhE;
	Tue, 05 May 2026 11:52:23 +0200
Message-ID: <66d038a7793660ed1b4d47b615d09b092a85c84b.camel@sipsolutions.net>
Subject: Re: [PATCH v4 0/2] wifi: libertas: fix two OOB reads from firmware
 fields
From: Johannes Berg <johannes@sipsolutions.net>
To: Tristan Madani <tristmd@gmail.com>, linux-wireless@vger.kernel.org
Cc: error27@gmail.com, kuba@kernel.org, dcbw@redhat.com,
 linville@tuxdriver.com, 	lkp@intel.com
Date: Tue, 05 May 2026 11:52:22 +0200
In-Reply-To: <20260504191452.3408257-1-tristan@talencesecurity.com>
References: <20260504191452.3408257-1-tristan@talencesecurity.com>
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

Tristan,

This is going to be the last time I reply to you if you continue this.

Please:

 1) Send patches that actually apply to the relevant tree
    (wireless or wireless-next in this case, ideally tagging it in the
    subject such as "[PATCH wireless v5 1/2]")

 2) Consider feedback you get. Even in another driver it's not useful to
    check one size against another size if both are provided by the
    device, unless the other is already validated. If so, add a comment.

 3) Disclose AI/LLM usage per
    https://docs.kernel.org/process/coding-assistants.html
    (Yes, I don't believe you came out of nowhere without it.)

johannes
