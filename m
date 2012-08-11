Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60568 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2HKAZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:25:57 -0400
Received: by pbbrr13 with SMTP id rr13so3542514pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 17:25:56 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: dquan@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFT 0/2] cfg80211: UNII regulatory hints
Date: Fri, 10 Aug 2012 17:25:48 -0700
Message-Id: <1344644750-14000-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20120811_022602_688868_FDFF93AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

It was hinted to me a while ago that we can enhance
beacon hints a little more by taking advantage of
common regulatory assumptions globally on UNII 1
and UNII 3. This implements that idea.

What this will do is in short enable to lift passive
scan flags off of 5 GHz channels *faster* when cards
are world roaming. This means that we can also initiate
communication on channels on either UNII 1 or UNII 3
faster than before when world roaming.

Credit goes got David Quan for the idea.

Luis R. Rodriguez (2):
  cfg80211: add a helper for processing 5 GHz beacon hints
  cfg80211: add 5 GHz UNII band regulatory hints

 net/wireless/reg.c |  167 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 151 insertions(+), 16 deletions(-)

-- 
1.7.10.4

