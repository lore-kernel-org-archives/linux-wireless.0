Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F4B3C1097;
	Thu, 23 Jul 2026 08:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793998; cv=none; b=pn4z8/R+aR8S7eXjK/zSK3J6Vy9EuupyAHbKMonchLaLM3ZBarMeeloLbo7eAURxLx7p3VO/5xtw9wfbzyp1U7+8DBq0NGnyjUBDA6mELg4athwEP0ZW1wYuJWKga7ot3Nf2ydL6HLSpONf/ilALQFCvM7HusoHl8AIMevQBchQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793998; c=relaxed/simple;
	bh=f957m6y2uSD+UXziLpFTM7/CN2Uy2ayT6XknNA0pVTI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mfX62nKxwnq8ZekaCpB80yvl9TID+WeBD27xVEaXLkEg/79YFyqKBsjLP2dnKj2OVP1XyRz/m1ZCJsAjnpQHJzbLrmHgK7m0HmEX617ULY/KKvh9z9d9lWen3eP423QtSI45eI7dwDgaHeZfadnX9rcxFlllmv1nlKjE+KUaYk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qQauxHPk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qQauxHPk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=f957m6y2uSD+UXziLpFTM7/CN2Uy2ayT6XknNA0pVTI=;
	t=1784793996; x=1786003596; b=qQauxHPk2zCNOkVkOgbSEL0pggF0fiP1RaB8yJQmykQNCXC
	n7nkYOeGSUMCHaWGawUjjg1+3FhXxMuLtHt5aDTjCXx43le2gvZLMA0tP6drAtU7WwwKuJ3ryQ2w6
	HuTTWKUrdzS9hG8n9UkLlNW18EcGaE9Ra3zyDyqFNoQiJdvmwI4qC2WY65IpZ7tSwLCs938qo+f/h
	JoDvoqMZ/L7NS2EyX+kiflVAO0XwToKb/ysQhLexoQWzSVY87u/OYOVUGXgci42u8RAmIV0ECtRQV
	Uk70xqhzS4JbuvPUWlK9qiMNuhppGnHGtUpzYUomt1jeQW+ujGDIWnSdDnsEimhw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmoRq-0000000AGX5-3gwu;
	Thu, 23 Jul 2026 10:06:31 +0200
Message-ID: <b77e23acbdb61b3ce22b063e2b8f0ef3ddfe942b.camel@sipsolutions.net>
Subject: Re: [PATCH 0/8] wifi: fix PMSR lifetime and frame validation issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: Zhao Li <enderaoelyther@gmail.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Miri Korenblit
 <miriam.rachel.korenblit@intel.com>,  Brian Norris
 <briannorris@chromium.org>, Francesco Dolcini <francesco@dolcini.it>,
 Jaewan Kim	 <jaewan@google.com>, Daniel Gabay <daniel.gabay@intel.com>,
 Emmanuel Grumbach	 <emmanuel.grumbach@intel.com>, Benjamin Berg
 <benjamin.berg@intel.com>,  Anjaneyulu
 <pagadala.yesu.anjaneyulu@intel.com>, Peddolla Harshavardhan Reddy	
 <peddolla.reddy@oss.qualcomm.com>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 John Crispin <john@phrozen.org>, Avinash Patil <patila@marvell.com>, Cathy
 Luo <cluo@marvell.com>, "John W. Linville" <linville@tuxdriver.com>, Aloka
 Dixit <quic_alokad@quicinc.com>
Date: Thu, 23 Jul 2026 10:06:29 +0200
In-Reply-To: <tbjmdwm22yxqcslsgi2pakemlv46fx76uhkwogcn4kfpsbq6hc@yxmlgjwzyoyn> (sfid-20260723_022517_282807_3507ED58)
References: <20260708195911.84365-1-enderaoelyther@gmail.com>
	 <573e7a49f4e9763b0cdb22bb4fc875bca1335c70.camel@sipsolutions.net>
	 <209a011cf5f87881881cd338e1d3ec6baa75bef6.camel@sipsolutions.net>
	 <tbjmdwm22yxqcslsgi2pakemlv46fx76uhkwogcn4kfpsbq6hc@yxmlgjwzyoyn>
	 (sfid-20260723_022517_282807_3507ED58)
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

On Thu, 2026-07-23 at 10:25 +1000, Lachlan Hodges wrote:
> > Also in addition - please resend these, the s1g should go also to
> > Lachlan I think who wrote it, and I don't think anyone is paying
> > attention to this patchset :)
>=20
> The twt stuff has been in for a while and was added by Lorenzo [1].
>=20

Oops, my bad, sorry!

> I'm
> not sure why it sits in the s1g.c file, I assume because it was first
> added to the standard for S1G then expanded to other standards? Might
> be worth moving all these to a separate twt.c file (I can if you think
> it's worth it).

Right, it's the frame format there and all. I guess if I can remember in
the future that not all of the s1g* code is from you, it'll be OK, but
if you don't want to take the risk we can move it ;-)

johannes
