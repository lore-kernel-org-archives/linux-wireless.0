Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48538 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0IKBX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 21:23:29 -0400
Received: by qwh6 with SMTP id 6so2014477qwh.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 18:23:28 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Sep 2010 18:23:28 -0700
Message-ID: <AANLkTikCBPGjNmRxdkgpZdTnHNvcMSOa6g2V-Z3o6bCx@mail.gmail.com>
Subject: mesh beacons broken on HEAD for libertas_tf
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found an issue with recent changes to mac80211 that break mesh
beacons at least for libertas_tf.

I say "recent" in that the exact same libertas_tf code works fine in a
2.6.34-rc5-wl kernel but not in head.

ieee80211_do_open() calls ieee80211_start_mesh() which calls
ieee80211_bss_info_change_notify() to turn on beaconing.
ieee80211_bss_info_change_notify() checks that state is
SDATA_STATE_RUNNING before it enables beacons.

Problem is, SDATA_STATE_RUNNING doesn't get set until right before
ieee80211_do_open() exits, long after ieee80211_start_mesh() gets
called and tries to enable beaconing.

The SDATA_STATE_RUNNING stuff was added in commit 34d4bc4d about two weeks ago.

The basic symptom is that the commands go down to the firmware to
setup the beaconing, but instead of beaconing being enabled, it's
disabled in the command call.

I can set the bit right before the start mesh call and all works as
expected.  But, I'm sure this isn't the correct change.

I see four general strategies:
1. Move the setting of SDATA_STATE_RUNNING to earlier in the function.
 This is obviously problematic, having to unset it on errors or so on.
2. Remove the check in ieee80211_bss_info_change_notify().  Of course,
this was probably put here for a reason.
3. Put an exception to the check in ieee80211_bss_info_change_notify()
so that if vif->type is mesh, that we don't check the
SDATA_STATE_RUNNING bit.  Fairly straight forward and I know how to do
that.
4. Somehow delay the mesh setup from setting up beacons till after the
ieee80211_do_open() call finishes.  I'm not sure how to accomplish
this in a sensible way.

Does anyone have any suggestions?

Thanks,
- Steve
