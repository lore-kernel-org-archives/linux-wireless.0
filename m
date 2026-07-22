Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4F635677C;
	Wed, 22 Jul 2026 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784731084; cv=none; b=lB/Ub643hRF5FSZhM6/gvyDmS85EOYqhvHMqySoWfFcp384p3WfN4BX+1T1AJbhoxScdyq6mrSPlKuGZ3glZlLFbooDSujZ1eToh5dkOGcZeQdAVv9IKvQyBJnPkwzLkVQdWRNiWskhfGtM8CAVGel6EGTJZi/CjqjSM504oX2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784731084; c=relaxed/simple;
	bh=r8f5eYG9ioT88pmYRHpstHvcoDyxSLck72FFiIgJWjo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GkrONhemRN6Vn+87QvdIdvsZaIJ0ezJU5bOkPNFpdmOxgMSaONmdpPOjDw3uBybkumwBRJNBp0DNQytZ3REB1vbHg/RkbonzScggRoqaYbYeiYadDWWXhLZhWGhwY6aSF1VbYH7AIGYCmyzA2FBbt0E9WA7wOjPb8MJRRle/lX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LTs0MFnn; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LTs0MFnn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=PtnqHHUsJuyHsoYni1AzPj3QObVgRkIeo9oy/UHQTwA=;
	t=1784731082; x=1785940682; b=LTs0MFnnw+xQMmufyge3t3Umzu/ZJTPkClC6w8DordWDrUG
	bseYyphxMeHU9XDtrBfdsAsc05pvnMOYPBjUXkuAVUNHWcxk3UGuzoEIc2/8BotK63LwoWHdVzrlc
	CV4EBUX64+08MZcgl2V3miZ47QtFN8DdN53fC2EkpcT0NSNpvqYS6+LDc5C7kIgOxiodV9LWbV/Di
	wDvowbLNc4VqpzK0ZzU1buD9HupuQvN/kYuyHhx87MK6R6XUsBYtbwI0V+n32TegVar9pbheye2ld
	/93kZBAfq4zJpk5f29IZLctflCZ/R1m44QFE7JXt3IWtw20FKxQeH3/Hf6GXIZYw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmY56-00000004om4-3dVS;
	Wed, 22 Jul 2026 16:37:57 +0200
Message-ID: <209a011cf5f87881881cd338e1d3ec6baa75bef6.camel@sipsolutions.net>
Subject: Re: [PATCH 0/8] wifi: fix PMSR lifetime and frame validation issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miri Korenblit	
 <miriam.rachel.korenblit@intel.com>, Brian Norris
 <briannorris@chromium.org>,  Francesco Dolcini <francesco@dolcini.it>,
 Jaewan Kim <jaewan@google.com>, Daniel Gabay <daniel.gabay@intel.com>, 
 Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Benjamin Berg
 <benjamin.berg@intel.com>, Anjaneyulu	
 <pagadala.yesu.anjaneyulu@intel.com>, Peddolla Harshavardhan Reddy	
 <peddolla.reddy@oss.qualcomm.com>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 John Crispin <john@phrozen.org>, Avinash Patil <patila@marvell.com>, Cathy
 Luo <cluo@marvell.com>, "John W. Linville" <linville@tuxdriver.com>, Aloka
 Dixit <quic_alokad@quicinc.com>
Date: Wed, 22 Jul 2026 16:37:55 +0200
In-Reply-To: <573e7a49f4e9763b0cdb22bb4fc875bca1335c70.camel@sipsolutions.net>
References: <20260708195911.84365-1-enderaoelyther@gmail.com>
		 (sfid-20260708_215930_683827_CD8CF763) <573e7a49f4e9763b0cdb22bb4fc875bca1335c70.camel@sipsolutions.net>
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

On Tue, 2026-07-21 at 18:00 +0200, Johannes Berg wrote:
>=20
> >   wifi: mac80211: validate probe response countdown offsets
>=20
> I think this one is falling into a typical LLM pattern patching trap, it
> describes [0] as being out-of-bounds for some allocated data, and
> neglects that the offsets have already been checked by cfg80211. Please
> describe more why it's actually an issue beyond "there's a similar
> pattern elsewhere".
>=20
> >   wifi: mac80211: validate S1G TWT params before driver setup
>=20
> I don't know about this, you should probably resend it. Anyway I'm not
> loosing sleep over it since there's no driver with the callback, tracing
> is mostly not enabled, and while a potential 12 bytes OOB read at the
> end of the SKB is a bug, it's not a very important one since there
> should be stuff there anyway.
>=20
> >   wifi: mwifiex: validate action frame fixed fields
>=20
> Francesco should look at that - again, sending it all together makes
> this really hard - but it seems to me it should use MIN_ACTION_SIZE()?

Also in addition - please resend these, the s1g should go also to
Lachlan I think who wrote it, and I don't think anyone is paying
attention to this patchset :)

johannes
