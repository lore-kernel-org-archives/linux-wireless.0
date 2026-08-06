Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22BA479897;
	Thu,  6 Aug 2026 14:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027796; cv=none; b=tM4mbeEZsHTAMS0LEiX6s2S0fQ6QYMpwemdpRiPCbEZYiK70bJaX3CG0gACAEiwnLs+AA1m17mfyQ4SOFiFU21UA76qlEvk3vmz1kyxazqdShR5HvW9qUjSlarWwehqoY1dHZF+q6XqZZ4iE6Aznq+SYPgaf65LUVtjH2Wf8dDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027796; c=relaxed/simple;
	bh=9A4kNYJ+OPQWURMkmJmD/xejOeQ0Mt7S6vGtMcOcM8g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IKMKAp4DoWBv8Hi1fyG2PIQq1aA4ZckZTdv1B7Wbr8iRzKll+e700Kci1MLP6JEwhegHUgB0W8czcdquO40RskFuN7dvWrCsb3IPWTT32AXsiUcsI1+9zflSkaWzK8SC4/8nmFCCAIVkp0luc3e3BpmliBkOg7hd2/3ZefLAfY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=GoulDxPa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="GoulDxPa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9A4kNYJ+OPQWURMkmJmD/xejOeQ0Mt7S6vGtMcOcM8g=;
	t=1786027793; x=1787237393; b=GoulDxPaySwG664ao8DPwoQGVK1JJ0brMLSi8gBqMui9Gcw
	nO7xFnZeAGql6TeQxW7eBp2CFjLVpFRskkqXe2yNNuhYyVuvsUacjPnf3PK6XGhvHE5rBxK60fBsQ
	ycOdyhSXOqT6/zUySHjyg4C3KYBt91vLNvRVg0zVm2TwdNlSUoOC9t9QOmgTXCe+S6hXUGj34R5/r
	dYC1AIxDk8G2gvEP8Ke9IWIIKFD2W85n3fObOM2raqGS5iH62uX6gDwRPK5MrrbDW35LN3/2ZudHM
	FYa9lyy9ZzifInsX5sGDGldxvTFucpcLZjL7viZKT12wpYbdUBY9NhtSRz++Cgrw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wrzPm-00000009EPO-2YzA;
	Thu, 06 Aug 2026 16:49:46 +0200
Message-ID: <8a0020fb5318ed645b0331d3790a75f83c0ee443.camel@sipsolutions.net>
Subject: Re: sysbot AI patches and wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: Aleksandr Nogikh <nogikh@google.com>, syzbot <syzbot@kernel.org>, 
	syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, Krystian Kaniewski
	 <krystianmkaniewski@gmail.com>
Date: Thu, 06 Aug 2026 16:49:45 +0200
In-Reply-To: <anRyTtgRT8gVUZYR@nr200>
References: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org>
	 <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
	 <CANp29Y6sHOe5QY6BgzeUtKFGqc2pDyP8WAUzQ6E1-3oYgZTY0g@mail.gmail.com>
	 <6007f37089d14eb14deed54d34921f0ef691e1fa.camel@sipsolutions.net>
	 <anRyTtgRT8gVUZYR@nr200>
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

Hi Slawomir,

> > But I really cannot make that judgement call myself for every single
> > issue like that, if I could, see above, I could be doing all of this
> > myself. Need the contributors to do that. Slawomir did that after I
> > prompted (pun intended!) him to do that, and it didn't work out so well
>=20
> It didn't? Or it did? :)

Sorry, indeed, it *did* - thank you.

> Well I do not have new version of the patch yet, but I'm still
> investigating correct approach and testing a lot. I see now, that I shoul=
d do that in the 1st place.
> I'm sorry for that.

No worries.

This in just after our exchange here:

https://lore.kernel.org/ksummit/87y0ekm9nw.fsf@trenco.lwn.net/

It's definitely part of the job to train new contributors, and it's
actually very rewarding to see someone grow from first time contributor.
Sadly, now there's basically no "first-contact signal" that says "I care
about this more than landing this one patch". :-/ Getting a well-formed
(and well-argued) patch used to be worth something, now it's basically
not.

See also Dan's "pair programming" reply.

But I see the other side too; my first patch to the kernel, more than
two decades ago, was a similar thing, though argued first over IRC.
People need a support community to start out anywhere.

Also, I think with patches part of the issue is that there's an implicit
assumption that it'll get reviewed/merged/etc. - but as a submitter you
don't really have anyone to ask questions about that patch and process
before sending (unless you were hired into a Linux team or something).

I obviously don't have a solution to this - I'm just honestly stating
that it doesn't scale for me as the maintainer to be providing this,
certainly not in the format that syzbot's patch-as-a-service encourages,
but more generally also not. A few new folks per year is fine, a few per
month can't work.

Some people hang out on IRC (#linux-wireless, myself too), some people
build experience in other communities like OpenWRT first (or just remain
there), etc. Part of the issue is that we haven't _really_ documented
any of this as the wireless or even broader kernel community, but things
also shift frequently anyway. Another part is - not saying that's the
case for you - that some people just don't care and all they want is
land patches, so they'll go across subsystems, never learn one, and just
hope something sticks somewhere.

Meanwhile, I hope you're not too discouraged by all this, again, sorry
you got caught in the cross-fire here. (I'm going to be on vacation, we
can pick up the thread about your specific patches in September.)

johannes
