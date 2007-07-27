Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38457 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755645AbXG0P5Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 11:57:16 -0400
Date: Fri, 27 Jul 2007 17:57:16 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: mac80211 git tree reworked
Message-ID: <20070727175716.32242e3f@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this will most likely be unpopular, but it was a thing that needed to
be done to make mac80211 tree manageable again.

I rebased all mac80211 patches which are not in vanilla. Now, mac80211
tree is solely based on vanilla and has the following branches:

- up-2.6 - this is a branch with patches I'd like to push to vanilla.
  It contains, among other things, Johannes' restructuring patches. I'll
  send a pull request later today.

- up-dev - a branch based on up-2.6 with all mac80211 patches currently
  in wireless-dev. See below.

- master - a branch with the newest stuff. Currently the same as up-dev.

Creating the up-dev branch meant modifying all mac80211 patches in
wireless-dev, as they sit on top of Johannes' restructuring patches
now. When I was in it, I merged 11n and WMM patches with later fixes. I
also moved a bunch of patches currently in wireless-dev only before 11n
and WMM patches (merging parts of them that affected 11n and WMM
patches directly into them) so they can be pushed upstream.

All mac80211 patches submitted in past few days were modified to apply
after restructuring and applied to up-2.6 or up-dev branch as
appropriate.

I started to do the same with cfg80211 and nl80211 patches but it
turned out that many cfg/nl80211 commits overwrite each other as the
interface was evolving and being rewritten. So I decided to throw away
the history and make a patch (surprisingly, it's quite a nice and
relatively small patch in the end) that brings cfg80211/nl80211 to the
state in which it was when mac80211 was merged to vanilla. Patches that
were committed afterwards are committed separately on the top of it.

What are the advantages?
- Johannes' restructuring patches go in.
- We have patches prepared for merging of wireless-dev into vanilla.
- mac80211 patches can go to vanilla and will appear automatically and
  correctly in wireless-dev.

What I'm proposing to do now?
- Throw away current wireless-dev and start it from scratch from the
  current vanilla.
- Apply patches from up-dev branch of mac80211 tree.
- Apply all drivers. That's a bit tricky and I'm aware that some people
  won't agree but I think it's easiest to apply them as one big patch
  for each (that's the form in which they will be submitted to vanilla
  anyway). They have been moved out of mac80211 directory recently so
  perhaps it's a good time to do that. I can help with creating such
  patches.

[In fact, I'd like more another approach but I'm not sure how feasible
it is: apply mac80211 drivers to a separate branch than mac80211 in
wireless-dev and pull both of them into a common branch. That way I'd be
able to rebase mac80211 tree to keep mac80211 patches always on the top
(and modify them gradually as fixes, especially to 11n and WMM,
appear). The big disadvantage is that pulling from wireless-dev would
become much harder.]

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
