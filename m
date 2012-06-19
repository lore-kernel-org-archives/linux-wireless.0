Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:57444 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2FSV7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 17:59:41 -0400
Received: from mail0.frost.chambana.net (mail0.frost.chambana.net [209.66.96.68])
	by www19.servergod.com (Postfix) with ESMTP id 8FA4911F85A
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 14:59:40 -0700 (PDT)
Received: by mail0.frost.chambana.net (Postfix) with SMTP id 41B9B59A058
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 21:59:40 +0000
From: Will Hawkins <hawkinsw@opentechinstitute.org>
To: hawkinsw@opentechinstitute.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 0/3 v4] mac80211: add support for userspace to handle auth frames on adhoc ifaces
Date: Tue, 19 Jun 2012 17:59:11 -0400
Message-Id: <cover.1340142553.git.hawkinsw@opentechinstitute.org> (sfid-20120619_235944_999732_F08793DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I am sending along 3 patches to add support for user space applications
to register for authentication frames on adhoc interfaces. These are
revisions to a previous patch that I submitted to accomplish the same
thing.

Patch 1/3 adds support for tracking whether userspace applications
are registered for authentication frames received by an adhoc
interface. This count is used in Patch 2/3 to determine 
if an "open system" authentication frame is sent when a new 
station joins an adhoc network.

Patch 2/3 adds support for checking the registration count
before sending out "open system" authentication frames when a 
new station joins an adhoc network. If there are no userspace
applications registered for the authentication frames then 
an "open system" authentication frame is broadcast. 

Patch 3/3 sets the necessary flags to allow userspace
applications to register for authentication frames on adhoc interfaces.
frames.

As I've said before, I'm still new to this process so I look forward to
your feedback on improving.

Will

Will Hawkins (3):
  mac80211: Track auth frame registrations on IBSS ifaces
  mac80211: Check auth frame registration count
  mac80211: Allow userspace application to register for authentication
    frames

 net/mac80211/cfg.c         |   10 ++++++++++
 net/mac80211/ibss.c        |    2 +-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |    4 +++-
 4 files changed, 15 insertions(+), 2 deletions(-)

-- 
1.7.9.5


