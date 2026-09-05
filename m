Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99A839902B;
	Sat,  5 Sep 2026 06:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788588921; cv=none; b=oYqKy6E8xaspXaViR+euqdi5VTrrNXr26Bm013Ny9T1lST6t86cGpHvxoyxmQraszF4FKbL9zHTeNplQy/PrFO0woRISvynplc9GByvrGG+IODUh4tZyVeKgSD6nq3v7G7XKGRBv956ABd98m21JiehhZFDeV6kAA9uxqFogRIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788588921; c=relaxed/simple;
	bh=0PE2nVJEfLd+eGJIsDNB7qnEJvVfkDaVwCZbyEIv80M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gxsy35mVm7CnUOqmrNI7BRalQ4O4HfeBM7rX3s9VUhfIkPQ5goM0KhWXwAn3+jplvEXMt1VCbg2TDYHFKFtXC3KSRh3PBhe8NVAF6iB0SpW4mM8riwnQCTzYxV18358D8M19qxKhTiAubThsyCLZ7ULbtFr5eFqFgjgLDttOU2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=s3P4geiT; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="s3P4geiT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=0PE2nVJEfLd+eGJIsDNB7qnEJvVfkDaVwCZbyEIv80M=;
	t=1788588917; x=1789798517; b=s3P4geiT9fzS+dU2HE0zTI1+IqDYMU6keOqOWmSj7Fj5U2a
	bC6+dZXNJsgsTo+0GOIFpDQp1JhY25r8WsFyI3RbPmUGedJiWYgvpyt7XKuc+TmvxKTsZPxXh6Zyb
	/7+VV15Fm3UQ1HGUmf49nIZxzN4A+XKeBoCUYlAnj61rSV4YYzgRXA3bcNmH+USmA/ZX6FDquynJM
	ILR5QkTybA+Q2p7djbJ4UZl+PRXIMu4TfHsf+GBlK7sT/LkJID27e+3dWK4DejGTzTANukEIcRmLA
	L5KLehQ98fnPiN4nfjwFleM+IdovDjLW/PITScv8sJ3uHwek4ekLZgVlTWRJottg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2jgB-00000002B0b-0Qjr;
	Sat, 05 Sep 2026 08:15:07 +0200
Message-ID: <9d91e1719383f8ba6dfc45650a92b1f2c2bc2f6b.camel@sipsolutions.net>
Subject: Re: [PATCHv2 wireless] mac80211: stop tpt LED trigger timer before
 freeing trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, "John W. Linville"
 <linville@tuxdriver.com>,  open list <linux-kernel@vger.kernel.org>
Date: Sat, 05 Sep 2026 08:15:06 +0200
In-Reply-To: <CAKxU2N9ZPRSotiPhayrQFyzbf=sPcU7X3o6ozRECOibhCj_kbA@mail.gmail.com> (sfid-20260904_211629_075221_49F57F20)
References: <20260815190724.16943-1-rosenp@gmail.com>
	 <12f4b21bb334a49c88bf28428b92589adecfa53a.camel@sipsolutions.net>
	 <CAKxU2N9ZPRSotiPhayrQFyzbf=sPcU7X3o6ozRECOibhCj_kbA@mail.gmail.com>
	 (sfid-20260904_211629_075221_49F57F20)
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

On Fri, 2026-09-04 at 12:16 -0700, Rosen Penev wrote:
> On Fri, Sep 4, 2026 at 12:41=E2=80=AFAM Johannes Berg <johannes@sipsoluti=
ons.net> wrote:
> >=20
> > On Sat, 2026-08-15 at 12:07 -0700, Rosen Penev wrote:
> > > On a hot unplug, the device is torn down
> > > through ieee80211_unregister_hw() without ever going through
> > > ieee80211_do_stop(), so the timer is never stopped.
> >=20
> > I don't buy this.
> >=20
> > Also, missed wifi: prefix.
> >=20
> > Please don't just feed me LLM garbage. Do you have a crash reported on
> > this?
> Not formally no. However I am able to reliably panic the kernel. After
> this patch I can't.

Then you can probably enable debug objects etc. to figure out why?

I don't think this patch really fixes the cause, just the symptom.

Maybe it's related to this:
https://lore.kernel.org/linux-wireless/20260904165722.044aa432f873.I601a67a=
2cd558b8ef8416a07554ae7efe896e9d8@changeid/

johannes
