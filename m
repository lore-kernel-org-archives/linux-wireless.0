Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:34939 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762198Ab3ECNZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 09:25:38 -0400
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wirelss <linux-wireless@vger.kernel.org>
Subject: RE: [RFC 00/12] MBSS sharing across multiple interfaces
Date: Fri, 3 May 2013 13:25:34 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C5C070@RockMX01.rock.corp> (sfid-20130503_152542_298948_83DAA064)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have some questions and comments.

Question 1

The typical use case of multiple interfaces on this same host is to do RF segregation in order to improve overall network performance. e.g. divide a original mesh of 16 radios into 2 meshes of 8 radios each. This multi-radio host bridges these two small meshes which are on different channels. I can't see why user would put multiple radios of the same host on the same channel. They would just interfere with each other very badly. 

So, it does not matter whether they have matching mesh setup profile or not. Two MBSS-es simply can't see each other in air.

Question 2

In MPP where there are multiple mesh interfaces, AP interface and/or Ethernet interface, how does this "MBSS sharing" work? 
	a. add both mesh interface in 802.1d bridge, or
	b. add either interface in bridge, or
	c. sharing can't be used




-----Original Message-----
From: devel-bounces@lists.open80211s.org [mailto:devel-bounces@lists.open80211s.org] On Behalf Of Thomas Pedersen
Sent: Thursday, May 02, 2013 10:34 PM
To: Johannes Berg
Cc: open80211s; linux-wirelss
Subject: [RFC 00/12] MBSS sharing across multiple interfaces

This patchset enables multiple interfaces on the same host to share mesh path selection and frame forwarding duties. The peering state machine remains per-interface.

The user interface looks something like:

iw wlan0 mesh join foo shared on
iw wlan1 mesh join foo shared on

As long as wlan0 and wlan1 have a matching mesh setup profile, they will be considered part of the same MBSS.

This approach is superior to simple 802.1d briding, since mac80211 can dynamically pick the better link instead of simply disabling an entire port.
The added link knowledge also enables bonding and alternation in the future.

Bob Copeland (6):
  mac80211: track and share mesh BSSes among interfaces
  mac80211: mesh: add function to tx on all other mbss ifaces
  mac80211: use all MBSS interfaces for path selection
  mac80211: forward group frames on mbss-shared interfaces
  mac80211: add shared-mbss transmit path
  mac08211: add shared-mbss receive path handling

Thomas Pedersen (6):
  mac80211: assign outgoing interface with nexthop
  mac80211: forward frames on correct mbss-shared interface
  mac80211: notify bridge when leaving mesh
  mac80211: make RMC per-mbss
  {nl,mac}80211: specify MBSS sharing on/off
  {nl,mac}80211: allow mpath dump to span local MBSS

 include/net/cfg80211.h       |    8 +-
 include/uapi/linux/nl80211.h |   12 +-
 net/mac80211/cfg.c           |   17 +--
 net/mac80211/ieee80211_i.h   |   37 +++++-
 net/mac80211/iface.c         |    3 -
 net/mac80211/mesh.c          |  276 +++++++++++++++++++++++++++++++++++++++---
 net/mac80211/mesh.h          |   24 ++--
 net/mac80211/mesh_hwmp.c     |  133 ++++++++++++++------
 net/mac80211/mesh_pathtbl.c  |   68 +++++++----
 net/mac80211/rx.c            |  110 +++++++++++++----
 net/mac80211/tx.c            |    8 +-
 net/wireless/mesh.c          |    1 +
 net/wireless/nl80211.c       |   21 +++-
 net/wireless/rdev-ops.h      |   10 +-
 14 files changed, 599 insertions(+), 129 deletions(-)

--
1.7.10.4

_______________________________________________
Devel mailing list
Devel@lists.open80211s.org
http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
