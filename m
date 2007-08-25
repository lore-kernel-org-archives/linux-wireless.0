Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dike.telenet-ops.be ([195.130.132.36]:51610 "EHLO
	dike.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbXHYDO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 23:14:29 -0400
Received: from ananke.telenet-ops.be (ananke.telenet-ops.be [195.130.137.78])
	by dike.telenet-ops.be (Postfix) with ESMTP id 6BB9B820D23
	for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2007 04:38:12 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ananke.telenet-ops.be (Postfix) with SMTP id EC0D83923CC
	for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2007 04:37:30 +0200 (CEST)
Received: from [192.168.2.100] (d54C26ADF.access.telenet.be [84.194.106.223])
	by ananke.telenet-ops.be (Postfix) with ESMTP id D2EA03923BC
	for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2007 04:37:30 +0200 (CEST)
Message-ID: <46CF95F9.6090802@telenet.be>
Date: Sat, 25 Aug 2007 04:37:45 +0200
From: ian <ischram@telenet.be>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: letting drivers choose their preferred rate scale
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

I haven't made any respectable contributions yet to the state of linux wireless
but I've been quietly following the course of action for several months. (both here and
over at the iwlwifi front)

And I would like to bring up the issue of allowing the drivers to choose the rate
scaling once more. (wrt ilwiwifi)

I know that several months ago this was somewhat a heated topic, but i would really like
to delicately retry this subject. From my perspective with the ultimate goal of iwlwifi
being merged into the mainline kernel at one point. And causing less problems for
developers and users.

I was once one of those users that for more than a year had to patch their kernel with a
specific net80211 package to get ipw3945 (which due to regulatory daemon is an entirely
different story). All the problems it caused getting it to work, never mind between
kernels, was a bit of a challenge.So I would really like to help minimize similar problems
with iwlwifi and mac80211

Currently iwlwifi requires (when used with wireless dev or the mac80211 in the .22/.23
kernels) to work around the fact that mac80211 doesn't allow the driver to choose the rate
scaling algorithm, that mac80211 isn't compiled in the kernel, and no other
rc80211_* modules are loaded. Because due to several reasons iwlwifi uses its ratescaling
to do some tasks like maintain some synchronization (station list) between the ucode and
driver.(and at least for 3945 iw3945 rs works well.)

It's understandable that this functionality might belong in the software stack that mac80211
wants to be. And that there is no reason not to be critical about proposed changes, why else
would linux be open source. As well that code can always be moved from one level
of abstraction to another.

Personally I don't see the harm in allowing the drivers the choice of rate scaling algorithm,
and the patches that were proposed months ago(don't shoot me if it was less than 60 days)
appear to be elegant and clean enough(9 lines of which 4 are debug).

A version of the iwlwifi driver (merge patch v4, with the goal of merging it in .24) which has
been up for review for about a week now. Hasn't gotten too diminishing feedback yet,
some -to my opinion- grounded remarks from Johannes Berg, but not much else.

To be blunt: looking at the possible routes of action that i see:
- re-review the patch to allow the drivers to choose (preferred) rate scaling, and give it
a chance to make it in a future kernel.
- propose a feasible other course of action
- Simply refuse this for good reasons, leaving this issue to exist for longer,
and giving me (one of the kids with too much time) more explaining in the irc channel.
for 5 lousy lines of code.

I'll conclude this mail before it becomes too long and naggy, I'm sure the general point
is clear by now. Feel free to tell me to stfu if i totally missed the point. However I do
honestly believe that merging this patch or resolving this in another mutual satisfactory way.
Would benefit most of us. Obviously I don't have any say in the decision making of the intel
developers, but expecting that everything comes from Zhu Yi or others is unrealistic too.
[And for the record: I too would love an free for all ucode license, I honestly don't believe that
intel is only after product diferenciation, full specifications would be great. :-)]


ps: for reference, I'm talking about the "Specifing rate control algorithm?" thread which started
the 10th of may on this list.




Ian Schram.
