Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42308 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2CaTUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 15:20:18 -0400
Received: by yhmm54 with SMTP id m54so824336yhm.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 12:20:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <94fa57f85148c031c38599d2acf4561d.squirrel@webmail.cs.umd.edu>
References: <94fa57f85148c031c38599d2acf4561d.squirrel@webmail.cs.umd.edu>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Sat, 31 Mar 2012 13:19:47 -0600
Message-ID: <CAJfuBxyAMGWFwwpJrRLAyzT42fSK9D4Aty2Z0apn3CRdeLBSwQ@mail.gmail.com> (sfid-20120331_212022_479907_76864F8E)
Subject: Re: maranello for linux current ?
To: Bo Han <bohan@cs.umd.edu>
Cc: Bobby Bhattacharjee <bobby@cs.umd.edu>, schulman@cs.umd.edu,
	francesco.gringoli@ing.unibs.it, Neil Spring <nspring@cs.umd.edu>,
	slee@research.att.com, rmm@research.att.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 30, 2012 at 11:57 PM, Bo Han <bohan@cs.umd.edu> wrote:
> Hi Jim,
>
> Thank you for merging the patches into Linux 3.3.  It would be great if we
> could run Maranello on a recent kernel.
>
> BTW, what are the merge conflicts?
>
> Thanks,
> -Bo
>


>> - conflict resolution not separated from non-conflicting merges
>>   I probably should have spent the time to figure out how do this, but..

hi Bo,

I put notes into each commit about conflicts, knowing I wouldnt remember.
Some conficts were trivial:

- includes - I split fletcher32 and is-maranello-block out to separate files,
and included them where needed.  this conflicted in some places.
This will need eventual cleanup, but theres no point until we get
closer to linux staging.

- wireless/Makefile.  I needlessly added maranello.o here, and also to
wireless/b43/Makefile (which is actually used).  Cleaning out former just makes
for more churn, and can wait til refactor for staging.

- maranello adds block-length mod-param, upstream added others.
this caused a conflict for each param added upstream.

- The block-len param validation switch in b43-wireless-init() also
caused conflicts,
as upstream started using ERR_PTR (PTR_ERR??)
Probably, the linux-wireless folks would say to use a __setup()
handler and a callback
to validate the param.  This would get it out of the way, and probly
back-port nicely.
Im deferring on it though.


commit d1d06036307246fed184c05c3887cf9b8678d11e
Merge: 24ce820 805a6af
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 02:58:41 2012 -0600

    Merge commit 'v3.2' into maranello/merges

    Conflicts:
    drivers/net/wireless/b43/b43.h
        keep pio_scratchspace[250]

    drivers/net/wireless/b43/xmit.c
    drivers/net/wireless/b43/xmit.h

    These conflicts related to switch from old_format, new_format to
    format_598,410,351.  Fix these in places other than conflicts.
    May have bug getting crc in 598 case, which has no crc_bank.


pio-scratchspace was trivial - I had enlarged it to 250 in an earlier
merge, to fix a BUILD_BUG.
Probably should shrink it down, but wasnt worth doing now. IIRC 200
was too small.

the old-format/new-format change needs some attention - upstream went with
enumerated formats and switches.  I think I added a FIXME whereever I
was uncertain
of my resolutions.

Aside: IIUC, git has some facility to 'replay' merges.  I use git rebase often,
but it messed up merge history when I tried to move a cleanup patch backwards
past the release merge points.  Mastering this replay would be good, to isolate
conflicts from compile fixes from simple merges, and to backport fixes
w/o messing
up the history.

That said, backporting probably doesnt matter much; openwrt-current is
on v3.2 -  v3.3
Ive just flashed my router, to this, and am closer to trying out
maranello myself.

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 ATTITUDE ADJUSTMENT (bleeding edge, r31146) ----------


Regarding whats next, I want to be conservative about hacking on stuff
I dont fully understand.
What'd Dennis Ritchie say? "debugging is 2x as hard as coding, so if
your code is
as 'clever as you can make it', youre not clever enough to debug it"

But cleanup & refactor will be needed for/in linux staging, so its
worth identifying
what to fix, and in what order.

- __setup(block_length_handler)
- move all maranello fields out of struct b43_wldev, into struct
maranello_driver_data,
  then add back to b43_wldev as single member, perhaps as pointer to
separately allocated memory,
  for clean non-maranello builds.
- a vtable of maranello_ops (this is where your expertise is *needed*)

Again, I want to see it work on my router, and hear of success from you,
before I go and break it with clever patches !!


FTR, heres the whole set of commit messages.
Theyll at least get you close to the conflicts.
If you have further questions, please ask.


