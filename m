Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:51310 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZHZQ5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 12:57:08 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
Date: Wed, 26 Aug 2009 13:57:09 -0300
Cc: Johannes Berg <johannes@sipsolutions.net>,
	htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <850984.89698.qm@web23108.mail.ird.yahoo.com> <1251297273.15619.11.camel@johannes.local> <3ace41890908260807t736848d8x57dff6cf3ac581c6@mail.gmail.com>
In-Reply-To: <3ace41890908260807t736848d8x57dff6cf3ac581c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908261357.09425.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Qua 26 Ago 2009, às 12:07:52, Hin-Tak Leung escreveu:
> On Wed, Aug 26, 2009 at 3:34 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> > On Wed, 2009-08-26 at 13:33 +0000, Hin-Tak Leung wrote:
> >
> >> > Or wait ... are you using compat-wireless?
> >>
> >> Yes, I am. I mentioned this and did wonder if the _backport/ part
> >> in /sys/class is important.
> >
> > Sorry, didn't see.
> >
> > Anyway, that's pretty clearly the reason -- Luis added NETDEV_PRE_UP to
> > some compat*.h but obviously the kernel won't ever call that notifier,
> > so cfg80211 doesn't get a chance to reject the IFUP. No idea how to
> > handle that -- it'll be working fine in a regular tree.
> >
> > Luis, the only way to handle that would be to manually call the PRE_UP
> > notifier from mac80211's subif_open() and if that returns an error
> > (warning: the calling convention is weird) return the error... that's
> > weird but would work.
> 
> Okay, that explains it. So I can have a Tested-by: ... I just grep for

Ok, I submitted now the patches.

> NETDEV_PRE_UP in compat-wireless and it is only in
> include/net/compat-2.6.31.h (not in 2.6.30) and I am on 2.6.30.5-X . I
> can grab the rawhide 2.6.31 rpms and try it quickly;
> and possibly look at some ugly quick hack backport that? Stay tuned.
> 
> Thanks for the help.
> 
> Hin-Tak
> 

--
[]'s
Herton
