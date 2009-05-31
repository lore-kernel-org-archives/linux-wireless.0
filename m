Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:63255 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbZEaQjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 12:39:17 -0400
Received: by bwz22 with SMTP id 22so7043758bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 09:39:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090526163013.GA7072@tesla>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
	 <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
	 <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com>
	 <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com>
	 <3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com>
	 <20090407160812.GA5758@tesla>
	 <3ace41890905250008q255d15dej45a4f53d9f8c90e4@mail.gmail.com>
	 <20090526163013.GA7072@tesla>
Date: Sun, 31 May 2009 17:39:17 +0100
Message-ID: <3ace41890905310939k27c01bdw5a241df577d6c85a@mail.gmail.com>
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2009 at 5:30 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, May 25, 2009 at 12:08:05AM -0700, Hin-Tak Leung wrote:
>> This is just a head-up that I have a series of diffs to port the
>> vendor driver forward to current kernels, if anybody wants to have a
>> look, for side-by-side scavenging to the rw driver. (I probably will
>> post them to the sourceforge zd1211-dev list after a little look at
>> that oops)
>
> That's great to hear, feel free to post them to linux-wireless as
> RFC/RFTs.

The patches are somewhat big so I have split them the git way and
uploaded to the sourceforge user area. Here is some extra description
beyond what the header says. I will probably upload a version of this
summary write-up when/if I get some feedback. The fix for the oops I
mentioned earlier is patch 0007. Caveate: The driver is known *not* to
work on 64-bit platform.

----------------------------------------------------------------
http://htl10.users.sourceforge.net/LinuxUSB_AR2524-3.0.0.56_2009May_pathset/

0001-wext-Emit-event-stream-entries-correctly-when-compa.patch
0002-Convert-direct-reference-of-netdev-priv-to-netdev_p.patch
0003-adding-Philip-USB-stick-vid-pid.patch
0004-forward-port-of-an-old-patch-from-the-internet.patch
0005-add-delay-for-firmware-loading-bug.patch
0006-fix-compile-error-when-HMAC_DEBUG-is-enbled.patch
0007-fix-NULL-pointer-deference-in-newly-introduced-in-3.patch
0008-removing-two-tedious-messages-which-prints-once-ever.patch
0009-commenting-out-two-informative-messages.patch

0001 - required from about 2.6.27 onwards
0002 - required from about 2.6.29 onwards
0003 - vid/pid of my hardware
0004 - this probably should be splitted up into a few patches; some of
it is just error-checking/recovery, the 'restart URB on timeout' code
path was needed in 2.0 and often triggered when the 2.0 driver was
under stress but seems to be never triggered in 3.0, so it probably
just covers an old bug elsewhere which has since been fixed. I do not
understand the purpose of the interrupt<->bulk transfer change; if
somebody else does, please tell me.
0005 - splitted out from 0004
0006 - it is a bug which is only encountered when HMAC_DEBUG is
enabled (which is not the default) so this patch is not important for
normal usage
0007 - important bug fix for a new bug in 3.0
0008, 0009 - I find these dmesg messages too frequent and not
imformative (0008 is regular every two minutes, 0009 is whenever AP
mode is under stress, but seems to be harmless). 0009 probably should
*not* be applied for debugging AP problems.

Patch set against the older driver - they are not very tidy, but
mostly for historical purposes:
http://htl10.users.sourceforge.net/ZD1211LnxDrv_2_22_0_0_2009May_pathset/

0001-first-working-version-without-usb-speed-override.patch
0002-remove-usb-speed-override.patch
0003-compiler-warnings.patch
0004-compiler-warnings.patch
0005-compiler-warnings.patch
0006-more-compiler-warnings.patch
0007-commit-ccc580571cf0799d0460a085a7632b77753f083e.patch
0008-Convert-direct-reference-of-netdev-priv-to-netdev_p.patch
0009-more-clean.patch
0010-removing-some-debug-messages.patch
0011-more-compiler-warnings.patch
0012-more-compiler-warnings.patch
0013-Possible-fix-for-NULL-pointer-dereference-in-getElem.patch

0001 is tidied up and split into 0003/0004/0005 in 3.0
0002 is something I decide - the driver shouldn't speed based on USB
host speed, but just throttle back on rate. (but seems to trigger the
'restart URB on timeout' code path quite often).
0007 is similiar to 3.0's 0001 ; 0008 is similiar to 3.0's 0002;
0013 is discovered via looking at the 2.0/3.0 difference. It seems to
be a bug fix in 3.0, which is therefore backported.
----------------------------------
