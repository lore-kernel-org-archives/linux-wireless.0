Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:35554 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab0A1N6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 08:58:04 -0500
From: Kel Modderman <kel@otaku42.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Bug: 2.6.32 ath5k, unable to connect to AP on channel 13
Date: Thu, 28 Jan 2010 23:27:04 +1000
Cc: Kalle Valo <kalle.valo@iki.fi>,
	=?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John S. Skogtvedt" <jss@bzz.no>, linux-wireless@vger.kernel.org
References: <4B5CB7AB.7010105@bzz.no> <87bpghnp4v.fsf@purkki.valot.fi> <43e72e891001261106w493225c2g6e9a5ff0ef9e41de@mail.gmail.com>
In-Reply-To: <43e72e891001261106w493225c2g6e9a5ff0ef9e41de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201001282327.04853.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Luis,

On Wednesday 27 January 2010 05:06:11 Luis R. Rodriguez wrote:
> On Tue, Jan 26, 2010 at 2:20 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> > "Luis R. Rodriguez" <lrodriguez@atheros.com> writes:
> >
> >>> However, does the DK regdomain really get set? Is CRDA installed?
> >>>
> >>>> CCed Luis in case he has anything to add.
> >>
> >> Yea not sure if debian ships crda and wireless-regdb yet.
> >
> > I'm running debian unstable and haven't seen crda yet.
> 
> Kel, curious if you might be aware of the debian's packaging status of
> CRDA and wireless-regdb.

Yeah, I am reluctantly aware. My life circumstances have been turbulent
recently (eg. moving overseas and back again, work etc.) so I've been moving
very slow on the packaging-wireless-stuff-for-Debian front, as you observed
already. In my defense, I have never declared my intent to package this stuff
in Debian exactly so I would not stop anyone else going ahead and doing just
that, nobody has done anything afaik :(

To top off the story, I am not a Debian Developer and thus am not trusted to
introduce or update software in the archive without the help of mentors. This
is why the pkg-wpa-devel group was formed with 4 members. 1 just declared he
will no longer participate due to change in interests, 1 went MIA over a year
or two ago, and the other one never had any interest in working much on stuff,
just uploading hostapd to the archive once or twice a year. I've had little
time to seek help from others, and in the past I already sought help and noone
I asked gave a crap. So, maybe I'm not the best candidate to get this software
and associated changes into Debian.

Having said all that, I found time to package and test crda/wireless-regdb
on my travels and here is a summary:

wireless-regdb
--------------
Vcs-Svn: svn://svn.debian.org/pkg-wpa/wireless-regdb/trunk
Vcs-Browser: http://svn.debian.org/wsvn/pkg-wpa/wireless-regdb/trunk/
* contains patch to use two argument db2bin.py command and thus not signing
  regulatory.bin - which will no doubt disappoint you. I cannot for the life
  of me fathom how we can manage to sanely manage upload of a source package
  to a bunch of other hosts to be built (arch buildd's) and still manage to
  sign each binary with a private key. Don't sign it, and I cannot see any
  problems from the logistical point of view, but then I begin to think about
  legal consequences of distributing a crda binary which will read any unsigned
  regulatory data it is given. Need to send this patch to you.
  (not sure that runtime reading of pem pubsert helps with this much at all,
  while that is a nice new feature.)
* a friend sent me some patches to enhance the package a bit, still sitting
  in my inbox

[0] http://svn.debian.org/wsvn/pkg-wpa/wireless-regdb/trunk/debian/patches/disable_pubkeys.patch

crda
----
Vcs-Svn: svn://svn.debian.org/pkg-wpa/crda/trunk
Vcs-Browser: http://svn.debian.org/wsvn/pkg-wpa/crda/trunk/
* a friend sent me some patches to enhance the package a bit, still sitting
  in my inbox, needs to be updated to new release too.
* added a patch to disable linking to gcrypt [1], crda binary is not linked
  to anything which currently lives under /usr thus totally avoiding problems
  associated with a set of partition/filesystem schemes. It doesn't need
  any crypto stuff anyway, wireless-regdb is currently unsigned. I need to
  send this patch to you.
* After looking at the fedora/redhat package, I noticed they had a udev rule
  which called a script when ieee80211 subsystem was added and this script
  then tries to find out the timezone configuration of the system, then
  parse a file which maps the timezone to an ISO 3166 code and then calls
  iw to set it. This seemed like a good faith attempt at setting a default
  in the absence of any other technology (like geoclue?) so ported it to
  Debian using dpkg triggers to prepare a map of timezone -> iso code
  at package install/update time rather than doing it at runtime.
* btw, Makefile has a typo -> s/make noverify/make all_noverify/

[1] http://svn.debian.org/wsvn/pkg-wpa/crda/trunk/debian/patches/disable_gcrypt.patch

Common stuff
------------
* file ITP's for both packages and defend/explain myself to curious
  developers
* find a long term mentor - preferably one that is interested in more than
  just uploading the software, helping with bugs and giving guidance would
  be a bonus
    or
  cutting the red tape and becoming a Debian-Maintainer and conning a short
  term mentor that I am perfectly able to take care of this stuff myself, which
  I am not really
    or
  getting some other person to do it all and walking away from it :)
* influence the Debian kernel people to make required changes. Communicating
  with some of them is similar to recording the running of long strong
  fingernails down a blackboard, and replaying the recording in an endless
  loop on the car stereo while driving to the dentist. Only joking, but
  some of the team seem to be a bit funny. You could definitely help with
  this, but I reckon it'd be easier if crda/wireless-regdb packaging was
  already finalised in good shape and in the archive. This requires a wishlist
  bug report to be made against linux-latest-2.6 and some further discussion
  with 'em about it.
* getting the initial uploads done, passing through NEW checks and then
  working on any teething problems thereafter


Am happy for anyone else to pick up my stuff, take it change it and get a
painless, just working, set of the software in Debian. Or even just the latter
bit :)

> Also can you recommend a kernel contact, I'd
> like to recommend to not use CONFIG_WIRELESS_OLD_REGULATORY for a few
> reasons [1] as it seems to be the default on the current 2.6.32
> kernel.

Debian Kernel Team <debian-kernel@lists.debian.org>, more details at:
http://packages.qa.debian.org/l/linux-latest-2.6.html

> 
> [1] http://wireless.kernel.org/en/developers/Regulatory#Old_regulatory_implementation
> 
>   Luis
> 

Thanks, Kel.
