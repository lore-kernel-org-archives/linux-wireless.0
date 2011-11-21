Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58523 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1KUOlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 09:41:23 -0500
Received: by bke11 with SMTP id 11so6626611bke.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 06:41:22 -0800 (PST)
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Subject: [RFC v2 0/8] mesh power saving implementation: indication
Date: Mon, 21 Nov 2011 18:40:08 +0400
Message-Id: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com> (sfid-20111121_154127_723214_750C1617)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

We have updated our patches and also we would like to add some words
what our work is about.

Based on the latest IEEE 802.11s standard the power saving mechanism
can be divided into the following implementation phases:
* indication of mesh STAs' power modes in frames;
* a buffering and identification sending frames in mesh STA;
* Mesh Awake Window implementation;
* Peer service periods.

This patchset implements the phase of indication of mesh STAs'
power modes in frames. There are two types of mesh power modes:
* peer power mode: a mesh STA indicates its mesh power mode for each
mesh peering and obtains the mesh power modes of its peer mesh STAs;
* non-peer power mode: mesh station also indicates mesh power mode for
non-peer mesh stations. It determines when non-peer mesh STAs may send
Probe Request and Mesh Peering Open Request frames to the mesh STA.

Peer power mode should be indicated with Power Management field in the Frame
Control field and the Mesh Power Save Level field in all transmitted
individually addressed Mesh Data or QoS Null frames on this link.

Non-peer power mode should be indicated with the Power Management
field in the Frame Control field and the Mesh Power Save Level field
in the Mesh Capability field in Beacon and Probe Response frames. A
mesh STA shall also indicate its non-peer mesh power mode with the
Power Management field in the Frame Control field and the Mesh Power
Save Level field in the QoS Control field in group addressed Mesh Data
frames.

We would appreciate comments and advice.

Thanks,
Ivan

Ivan Bezyazychnyy (8):
  cfg80211 and nl80211: mesh power mode config parameter
  mac80211: mesh power mode indication in QoS frames
  mac80211: tracking mesh peer link-specific power mode
  mac80211: mesh non-peer power mode indication in beacons
  mac80211: setting link-specific mesh power modes when plink opens
  cfg80211 and nl80211: Setting local link-specific power mode
  cfg80211 and nl80211: getting local and peer mesh power modes
  cfg80211 and nl80211: setting and getting mesh non-peer power mode

 include/linux/ieee80211.h |   14 ++++++++++
 include/linux/nl80211.h   |   41 ++++++++++++++++++++++++++++++
 include/net/cfg80211.h    |   14 +++++++++-
 net/mac80211/cfg.c        |   16 +++++++++++-
 net/mac80211/mesh.c       |   35 +++++++++++++++++++++++++
 net/mac80211/mesh.h       |   11 ++++++++
 net/mac80211/mesh_plink.c |   22 +++++++++++++++-
 net/mac80211/rx.c         |   61 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h   |    4 +++
 net/mac80211/tx.c         |   46 ++++++++++++++++++++++++++++++++++
 net/wireless/mesh.c       |    1 +
 net/wireless/nl80211.c    |   22 ++++++++++++++++
 12 files changed, 284 insertions(+), 3 deletions(-)

-- 
1.7.3.4

