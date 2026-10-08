Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A18423A66;
	Thu,  8 Oct 2026 07:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791445497; cv=none; b=C9C0Wm8kM5FSa5bvMyqk4FmPavq1wHnu2f4ZQJ0HcbQR92d0SvjtJ3NXR7tNg5cnZPqySvdBSgvpg76Gjv9rZsnuyjPKYwtZVDyn+VLKeeYuwxSP2i+XPyiARrQnoVrYnu/dzCubNM8pHe7A9Aa5s63Jux9ZcM3HbjRyDN87EHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791445497; c=relaxed/simple;
	bh=SX8aHBZ+Jvm6rjNABPl//Et/ydQ+AprwhtNg3ayxDFM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tDBkODA0fCy6FxLf5uZwAJbyPYa4tTdtKbCe2Ti2Os5byHH860BnlUeXAnL5vyc4PpwNO61sdjNi8vP/Aw0L21fcC0MBCGm8xNTOS0s6lchub/iMhleWUkfIiENxd8PfHhdeDCp5Tz2MPxCVQLI7er5kuHA85qlgl+EfAG0WS2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fTtjHnj7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fTtjHnj7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=RAFFMHXt9hKqc6DeNIeiFUmCqfwK92D95q9EzUKD8ns=;
	t=1791445493; x=1792655093; b=fTtjHnj7tRQ1b//azj+cLa6f6XdxR3GAw/FmIcOSuy+GQc7
	sMthauipDJswEjzTLacGpw7bUzd+3wdbJMTx9RAsBQKh1rRWmMDXh2Cpv6fwzWjtQfoi03H5JQg5a
	HWJmWYOwRNN++coZeAdFzHQ+Pbajk8GD9uCYACFgDZiazi0VKz9Mpfv2lr8lAkQvt5inJlHv4ZL71
	jPB03jllmlP5VMXiNpVB0OBbHTFB2igCDt6CuXQKNCBWnTaJt2w62lG3rixa0ikPNjWwAK7bVy992
	39UuvnPxYLoTvV8011VEO1h3K15nrhZ1sMwgd/XO7fVC7QtCe+Rch47nO3kJ4BSA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xEio6-000000099KQ-11jF;
	Thu, 08 Oct 2026 09:44:50 +0200
Message-ID: <2688563455012eb80063ae014f78230b10a14710.camel@sipsolutions.net>
Subject: Re: [GIT PULL] wireless-next-2026-10-07
From: Johannes Berg <johannes@sipsolutions.net>
To: Kuniyuki Iwashima <kuniyu@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 08 Oct 2026 09:44:49 +0200
In-Reply-To: <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com> (sfid-20261008_040528_485050_028310B5)
References: <20261007205827.467974-3-johannes@sipsolutions.net>
	 <20261007163616.1088d364@kernel.org>
	 <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com>
	 (sfid-20261008_040528_485050_028310B5)
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

Hi Kuniyuki,

On Wed, 2026-10-07 at 19:05 -0700, Kuniyuki Iwashima wrote:
> On Wed, Oct 7, 2026 at 4:36=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
> >=20
> > On Wed,  7 Oct 2026 22:57:00 +0200 Johannes Berg wrote:
> > > Nothing much going on in wireless-next. However, next time
> > > I hope to land my RTNL-redux series which will (almost)
> > > completely wean the wireless stack off the RTNL, except in
> > > places where we need it for netdev register/unregister/etc.
>=20
> That's great !
>=20
> We saw a wifi driver holding RTNL long on Android.

Well, _that_ mostly shouldn't have happened for a long time (since
5.12), though I actually learned yesterday that some android drivers
went to implement things with private ioctls because they (thought they)
needed the RTNL ... so, Android, take with a bag of salt.

> Also, I hope we could remove the long comment in __rtnl_unlock().

Couldn't we remove that today, by just __rtnl_unlock() in that place in
cfg80211? But it's not exported, for good reason, presumably.

But that's also irrelevant, because indeed after my patchset cfg80211
doesn't do that any more:
https://lore.kernel.org/linux-wireless/20261006100655.2687533-21-johannes@s=
ipsolutions.net/

> > > I need to see what's going on with the per-netns mutex now,
> > > can we already use that instead?
>=20
> Do you mean moving net->rtnl_mutex out of Kconfig ?

I have no idea what I'm talking about ;-)

> Recently, I've been converting the first-class rtnetlink handlers
> with dedicated locks, but others not worth the effort will simply
> replace rtnl_lock() with rtnl_net_lock().
>=20
> rtnl_net_lock() still acquires rtnl_lock(), but if we always compile
> net->rtnl_mutex, using __rtnl_net_lock() for the latter should be
> okay.

OK so I (likely naively) thought the idea was that most things like
netdev registration/unregistration eventually move to rtnl_net_lock()?
Here are the places that still take RTNL in wifi after the patchset
above:

 - suspend/resume (not entirely sure - it goes to hw restart maybe)
 - hw restart (can unregister netdevs on failures)
 - rate control init in mac80211 (but that can be removed easily)
 - netdev registration
 - netdev unregistration
 - rfkill, to call dev_close()
 - wiphy registration/unregistration (might be possible to disentangle
   now)
 - network namespace destruction/exit
 - wiphy naming, but that can move to cfg80211_mtx now
 - some netlink dumps (related to the naming?)
 - testmode/vendor ... I guess we can't get rid of that,
   but no upstream drivers should have much here
 - interface/wdev start/stop
 - netns moves

(and a couple of places I should just fix).

So mostly that's relatively short-lived (like the wiphy naming stuff) or
related to network/netns maintenance where I'm not sure.

Thanks!

johannes

>=20
>=20
> >=20
> > That's a Kuniyuki question (cced). I've been trying to move
> > HW drivers out of rtnl_lock and under netdev->lock.
> > Most of the rtnl_lock contention I've seen in prod at Meta
> > is in init_net
>=20
> FWIW, I've still seen contention while creating/removing containers.
