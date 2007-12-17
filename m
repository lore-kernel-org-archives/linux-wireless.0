Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56264 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761348AbXLQA3W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 19:29:22 -0500
Message-Id: <20071217001956.640555983@gmx.de> (sfid-20071217_002925_615355_B5F9EF12)
Date: Mon, 17 Dec 2007 01:19:56 +0100
From: mattias.nissler@gmx.de
To: linville@tuxdriver.com
Cc: stefano.brivio@polimi.it, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: [patch 0/9] Rate control rework
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this patchset is the result of my recent joint-venture with Stefano. It
introduces a new rate control algorithm based on a PID controller. First
tests show it works much better than the old simple rate control
algorithm.

We think the current patch set is clean enough so we can push it into
2.6.25. However, there are some issues that need some more work:

* The algorithm parameters need more tuning. The current defaults are
  sane, but we hope to get a larger testing audience once this is in the
  tree. Once there are more test results, tuning should be easier.

* It seems mac80211 fails to clean up the rate control algorithm. This
  results in the debugfs entries created by patch 9 not being removed.

* Patch number 8 is actually a change to the debugfs code so I can add
  files for signed variables. I've sent it to Greg KH and LKML, let's
  see what happens. If it doesn't make 2.6.25, we could add similar
  infrastructure locally.

Hm, anything I forgot? Stefano?

Mattias


