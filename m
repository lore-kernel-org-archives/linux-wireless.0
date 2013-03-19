Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43963 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3CSRbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 13:31:00 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi8so808919wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 10:30:59 -0700 (PDT)
Date: Tue, 19 Mar 2013 18:30:54 +0100
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	664767@bugs.debian.org, linux-wireless@vger.kernel.org
Subject: Re: Brcmsmac driver woes, possible regression?
Message-ID: <20130319173054.GA7873@stt008.linux.site> (sfid-20130319_183106_662626_5E440771)
References: <20130317182725.GA5811@stt008.linux.site> <20130317183344.GA8786@elie.Belkin> <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com> <20130318083752.GA6570@elie.Belkin> <51476D25.6030609@broadcom.com> <20130318211428.GA9136@stt008.linux.site> <20130318212544.GB5062@elie.Belkin> <CAKprTDFXV4J7cxGqNck95Cu=ncBXCfdNTir40aWRtXjpLPO6OQ@mail.gmail.com> <CAKprTDEddPVp+bk7RJX1Jk60b0zVHr4ghvqt0HKnY+h238t3Zw@mail.gmail.com> <1363711989.2225.8.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363711989.2225.8.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 2013-03-19 a las 11:53 -0500, Dan Williams escribió:

> On Tue, 2013-03-19 at 17:21 +0100, Camaleón wrote:
> > 2013/3/19 Camaleón <noelamac@gmail.com>:
> > > 2013/3/18 Jonathan Nieder <jrnieder@gmail.com>:
> > >> Camaleón wrote:
> > >>> El 2013-03-18 a las 20:38 +0100, Arend van Spriel escribió:
> > >>
> > >>>> Sorry to hear. Reading back the bug report I noticed you are having a
> > >>>> bcm4313 and we recently had a regression on it. Could you provide
> > >>>> debugfs information from <debugfs_mount>/brcmsmac/bcma0:0/hardware
> > >>>
> > >>> I see. My "/sys/kernel/debug/*" directory is empty
> > >>
> > >> mount -t debugfs debugfs /sys/kernel/debug
> > >
> > > Perfect, thanks.
> > >
> > > root@stt300:~# cat /sys/kernel/debug/brcmsmac/bcma0\:0/hardware
> > > board vendor: 103c
> > > board type: 145c
> > > board revision: 2209
> > > board flags: 8002a00
> > > board flags2: 800
> > > firmware revision: 262032b
> > >
> > > Now let's see how reverting the patch makes any difference as soon as
> > > I can compile the module. I will keep you updated
> > 
> > Update: applied the patch to revert the "other" patch but I still
> > cannot get the driver to work (see attached syslog). N-M still asks
> > for password until desists :-(
> 
> Note that NM 0.9.8 won't ask for a password when just anything fails,
> but will ask for a password if the 4-way handshake fails, because if
> that fails, it's probably your password.  We're contemplating getting
> rid of that too, and just notifying the user that their password may be
> wrong and that they should go update it in the network configuration
> panel so we don't interrupt.  But if you're 100% sure your PSK is
> correct, then it is, most likely, a driver bug.

Password is correct. I have a second wireless card (external, using 
rt2800usb driver) that connects without a glitch to the same AP.

Moreover, unless I type the right password, N-M dialog does not allow 
me to click on the "Connect" button.

Greetings,

-- 
Camaleón 
