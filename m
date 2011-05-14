Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab1ENIYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 04:24:36 -0400
Subject: Re: mesh RCU issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org
In-Reply-To: <BANLkTinYGGnGoE2jeuAmEYGW7HyBsV2+BA@mail.gmail.com> (sfid-20110514_055323_305661_D0C3EC53)
References: <1305203138.3461.24.camel@jlt3.sipsolutions.net>
	 <BANLkTinDyLyVX3HFHU7i4GFUi8SixOdzAQ@mail.gmail.com>
	 <1305270793.3487.3.camel@jlt3.sipsolutions.net>
	 <BANLkTi=R_Eyz8+iZsk+=Gs4vaNo-0eUVng@mail.gmail.com>
	 <1305331247.680.7.camel@jlt3.sipsolutions.net>
	 <BANLkTinYGGnGoE2jeuAmEYGW7HyBsV2+BA@mail.gmail.com>
	 (sfid-20110514_055323_305661_D0C3EC53)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 10:24:33 +0200
Message-ID: <1305361473.3437.2.camel@jlt3.sipsolutions.net> (sfid-20110514_102441_700883_D0C78FC8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 20:52 -0700, Javier Cardona wrote:

> > With this patch, I get the warnings below.
> 
> Thanks.  Any ideas on how to fix sparse?  I'd like to see those too :)

No, not really, what version are you using? I'm on 64 bit so I don't
have uaccess_32.h included I guess, I suppose you could just go to that
file and comment out the contents of the copy_from_user_overflow()
function that seems to be causing it grief.

> > The locking ones are definitely genuine bugs,
> 
> I'm not sure I fully understand the sparse message... would this fix
> the two locking warnings?
[snip]

Sure, those locking fixes should fix the bugs and get rid of the
warnings unless there was another code path leaving w/o unlock.

johannes

