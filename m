Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:22973 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXJVPeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 11:34:46 -0400
Received: by py-out-1112.google.com with SMTP id u77so2516984pyb
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2007 08:34:45 -0700 (PDT)
Message-ID: <40f31dec0710220834t27dc61d5j289b752487a3e3b9@mail.gmail.com> (sfid-20071022_163452_411334_02CDBD9A)
Date: Mon, 22 Oct 2007 15:34:43 +0000
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 0/2] ath5k: Further cleanups inside base.c
Cc: "Jiri Slaby" <jirislaby@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <43e72e890710220800j3d610b4by58b28598388eb8b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071021012030.GA5817@localhost.domain.invalid>
	 <471AF51E.7050901@gmail.com>
	 <43e72e890710220800j3d610b4by58b28598388eb8b8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/22, Luis R. Rodriguez <mcgrof@gmail.com>:
> On 10/21/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > On 10/21/2007 03:20 AM, Nick Kossifidis wrote:
> > > A few more cleanups for base.c before i submit the rest of my fixes...
> > >
> > > Q: Should we get rid of syctl stuff ? I mean user can only change
> > > calibration interval (which is something tricky for users to play with)
> > > and debug flags. Does anyone use this ? i mean we can put printks wherever
> > > we want, there's no need for this stuff IMHO (it comes from madwifi).
> >
> > Agreed. And if really want it, we can make debug a module_param...
>
> It should be removed, but please use 30 seconds for the calibration
> timer instead of every second. Every second is pretty obsessive
> considering the fact that even though run every second, we don't
> calibrate even if AR5K_PHY_IQ_RUN was set. Most of the times i_coffd
> or q_coffd will be 0, so all we actually do is noise floor
> calibration.
>
>   Luis
>

I didn't change the interval, i just cleaned up the code, as you can
see that value was put there before (through a macro in base.h -i just
removed the macro). Anyway i'll check out calibration stuff more
careful because periodic calibration doesn't seem right if we change
rates etc (we had a discussion on madwifi-devel on this and i'm still
searching it).

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
