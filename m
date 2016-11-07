Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36782 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753107AbcKGO7z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 09:59:55 -0500
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 0/8] iw: Add common chandef parser and new DFS related commands
Date: Mon,  7 Nov 2016 15:59:35 +0100
Message-Id: <20161107145943.16761-1-benjamin@sipsolutions.net> (sfid-20161107_155958_993797_5BD7359F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

Hi,

This patchset adds commands for doing a CAC and sending CSA.

Another change is that parsing of command line frequency and channel
definitions is split out so that it can be shared between the different
users.

Benjamin

Benjamin Berg (7):
  util: Add generic frequency/channel command line handler
  phy: Use common freqchan helper for setting the operating channel
  ibss: Use common freqchan helper for joining an ibss
  mesh: Use common freqchan helper for joining a mesh
  Add cac command to allow clearing channels
  Add commands to send CSA
  Print frequency of radar events.

Simon Wunderlich (1):
  Add flag for DFS handling in IBSS

 event.c     |  48 +++++------
 ibss.c      |  78 ++++--------------
 interface.c |  72 ++++++++++++++++
 iw.h        |  11 +++
 mesh.c      |  67 +++------------
 phy.c       | 266 ++++++++++++++++++++++++++++++++++++------------------------
 util.c      | 239 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 533 insertions(+), 248 deletions(-)

-- 
2.10.2
