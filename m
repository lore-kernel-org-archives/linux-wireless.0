Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658Ab1HSUop (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 16:44:45 -0400
Subject: Re: brcmsmac driver only works when sitting next to the AP
From: Dan Williams <dcbw@redhat.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Date: Fri, 19 Aug 2011 15:47:02 -0500
In-Reply-To: <4E4E73F4.4040105@broadcom.com>
References: <20110814121646.GA5188@stt008.linux.site>
	 <4E4A5641.4020604@broadcom.com> <1313509211.2065.36.camel@dcbw.foobar.com>
	 <4E4B9A45.5090507@broadcom.com> <4E4CC85A.7010504@broadcom.com>
	 <4E4E73F4.4040105@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1313786823.4810.13.camel@dcbw.foobar.com> (sfid-20110819_224449_168257_FC0F8124)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-08-19 at 16:32 +0200, Roland Vossen wrote:
> > Hello Dan,
> >
> > can you reply ?
> 
> So much for responsiveness.

Because I work on networking software, I am not online 24/7 and do not
always respond to email every day.  If I'm in the middle of fixing up
some large changes or (in this case, debugging dbus permissions issues
with VPN plugins that requires a lot or rebuild/reboot cycles) I may not
check email until later in the day, and then other mails might require
faster replies.  I do not channel work email to a Blackberry.  Chill
out.

The error about supplicant manager state is not important, as the
supplicant later transitions to idle/ready state and NM proceeds.  What
*is* important is the inability of the driver to perform scans, which
means that no scan list is available for the supplicant to work with,
and thus it cannot associate with any known AP.  What we want now is
driver debugging information about *why* the driver refuses to perform
scans.

Dan

> Camaleon, would you be able to provide additional logs as requested in 
> one of my previous mails ?
> 
> Thanks, Roland.
> 
> >
> > Thanks, Roland.
> >
> > On 08/17/2011 12:39 PM, Roland Vossen wrote:
> >>>> 'Aug 14 13:39:02 stt300 NetworkManager[1181]:
> >>>> supplicant_interface_acquire: assertion `mgr_state ==
> >>>> NM_SUPPLICANT_MANAGER_STATE_IDLE' failed'
> >>>>
> >>>> I also see many 'wpa_supplicant[1204]: Failed to initiate AP scan' messages.
> >>>>
> >>>> There are no 'Failed to initiate AP scan' messages before the 'assertion
> >>>> failed' message. I do not know if the 2nd message is a byproduct of the
> >>>> 1st result. Regardless, a failed assertion is serious. I cc'ed the
> >>>> network manager mailing list.
> >>
> >>> Yeah, the scanning issues are almost certainly what's causing stuff to
> >>> fail; which obviously seems like a driver issue at this point.
> >>
> >> Well, the 1st sign that something goes wrong is the assert message in
> >> NetworkManager. After that, the scans are the next things that go wrong.
> >> So I don't understand why you think that this is a driver problem, I
> >> would rather say this is a Network manager problem. Could you explain ?
> >>
> >> Thanks, Roland.
> >
> 
> 


