Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64100 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3KANzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:55:36 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so1113402wid.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:55:34 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/8] wireless-regdb: General updates
Date: Fri,  1 Nov 2013 14:55:23 +0100
Message-Id: <1383314131-20774-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145539_991402_1DF9A8F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

I have a pretty large delta now, this is due to the fact that
QCA has had a backlog of updates to wireless-regd for a while
now. We've worked on a tool to help automate interpretting our
rules and extracting them into wireless-regdb form. The hope here
is that after we iron our our discrepencies from the backlog we
will ensure that we'll be sending updates ASAP and that away
avoid any backlog.

There are a few discrepencies from what we have on countries
that the community has submitted changes on, in particular this
consists of: CZ, DE, ES, IL, RS, UA. For these countries I have
not submitted changes, and I am pending review with Michael
on the changes to see what we can come up with or compromise
on.

The first two patch series are completely augmentative in
the sense that we are only enabling HT40, VHT80, increasing
frequency ranges, increasing TX power on 2.4 and/or 5 GHz.

The last series does have general updates to countries which
do remove some rules but that is done only for countries not
listed above.

The entire delta can be obtained via either a single patch [0]
or my git tree [1].

This is the first patch set and deals with the initial backlog
I had, adds DFS regions to countries, and uses the new CRDA
optimizer for rules for which we have no pending conflicts
with.

I'll post details of the second and third patch set after the
first series patches. I expect a 4th patch set but I expect
that will take a bit of time to complete. This should be
enough to get us started back on the right track and try to
take care of as much of the backlog as possible.

[0] http://drvbp1.linux-foundation.org/~mcgrof/patches/2013/11/01/pending-wireless-regdb-2013-11-01.patch
[1] git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/wireless-regdb.git

Luis R. Rodriguez (8):
  wireless-regdb: consolidate passive-scan and no-ibss flags
  wireless-regdb: remove antenna gain
  wireless-regdb: add DFS FCC regions
  wireless-regdb: add DFS ETSI regions
  wireless-regdb: add DFS JP regions
  wireless-regdb: optimize two of DE's rules
  wireless-regdb: optimize two of IL's rules
  wireless-regdb: optimize two of NL's rules

 db.txt     | 1246 ++++++++++++++++++++++++++++++------------------------------
 dbparse.py |   11 +-
 2 files changed, 625 insertions(+), 632 deletions(-)

-- 
1.8.4.rc3

