Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55722 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab0GNUcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 16:32:45 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jul 2010 13:32:45 -0700
Date: Wed, 14 Jul 2010 13:32:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH] compat-wireless: fix build of ath5k for
 CONFIG_PM_SLEEP=n
Message-ID: <20100714203244.GA20731@tux>
References: <1278879791-12646-1-git-send-email-hauke@hauke-m.de>
 <AANLkTimLweydYTbS-O6Q2sX-W0H5z7cWOLUqQphSTO1s@mail.gmail.com>
 <4C3B6AAE.4070204@redfish-solutions.com>
 <AANLkTilfUKMido8N4vRF4Em7ewtoUAlkrsp1uaKTx6H9@mail.gmail.com>
 <AANLkTilVf_eOMqvYwcz5XrSVFuk3RNLl7SoVOj-6L6Fu@mail.gmail.com>
 <4C3DFDB5.10904@redfish-solutions.com>
 <AANLkTikzEMY_Ya_QY7XkaNv441YxBcJngEoBYJUYJUA1@mail.gmail.com>
 <4C3E1315.5050607@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C3E1315.5050607@redfish-solutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 14, 2010 at 12:42:13PM -0700, Philip A. Prindeville wrote:
> On 07/14/2010 12:33 PM, Luis R. Rodriguez wrote:
> > On Wed, Jul 14, 2010 at 11:11 AM, Philip A. Prindeville
> > <philipp_subx@redfish-solutions.com> wrote:
> >> On 07/13/2010 04:44 PM, Luis R. Rodriguez wrote:
> >>> On Tue, Jul 13, 2010 at 2:54 PM, Luis R. Rodriguez
> >>> <lrodriguez@atheros.com> wrote:
> >>>> On Mon, Jul 12, 2010 at 12:19 PM, Philip A. Prindeville
> >>>> <philipp_subx@redfish-solutions.com> wrote:
> >>>>> On 07/12/2010 09:30 AM, Luis R. Rodriguez wrote:
> >>>>>> On Sun, Jul 11, 2010 at 1:23 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> >>>>>>> suspend and resume are activated in ath5k if CONFIG_PM_SLEEP is set and
> >>>>>>> not if just CONFIG_PM is set.
> >>>>>>>
> >>>>>>> This should fix the problems reported by Philip Prindeville.
> >>>>>>>
> >>>>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> >>>>>>
> >>>>>> Thanks! Applied and pushed out, at noon we'll have a new tarball with this.
> >>>>>>
> >>>>>>   Luis
> >>>>>
> >>>>> And...
> >>>>>
> >>>>>
> >>>>>  CC [M]  /home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth/l2cap.o
> >>>>> /home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth/l2cap.c: In function 'l2cap_data_channel':
> >>>>> /home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth/l2cap.c:4352: error: void value not ignored as it ought to be
> >>>>> make[4]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth/l2cap.o] Error 1
> >>>>> make[3]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth] Error 2
> >>>>> make[2]: *** [_module_/home/philipp/kernel/build_i586/compat-wireless-2010-07-12] Error 2
> >>>>> make[2]: Leaving directory `/home/philipp/kernel/build_i586/linux-2.6.27.48-astlinux'
> >>>>> make[1]: *** [modules] Error 2
> >>>>> make[1]: Leaving directory `/home/philipp/kernel/build_i586/compat-wireless-2010-07-12'
> >>>>> make: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/wireless/lib80211.ko] Error 2
> >>>>
> >>>> Thanks for reporting this, I am working on it now.
> >>>
> >>> This is now fixed, I'll push out a new tarball shortly.
> >>>
> >>>   Luis
> >>
> >> That tarball never made it out...  can you please retry?
> > 
> > The cronjob kicks off at noon PST time.
> > 
> >   Luis
> 
> Just picked up the tarball:
> 
> /home/philipp/kernel/build_i586/compat-wireless-2010-07-14/drivers/net/wireless/rt2x00/rt2x00pci.c: In function 'rt2x00pci_initialize':
> /home/philipp/kernel/build_i586/compat-wireless-2010-07-14/drivers/net/wireless/rt2x00/rt2x00pci.c:156: error: implicit declaration of function 'request_threaded_irq'
> make[5]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-14/drivers/net/wireless/rt2x00/rt2x00pci.o] Error 1
> make[4]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-14/drivers/net/wireless/rt2x00] Error 2
> make[4]: *** Waiting for unfinished jobs....
> 
> 
> I'm thinking that it might be good to have a variety of nightly builds to detect damage.  Do you all have infrastructure for that?

Yeah, feel free to send patches against this to enable that:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-user.git

Otherwise I'll get to it when I can.

> This is building against 2.6.27.48

Hauke pointed out threaded ISR stuff needs to be done as was done with b43.
 
 Luis
