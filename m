Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45272 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752551AbdDRIWC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 04:22:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2017-04-18
Date: Tue, 18 Apr 2017 10:21:55 +0200
Message-Id: <20170418082156.4706-1-johannes@sipsolutions.net> (sfid-20170418_102526_290152_BB8D9EB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Here's a single remaining fix - it's not even super urgent for
this cycle since it's in a "fringe" feature, but it's for an
SKB out-of-bounds access.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit fc9c89b19c56813434c3d2967652a4fa6906926a:

  Merge branch 'bridge-register-netdev-before-changelink' (2017-04-11 22:22:45 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-04-18

for you to fetch changes up to 9e478066eae41211c92a8f63cc69aafc391bd6ab:

  mac80211: fix MU-MIMO follow-MAC mode (2017-04-13 14:35:53 +0200)

----------------------------------------------------------------
A single fix, for the MU-MIMO monitor mode, that fixes
bad SKB accesses if the SKB was paged, which is the case
for the only driver supporting this - iwlwifi.

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: fix MU-MIMO follow-MAC mode

 net/mac80211/rx.c | 65 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 18 deletions(-)
