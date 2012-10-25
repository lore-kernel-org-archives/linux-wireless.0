Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:51371 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab2JYCJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 22:09:40 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so930622iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 19:09:40 -0700 (PDT)
Message-ID: <50889F60.5090406@lwfinger.net> (sfid-20121025_040945_696943_8B1741A3)
Date: Wed, 24 Oct 2012 21:09:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Regression in 3.7-rc2 for b43 and b43legacy
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I have discovered that both b43 and b43legacy broke somewhere between 3.7-rc1 
and 3.7-rc2. The problem was bisected to commit fe57d9f. The commit message is

commit fe57d9f5c0a2c1ef97ba8cdc42cfda5743f287b8
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Jul 26 14:55:08 2012 +0200

     mac80211: track whether to use channel contexts

     Depending on the driver, channel contexts may be used or
     not. If they are used, the driver must have support for
     hardware scan and remain-on-channel; otherwise the driver
     must not advertise support for multiple channels.

     Also prohibit WDS type interfaces when channel contexts
     are to be used as there's no clear definition of which
     channel they use.

     Signed-off-by: Johannes Berg <johannes.berg@intel.com>

It seems likely that the drivers are inadvertently advertising support for 
multiple channels, What must be done to turn off this "feature"?

Thanks,

Larry
