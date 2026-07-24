Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C34A404BE0
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894736; cv=none; b=PSpMJ5mUaihgyaRRDzB1VfKneiL+X5/FHO1KJQ5z1W+1LaoRtKjhegdz1/NuV0ONTxxFZGx4S8h+ytGNflJAh74Z+48OSCGuvxhgYHj6LkerCZiM+Kd0XzYdA1GWExki3uXDbSIJpyTqyurR2fRXgN948aoDnbdjvD7BQDPJwaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894736; c=relaxed/simple;
	bh=6JWqdbeXuwxuJ3OgX9YlJ7Klum5SgMtFIEHAD2O/UcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pztmZ4VMhXHjFkBUZXXbNUrF1hkkcdsaMGtp1CBpAB4V2w5s74W1DHpTmP7LEOTV1tvwIMh/U/Kz7dhYCGATtsfohNR1F2XWLu31pTwjWizqj/69olzxJqS0gG+9zc8PqxOWTBrtdsHIjc6rwXRxTuvL/6noJ6BGj/uC1ynhTxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=BX1nQulB; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="BX1nQulB"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Fri, 24 Jul 2026 14:03:20 +0200 (CEST)
Date: Fri, 24 Jul 2026 14:02:58 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] wifi: mac80211: reject station association if AP is not
 started
Message-ID: <amNUcscgkmCjJdnT@nr200>
References: <373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org>
 <c9fa1c083ef9878240c2ee2fb223413153d93a68.camel@sipsolutions.net>
 <amMLPgO8Yv1wjMGa@nr200>
 <86efc46da2c0c5cf73ca262f8be8c5086d626ee7.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86efc46da2c0c5cf73ca262f8be8c5086d626ee7.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1784894730; bh=9WCcUBpcZugisq07q9owkL/cyHa7KP34+EFlP4Tgs1M=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=BX1nQulB7njOGni5MWKWw025B7m/y3cZfvjjUuoNhYJSP09cqKqasSE/XqsckiXcB
	 5koJHZ/CauhtM0y/hoV4BpMaaw/EmW8rI9e+mwRYwMSdard6emcKpCBtg1AaYG/yCN
	 wqQWxne+Kr5AP/uqUT5pWH7wyHDedruMFzslvqFY=

On lip 24, 2026 09:15, Johannes Berg wrote:
> On Fri, 2026-07-24 at 08:50 +0200, Slawomir Stepien wrote:
> > On lip 23, 2026 11:14, Johannes Berg wrote:
> > > On Thu, 2026-07-23 at 08:11 +0000, syzbot wrote:
> > > > From: Slawomir Stepien <sst@poczta.fm>
> > > 
> > > I'm a bit confused? Did syzbot just pick up another patch?
> > 
> > Hi Johannes!
> > 
> > No, this issue has been found by syzbot while doing fuzzing testing.
> 
> Yeah, but the email? It's "From: syzbot <...>" and actually was
> delivered to me by sea.source.kernel.org, whereas your other mail was
> delivered to me by smtpo49.interia.pl, so I'm confused as to who sent
> the mail and how :)

The initial e-mail with patch was sent by the syzbot on my request, that's why I'm in the added From
and Signed-off-by (bot can't be the Author of commit and I'm responsible for handling this patch on
mailing list).

You can read more about this here:
https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md.

-- 
Slawomir Stepien
