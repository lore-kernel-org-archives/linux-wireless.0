Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EA0355819
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2026 06:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777359021; cv=none; b=Kx/fHi6ql4BZEwoL5F6iz/M3p3499BaLxzKiSN/P5jck2fu2xzJBm4eV1PXjyJShz+gNjGyLSVMowc/IkBnW/eF8nN965dPlFj0A1y+cjbfpI15/mN+23mHy78GlcnEnx0kI50SYAZ85kkvbgjS6H1zEMB9TC9qK4WlBcoSInW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777359021; c=relaxed/simple;
	bh=F2w6wQmy1BuNqwq743tLBMyoShzhf8mDASeU4vdRSQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D9FS6wMmBsSXiGkr53TADpxtXQFf/drib6j3iOJeTt+cB9E11ZOYr9anghaniJPUv7KI3kkVcU6rPXqZyRWdnZmvx1WEuNBRsYAY5uWHQyqG/CeSMrXQ7paJeAK9ULNAnvpZIwKIUajkNkobb98tkeUGLzaZzM0zfhbrxeatt3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=j2/zrM6J; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="j2/zrM6J"
Received: (wp-smtpd smtp.wp.pl 15079 invoked from network); 28 Apr 2026 08:50:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1777359010; bh=1tz8oD4U/nL5B8QqqSDWmplbEM2dwJZNXHu2f++SUU0=;
          h=From:To:Cc:Subject;
          b=j2/zrM6J/R/rQcD4UhLIpbJShwozBzSH8b/R6NPAauQgqsR0IsMBp2RCTD8Nv3LN/
           iFGub8sVd890Sf2556/1dfCy2u93FL4K0r96CduE5zxMnalTcYTwGwjuKwGdb98CnP
           tJOK4FTqrgl8PK3S+DWaVFnDxTXGzR5/rE825WI3czzvgmFDmgsrKnwFJqomk6aAWr
           oxXO85EZYT0hQA/BRt870D6ZoNAyqZemV+u/vz7bCxsLkvL4gH8+vK2PC062dj/7jp
           TZtbqkVHTc9Uo5uLSwUj0rLvw5rvxxiF7rLZrV0uwSqqVAHaHM5BHox/7gBUrmXJez
           J5tfReIiDBL9Q==
Received: from 77-236-11-114.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.11.114])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <rosenp@gmail.com>; 28 Apr 2026 08:50:10 +0200
Date: Tue, 28 Apr 2026 08:50:09 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Rosen Penev <rosenp@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless-next] wifi: rt2x00: check for of_get_mac_address
 error
Message-ID: <20260428065009.GA5454@wp.pl>
References: <20260427051652.954059-1-rosenp@gmail.com>
 <20260427073206.GA2096@wp.pl>
 <c2263e4917557cb1e07a56c3bfb9a0507bf81f00.camel@sipsolutions.net>
 <20260427105445.GA2620@wp.pl>
 <CAKxU2N_bGO-FBgutLyxLW=E1ZroONnT6FjKBj5hRiB2K6P6KDg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKxU2N_bGO-FBgutLyxLW=E1ZroONnT6FjKBj5hRiB2K6P6KDg@mail.gmail.com>
X-WP-MailID: 2951b2a802ab5f8610f9043c2b9a629a
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [gYIB]                               

On Mon, Apr 27, 2026 at 12:29:08PM -0700, Rosen Penev wrote:
> On Mon, Apr 27, 2026 at 3:54 AM Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> >
> > On Mon, Apr 27, 2026 at 12:45:14PM +0200, Johannes Berg wrote:
> > > On Mon, 2026-04-27 at 09:32 +0200, Stanislaw Gruszka wrote:
> > > > On Sun, Apr 26, 2026 at 10:16:52PM -0700, Rosen Penev wrote:
> > > > > is_valid_ether_addr is already a check of of_get_mac_address, in which
> > > > > case it returns an error if false. Just set a random MAC on all errors
> > > > > except for EPROBE_DEFER.
> > > > >
> > > > > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > > > Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
> > >
> > > Are you sure? I just randomly checked one caller to see what the
> > > *eeprom_mac_addr would contain, and I see
> > >
> > >         mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
> > >         rt2x00lib_set_mac_address(rt2x00dev, mac);
> > >
> > > so that case assumes it can get it from EEPROM and override with OF, but
> > > if OF fails then it would still use the EEPROM address as long as it's
> > > valid ...
> >
> > You have right, please drop the patch.
> >
> > BTW, the code should be changed to move getting the address from OF
> > out of _set routine.
> Where should it go?

Never mind, I got confused by "set" word in the rt2x00lib_set_mac_address().

Regards
Stanislaw
