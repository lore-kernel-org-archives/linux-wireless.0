Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab2C1JS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:18:56 -0400
Message-Id: <20120328091346.442543219@sipsolutions.net> (sfid-20120328_111858_724256_2CFB2788)
Date: Wed, 28 Mar 2012 11:13:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/2] mac80211 queue redesign
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's the queue redesign we've been talking about.

The monitor patch is needed because when a driver actually
uses the new queue feature there isn't any queue to TX
frames on for purely virtual interfaces. This only affects
monitor (AP_VLAN are tied to AP) and only when injecting
frames that don't have a TA matching another interface (as
we bind the frames to that interface then). That, however
is probably the biggest use case (now that monitor-for-AP
is dying). As a consequence, drivers wanting to support
"pure" injection and using the new queue features need to
support the pure monitor interface feature as well. Also,
the pure monitor feature will help implement monitor mode
on devices where that is mutually exclusive with other
modes (like iwlwifi.)

The monitor feature I've tested in hwsim, it works. The
queue feature isn't tested at all, I haven't even done
any kind of regression tests for drivers not using it.

Thanks goes out to everybody I discussed this with (on
IRC or elsewhere), and also Michal for reviewing a first
version of this patch :-)

johannes

