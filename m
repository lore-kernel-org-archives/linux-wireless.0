Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53584 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1JZVri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 17:47:38 -0400
Received: by qabj40 with SMTP id j40so1925819qab.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 14:47:37 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: =?UTF-8?q?=5BPATCH=200/5=5D=20v3=20HT=20support=20for=20mesh?=
Date: Wed, 26 Oct 2011 14:47:24 -0700
Message-Id: <1319665649-21784-1-git-send-email-thomas@cozybit.com> (sfid-20111026_234752_491390_04061A7C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds basic HT support for mesh nodes. We avoid the question of
how to negotiate channel types, by simply disallowing peering with mismatched
HT modes.

Many thanks to Luis Rodriguez for his assistance, and Ashok Nagarajan for
co-authoring this patchset.

v2: 
	Remove outdated BA comments (Christian)

v3:
	Guido R. Hiertz was kind enough to point out:

	"IEEE 802.11s-2011 states that mesh STAs use the default EDCA parameter
	set only. Clause 9.1.3.1 in 802.11s-2011 reads: "When communicating
	within a BSS, the EDCA parameters used are […] from the default values
	for the parameters […] when the STA is a mesh STA." Thus, all mesh STAs
	use the same (default) EDCA parameter set."

	So resubmitting without the WMM patches.

Alexander Simon (1):
  mac80211: Add HT helper functions

Thomas Pedersen (4):
  mac80211: comment allocation of mesh frames
  mac80211: add HT IEs to mesh frames
  mac80211: set HT capabilities for mesh peer
  mac80211: allow frame aggregation for mesh

 net/mac80211/agg-rx.c      |    3 +-
 net/mac80211/agg-tx.c      |   10 +---
 net/mac80211/ht.c          |    3 +-
 net/mac80211/ieee80211_i.h |    8 +++
 net/mac80211/mesh.c        |   70 +++++++++++++++++++++++---
 net/mac80211/mesh.h        |    4 ++
 net/mac80211/mesh_hwmp.c   |   36 +++++++-------
 net/mac80211/mesh_plink.c  |   50 ++++++++++++++-----
 net/mac80211/rx.c          |    7 +--
 net/mac80211/tx.c          |   23 ++++++--
 net/mac80211/util.c        |  116 +++++++++++++++++++++++++++++++++++++------
 net/mac80211/work.c        |   29 +-----------
 12 files changed, 252 insertions(+), 107 deletions(-)

-- 
1.7.5.4

