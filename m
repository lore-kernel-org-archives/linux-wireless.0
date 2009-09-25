Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:7847 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZIYSZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 14:25:12 -0400
Received: by fg-out-1718.google.com with SMTP id 22so245732fge.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 11:25:15 -0700 (PDT)
Message-ID: <4ABD0B0D.5020002@lwfinger.net>
Date: Fri, 25 Sep 2009 13:25:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Problems with WPA in mainline 2.6.31-gitX
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes and John,

I found that commit bbac31f4 "cfg80211: fix SME connect" breaks WPA2
connections. I found the problem using bisection. I verified the
bisection by reverting the patch above. I also found that commit
55a00b833 "cfg80211: don't overwrite privacy setting" from
wireless-testing fixed the issue.

Is the latter patch on its way upstream? If so, I will not bother with
posting a regression on LKML or a bugzilla report. If not, I will
initiate the formalities to ensure that the second patch is included
in mainline.

Larry


