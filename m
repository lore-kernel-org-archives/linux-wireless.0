Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55301.mail.re4.yahoo.com ([206.190.58.180]:43501 "HELO
	web55301.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750779AbZFEEmI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 00:42:08 -0400
Message-ID: <483055.8746.qm@web55301.mail.re4.yahoo.com>
Date: Thu, 4 Jun 2009 21:42:09 -0700 (PDT)
From: austinxxh-ath9k@yahoo.com
Reply-To: austinxxh-ath9k@yahoo.com
Subject: Re: ath9k/ath5k + 80211s crash
To: Andrey Yurovsky <andrey@cozybit.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


ath9k + 80211s has no crash anymore. however after assigned IP to the mesh node, I could not ping at all, it's not working.

ath5k crashes on ar71xx boards, just learned it might have something to do with silicon bug from atheros instead of ath5k driver bug.

xxiao

--- On Thu, 6/4/09, Nick Kossifidis <mickflemm@gmail.com> wrote:

> From: Nick Kossifidis <mickflemm@gmail.com>
> Subject: Re: ath9k/ath5k + 80211s crash
> To: "Andrey Yurovsky" <andrey@cozybit.com>
> Cc: austinxxh-ath9k@yahoo.com, devel@lists.open80211s.org, linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
> Date: Thursday, June 4, 2009, 10:39 PM
> 2009/6/4 Andrey Yurovsky <andrey@cozybit.com>:
> > On Wed, Jun 3, 2009 at 12:59 PM, Nick Kossifidis
> <mickflemm@gmail.com>
> wrote:
> >> 2009/6/3 Andrey Yurovsky <andrey@cozybit.com>:
> >>> On Wed, Jun 3, 2009 at 11:21 AM, Nick
> Kossifidis <mickflemm@gmail.com>
> wrote:
> >>>> 2009/6/2 Andrey Yurovsky <andrey@cozybit.com>:
> >>>>> With wireless-testing from a couple of
> days ago, an X86 system, and this patch:
> >>>>> http://osdir.com/ml/linux-wireless/2009-05/msg01241.html
> >>>>> ath9k can bring up a mesh point
> interface and doesn't crash for me,
> >>>>> but there are no mesh beacons, so mesh
> isn't working.  On ath5k, there
> >>>>> are also no beacons and mesh doesn't
> work, but there's no crash.
> >>>>>
> >>>>
> >>>>
> >>>> Hmm, try adding NL80211_IFTYPE_MESH_POINT
> here ->
> >>>>
> >>>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/pcu.c;h=ec35503f6a40e6b6a1cc4323287b31e7cdd3a428;hb=HEAD#l733
> >>>
> >>> It's already there, in ath5k_hw_set_opmode.
>  We'll need to trace
> >>> what's going on and see why we don't get
> beacons.  Last night I had an
> >>> ath5k MP suddenly start beaconing but I
> haven't been able to reproduce
> >>> that yet.
> >>
> >> 736         /* When in AP mode zero timer0 to
> start TSF */
> >> 737         if (ah->ah_op_mode ==
> NL80211_IFTYPE_AP)
> >> 738                 ath5k_hw_reg_write(ah,
> 0, AR5K_TIMER0);
> >>
> >> We need to do this for NL80211_IFTYPE_MESH_POINT
> or DBA won't fire up
> >> and beacon queue wont start...
> >
> > Thanks Nik, that gets beaconing going but only after a
> issuing a scan
> > (we have the same problem on rt2x00).
> >
> 
> Cool, i'll send a patch for this asap ;-)
> 
> Thanks for testing !
> 
> 
> -- 
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick
> 
