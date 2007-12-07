Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:24488 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbXLGWf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 17:35:27 -0500
Received: by py-out-1112.google.com with SMTP id u77so1865010pyb
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2007 14:35:23 -0800 (PST)
Message-ID: <43e72e890712071435l7b20420cq4b13aaaebcd729dd@mail.gmail.com> (sfid-20071207_223553_975359_E738FC2E)
Date: Fri, 7 Dec 2007 17:35:21 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/1] ath5k: add debugfs entries for registers, tsf, beacon
Cc: "Jiri Slaby" <jirislaby@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mickflemm@gmail.com
In-Reply-To: <200712051950.08672.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1196839665-14178-1-git-send-email-bruno@thinktube.com>
	 <47566B95.5080101@gmail.com> <200712051950.08672.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 5, 2007 5:50 AM, bruno randolf <bruno@thinktube.com> wrote:
> On Wednesday 05 December 2007 18:12:53 Jiri Slaby wrote:
> > > +   char buf[5000];
> >
> > Doh, 4k stacks on i386! You can't do this safely.
>
> ohh! i didn't know.
>
> > I think we can use seq_* stuff here instead, see below.
>
> > Put those register in the array, and from .seq_next, return &array[++*pos]
> > or NULL for the last member. .seq_show will contain the REG_PRINT_APPEND
> > macro contents.
>
> thanks for the hint. i changed the patch to do that now. but unfortunately by
> doing so we loose the ability to print the register names.
>
> anyways, here is the new version:
>
>
> ath5k: add debugfs entries for registers, tsf, beacon
>
> 'registers' prints the value of some registers. this should be adapted to what
> we actually need later.
>
> 'tsf' prints the current HW TSF. writing "reset" into the file will reset the
> TSF.
>
> 'beacon' shows beacon relevant registers. writing "enable" into the file will
> enable beacons by writing AR5K_BEACON_ENABLE, "disable" will disable that bit.
>
> 'reset' performs a HW reset.
>
> Changes-licensed-under: GPL
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>

Acked-by: Luis R. Rodriguez <mgrof@winlab.rutgers.edu>

Seems the patch may just need to be resent, not sure, but your mailer
may be messing with it. I'm using gmail --> show-original to retrieve
this as a patch so not sure if that would have messed the patch up (I
don't think so). But I get:

mcgrof@nesi:~/devel/compat-wireless-2.6$ patch -p1 <
/home/mcgrof/patches/new-debug.diff
patching file drivers/net/wireless/ath5k/debug.c
patch: **** malformed patch at line 238: *modes)

That hunk looks like this:

@@ -96,9 +294,16 @@ void
 ath5k_debug_finish_device(struct ath5k_softc *sc)
 {
        debugfs_remove(sc->debug.debugfs_debug);
+       debugfs_remove(sc->debug.debugfs_registers);
+       debugfs_remove(sc->debug.debugfs_tsf);
+       debugfs_remove(sc->debug.debugfs_beacon);
+       debugfs_remove(sc->debug.debugfs_reset);
        debugfs_remove(sc->debug.debugfs_phydir);
 }

+
+/* functions used in other places */
+
 void
 ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode
*modes)
 {


The last *modes line is the one it is complaining about. After moving
this line as:

 ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode *modes)

it patches well. I can't test this as my laptops have all gone dead,
but it looks well, and compiles well.

  Luis
