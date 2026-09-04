Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECEF3C1D58
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 07:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788508277; cv=none; b=d0EjB/C/eJnHbAPmPI/+CyyTPSyAIs7XQrZ+FWFOyWeOGXMTHA+FHnnY6cwkSZsfJBraZT+qiMvB5JJ/NxNTskFHHtxUJX+1dFvraKURoez1YAB0IQAJnsNhRX3ie9uw3Q5ZzwhLqzJIhkr7A2/xvIHX3dDJjQR00mLhBba5zFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788508277; c=relaxed/simple;
	bh=cnrs59kGCOYf9UNOzW2g5dRmauww3nGtSRJJyWDTJwE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lA7xWJaSNi35/l57qtOlUziXhXw3cxz7RBvkKzW27++X6J2lX6qK4bkzVT3DX3MpC0YCHNH5JBFLUGVxEYtz5KQf5yVE/1ukMycfjISGa5hGCbe9cc7qa+O6Xh2b62gK/0MKUP4/zLFsFWE/MZrGFhAb/IfxfG/sVnXW1ICIviI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aWzFSC5S; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aWzFSC5S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=cnrs59kGCOYf9UNOzW2g5dRmauww3nGtSRJJyWDTJwE=;
	t=1788508275; x=1789717875; b=aWzFSC5SBnjluwdKJn1q8v7dXEDoddEKrwUjPgNFiG2e2/f
	lO4JfyHg7/34zA4y/ZYAwT7rbWK1xseuoieUf4+921pqV96gbUulaqAuW2GESPJ5nb9eIvwhKAvNb
	6sDhtYVd291x/+VI92p40PLBBxunjp8jpOPNtrIGAYA8xxMocK/3w6OUSgnFAUG4hVRH3SEwUx2s+
	iliRd6apx+ePB6OhGmpMjiUhAUPXhi9dVnx9smABHxQG4o1b+aEM3Fqyqc9aJQKtxoSCzBkpWMbik
	VMQKRulL9JY0FoSZ1X3vZAqf6YqFXmGAvYk5KcQ9wPAvaAUTPeFNjq7PY0DHXsuQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2Ohc-00000001FQj-34Sp;
	Fri, 04 Sep 2026 09:51:12 +0200
Message-ID: <b530c83604a1d9934374bd0bbd0cd7d84d786076.camel@sipsolutions.net>
Subject: Re: [PATCH v1] wifi: mac80211: fix swapped
 fq_overlimit/fq_overmemory in aqm debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: linux-wireless@vger.kernel.org, Toke
 =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?=
	 <toke@toke.dk>
Date: Fri, 04 Sep 2026 09:51:12 +0200
In-Reply-To: <20260823195739.49222-1-julius@bairaktaris.de>
References: <20260823195739.49222-1-julius@bairaktaris.de>
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

On Sun, 2026-08-23 at 21:57 +0200, Julius Bairaktaris wrote:
> The aqm file prints fq_overlimit with fq->overmemory and fq_overmemory
> with fq->overlimit. The fq_overmemory line was added to the format string
> after fq_overlimit while its argument went in before it, and the two have
> been crossed since.
>=20
> The counters are not interchangeable: fq_tin_enqueue() bumps fq->overlimi=
t
> for every packet the eviction loop drops, and fq->overmemory only for the
> subset dropped because the memory limit was exceeded, so overmemory is
> always the smaller of the two. Reading the file to tell which limit is
> binding gives the opposite answer.

That's just LLM fluff, please rewrite the commit message manually to not
just like that.

johannes
