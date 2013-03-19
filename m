Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933287Ab3CSQwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 12:52:30 -0400
Message-ID: <1363711989.2225.8.camel@dcbw.foobar.com> (sfid-20130319_175239_144384_576D7FF2)
Subject: Re: Brcmsmac driver woes, possible regression?
From: Dan Williams <dcbw@redhat.com>
To: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	664767@bugs.debian.org, linux-wireless@vger.kernel.org
Date: Tue, 19 Mar 2013 11:53:09 -0500
In-Reply-To: <CAKprTDEddPVp+bk7RJX1Jk60b0zVHr4ghvqt0HKnY+h238t3Zw@mail.gmail.com>
References: <20130317144603.GA4850@stt008.linux.site>
	 <1363532310.3937.266.camel@deadeye.wl.decadent.org.uk>
	 <20130317152428.GA4940@stt008.linux.site>
	 <20130317175658.GA8181@elie.Belkin>
	 <20130317182725.GA5811@stt008.linux.site>
	 <20130317183344.GA8786@elie.Belkin>
	 <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com>
	 <20130318083752.GA6570@elie.Belkin> <51476D25.6030609@broadcom.com>
	 <20130318211428.GA9136@stt008.linux.site>
	 <20130318212544.GB5062@elie.Belkin>
	 <CAKprTDFXV4J7cxGqNck95Cu=ncBXCfdNTir40aWRtXjpLPO6OQ@mail.gmail.com>
	 <CAKprTDEddPVp+bk7RJX1Jk60b0zVHr4ghvqt0HKnY+h238t3Zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 17:21 +0100, Camaleón wrote:
> 2013/3/19 Camaleón <noelamac@gmail.com>:
> > 2013/3/18 Jonathan Nieder <jrnieder@gmail.com>:
> >> Camaleón wrote:
> >>> El 2013-03-18 a las 20:38 +0100, Arend van Spriel escribió:
> >>
> >>>> Sorry to hear. Reading back the bug report I noticed you are having a
> >>>> bcm4313 and we recently had a regression on it. Could you provide
> >>>> debugfs information from <debugfs_mount>/brcmsmac/bcma0:0/hardware
> >>>
> >>> I see. My "/sys/kernel/debug/*" directory is empty
> >>
> >> mount -t debugfs debugfs /sys/kernel/debug
> >
> > Perfect, thanks.
> >
> > root@stt300:~# cat /sys/kernel/debug/brcmsmac/bcma0\:0/hardware
> > board vendor: 103c
> > board type: 145c
> > board revision: 2209
> > board flags: 8002a00
> > board flags2: 800
> > firmware revision: 262032b
> >
> > Now let's see how reverting the patch makes any difference as soon as
> > I can compile the module. I will keep you updated
> 
> Update: applied the patch to revert the "other" patch but I still
> cannot get the driver to work (see attached syslog). N-M still asks
> for password until desists :-(

Note that NM 0.9.8 won't ask for a password when just anything fails,
but will ask for a password if the 4-way handshake fails, because if
that fails, it's probably your password.  We're contemplating getting
rid of that too, and just notifying the user that their password may be
wrong and that they should go update it in the network configuration
panel so we don't interrupt.  But if you're 100% sure your PSK is
correct, then it is, most likely, a driver bug.

Dan

