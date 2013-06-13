Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:57706 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758359Ab3FMRqt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 13:46:49 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Paul Stewart <pstew@chromium.org>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Ben Greear <greearb@candelatech.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 13 Jun 2013 10:46:31 -0700
Subject: RE: [PATCH] mwifiex: Add module parameter for regdomain
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2AA198A@SC-VEXCH1.marvell.com> (sfid-20130613_194656_457149_7C463AB8)
References: <1370904007-10959-1-git-send-email-bzhao@marvell.com>
	<877ghz3il6.fsf@purkki.adurom.net>
	<477F20668A386D41ADCC57781B1F70430EA268B457@SC-VEXCH1.marvell.com>
	<8738sn2mcf.fsf@purkki.adurom.net>	<51B8C41E.7050907@candelatech.com>
	<477F20668A386D41ADCC57781B1F70430EA268B4A3@SC-VEXCH1.marvell.com>
	<20130613173002.GC3246@tuxdriver.com>
	<CAMcMvsgVHMzVY4fnW7n+vgdWKKVgvF+fJ93xvRkkfZUjxt-bBQ@mail.gmail.com>
 <CAMcMvsjT_MB4k_yDnuOozAXLY++OJ-EYx0REtEa2PphVOJbcJQ@mail.gmail.com>
In-Reply-To: <CAMcMvsjT_MB4k_yDnuOozAXLY++OJ-EYx0REtEa2PphVOJbcJQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Oh, wait.  That exists in the 'ieee80211_regdom' parameter to
> cfg80211.  You should use that. :-)

'ieee80211_regdom' parameter is also a user regulatory hint.

        /*
         * Finally, if the user set the module parameter treat it
         * as a user hint.
         */
        if (!is_world_regdom(ieee80211_regdom))
                regulatory_hint_user(ieee80211_regdom,
                                     NL80211_USER_REG_HINT_USER);

Regards,
Bing