[jimc@groucho linux-2.6]$ git log
commit f27648d3fe5511828793c812a58d098bef4bd771
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 20:12:03 2012 -0600

    fix all // comments

    convert // comments to /* */

commit c5045097fcaa04df469e462129abdcf6850df5de
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 03:13:44 2012 -0600

    cleanfile on b43/*, whitespace

commit 8e8866523317ebc321f74201ecd3adc04ad61e26
Merge: d1d0603 c16fa4f
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 03:04:10 2012 -0600

    Merge commit 'v3.3' into maranello/merges

commit d1d06036307246fed184c05c3887cf9b8678d11e
Merge: 24ce820 805a6af
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 02:58:41 2012 -0600

    Merge commit 'v3.2' into maranello/merges

    Conflicts:
    drivers/net/wireless/b43/b43.h
        keep pio_scratchspace[250]

    drivers/net/wireless/b43/xmit.c
    drivers/net/wireless/b43/xmit.h

    These conflicts related to switch from old_format, new_format to
    format_598,410,351.  Fix these in places other than conflicts.
    May have bug getting crc in 598 case, which has no crc_bank.

commit 24ce820a57b44fe6836eaf70397ffe14462ba12a
Merge: a5ad128 c3b92c8
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 02:33:28 2012 -0600

    Merge commit 'v3.1' into maranello/merges

    Conflicts:
    drivers/net/wireless/b43/main.c
        in b43_wireless_init(),
        blocklength mod-param validation, vs:

    commit 2729df25550f041940f23c11ee8252094a6bd44b
    Author: Rafał Miłecki <zajec5@gmail.com>
    Date:   Mon Jul 18 22:45:58 2011 +0200

        b43: correctly display longer chipsets ids

commit a5ad128ef2665023015df00076538c15cd883771
Merge: 7a85ce4 02f8c6a
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 02:26:40 2012 -0600

    Merge commit 'v3.0' into maranello/merges

    Conflicts:
    drivers/net/wireless/b43/main.c
        fix b43_wireless_init(),
        clash of blocklength validation code with:

    commit 0355a3452fe218b2bc61a7a571064ee86dd6bf4e
    Author: Rafał Miłecki <zajec5@gmail.com>
    Date:   Tue May 17 14:00:01 2011 +0200

        b43: make b43_wireless_init less bus specific

commit 7a85ce47ddc5f4f3fcf6c0f332a714e3afe8b1ac
Merge: 963c7b3 61c4f2c
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 02:15:09 2012 -0600

    Merge commit 'v2.6.39' into maranello/merges

    Conflicts:
    drivers/net/wireless/b43/xmit.c
        new table:
        static const struct b43_tx_legacy_rate_phy_ctl_entry
               b43_tx_legacy_rate_phy_ctl[]
        added at top, above maranello fns

commit 963c7b3d37f9f880be3a97f395cc168751a21d65
Merge: 04fa66b 521cb40
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 02:06:15 2012 -0600

    Merge commit 'v2.6.38' into HEAD

commit 04fa66be1a88c9f2e1f90922f6178ff251272ebe
Merge: 8416c16 3c0eee3
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 02:05:08 2012 -0600

    Merge commit 'v2.6.37' into HEAD

    Conflicts:
    drivers/net/wireless/Makefile
        damn unneeded maranello.o addition

commit 8416c164e6f9847e4ee04c44a8d01bbc81fc909c
Merge: cad3e9d f6f94e2
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 01:59:29 2012 -0600

    Merge commit 'v2.6.36' into HEAD

commit cad3e9d119941fbefef387058b87650234c8fc63
Merge: 930ebcf 9fe6206
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 01:56:58 2012 -0600

    Merge commit 'v2.6.35' into HEAD

commit 930ebcf7995694c2720bfb16ce20786bd799fbaf
Merge: d20bd6d e40152e
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 01:54:07 2012 -0600

    Merge commit 'v2.6.34' into HEAD

    drivers/net/wireless/b43/b43.h
        enlarge pio_scratchspace to 250 to fix BUILD_BUG

    Conflicts:
    drivers/net/wireless/b43/Makefile
        pio.o always in (conflict with earlier avoidance attempt !*^%)

    drivers/net/wireless/b43/main.c
        pio mod-param

commit d20bd6da2a462ed70530ac20c58a9d0c4582acb1
Merge: f63daab 60b341b
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 01:47:51 2012 -0600

    Merge commit 'v2.6.33' into HEAD

    Conflicts:
    drivers/net/wireless/b43/xmit.c
        merge includes

commit f63daab714469886cb2d8e8a36749042fcd78a91
Merge: 3735ba3 22763c5
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 01:37:39 2012 -0600

    Merge commit 'v2.6.32' into HEAD

    Conflicts:
    drivers/net/wireless/b43/debugfs.c
        FOPS dropped last arg

        also remove spinlocks on log->lock in spec_stat_lock
        not a conflict, but a compile prob.

    commit 36dbd9548e92268127b0c31b0e121e63e9207108
    Author: Michael Buesch <mb@bu3sch.de>
    Date:   Fri Sep 4 22:51:29 2009 +0200

        b43: Use a threaded IRQ handler

    drivers/net/wireless/b43/xmit.c
        merge includes, keep both

commit 3735ba35bb370e62abc63a199718ce5f76f649c9
Merge: 687e254 74fca6a
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 01:05:43 2012 -0600

    Merge commit 'v2.6.31' into HEAD

    Conflicts:

    drivers/net/wireless/Makefile
        merge v31 changes with previous junk change

    drivers/net/wireless/b43/xmit.c
        fakebad block in b43_rx

    drivers/net/wireless/b43/main.c
        maranello addition to b43_op_stop,
        minus b43_rfkill_exit, dropped by:

    commit f41f3f373dd72344c65d801d6381fe83ef3a2c54
    Author: Johannes Berg <johannes@sipsolutions.net>
    Date:   Sun Jun 7 12:30:34 2009 -0500

        b43/legacy: port to cfg80211 rfkill

        This ports the b43/legacy rfkill code to the new API offered
        by cfg80211 and thus removes a lot of useless stuff.

commit 687e2542c4732bc5f692f23761b2ee6060a1e11f
Merge: ab545d4 07a2039
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 00:51:34 2012 -0600

    Merge commit 'v2.6.30' into HEAD

    Conflicts:
    b43/debugfs.c
        following dropped tsf_read/write_file()

    commit 08e87a833f5e77ff33b64c9ac27cb7fb9ecd4a48
    Author: Alina Friedrichsen <x-alina@gmx.net>
    Date:   Sun Jan 25 15:28:28 2009 +0100

        b43: Accessing the TSF via mac80211

    b43/main.c
        add mod-param for blocklength
        b43_wireless_init() add mod-param value check

    b43/xmit.c
        fakebad block AND if (unlikely...)

commit ab545d493b292d1c0f9fbd19387773ff8367b4bb
Merge: 74c319d 8e0ee43
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Thu Mar 29 00:45:41 2012 -0600

    Merge commit 'v2.6.29' into HEAD

commit 74c319d674fa137bba1c3480de5e881d8782c0ad
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Fri Mar 18 14:59:18 2011 -0600

    b43: extract maranello common parts to ../maranello.[ch]

    xmit.c: move fletcher32() to ../maranello.c, and defines to ../maranello.h
    util.c: move fragment_is_maranello() to ../maranello.c
    Makefile: add maranello.o as unconditional module target (cleanup later)

    and to compile/build, add:
    dma.c               include ../maranello.h
    xmit.c              include ../maranello.h

commit db92bfbbcdacc1bc60838f8a62683e57dfd8fce0
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Wed Mar 28 20:35:33 2012 -0600

    undo mac80211.h addition, now in maranello.[ch]


[jimc@groucho linux-2.6]$ git log 74c319d67
commit 74c319d674fa137bba1c3480de5e881d8782c0ad
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Fri Mar 18 14:59:18 2011 -0600

    b43: extract maranello common parts to ../maranello.[ch]

    xmit.c: move fletcher32() to ../maranello.c, and defines to ../maranello.h
    util.c: move fragment_is_maranello() to ../maranello.c
    Makefile: add maranello.o as unconditional module target (cleanup later)

    and to compile/build, add:
    dma.c               include ../maranello.h
    xmit.c              include ../maranello.h

commit db92bfbbcdacc1bc60838f8a62683e57dfd8fce0
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Wed Mar 28 20:35:33 2012 -0600

    undo mac80211.h addition, now in maranello.[ch]

commit 02827f6fb8682c7e432e70efc944066335a5be80
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Fri Mar 18 12:17:01 2011 -0600

    patch -p0 < maranello_released_kernelpatches/b43.patch

    Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

commit 006057de2c2b57a3e575cca99ebb82544cbb3ddb
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Fri Mar 18 12:19:48 2011 -0600

    patch -p0 < maranello_released_kernelpatches/include.patch

    Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

commit e68f89f1aabfcde7092eda6d4c2b244e20ed3edf
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Fri Mar 18 12:21:46 2011 -0600

    patch -p0 < maranello_released_kernelpatches/mac80211.patch

    Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

commit 1de9e8e70f5acc441550ca75433563d91b269bbe
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jan 16 12:43:00 2009 -0800

    Linux 2.6.29-rc2
