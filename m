Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2JJIP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 04:15:29 -0400
Message-ID: <1349856962.4683.30.camel@jlt4.sipsolutions.net> (sfid-20121010_101535_032030_21F6FD0C)
Subject: Re: [PATCH v3 2/5] cfg80211: add scan flag to indicate its priority
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 10 Oct 2012 10:16:02 +0200
In-Reply-To: <1349326066-28501-3-git-send-email-bzhao@marvell.com>
References: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
	 <1349326066-28501-3-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-03 at 21:47 -0700, Bing Zhao wrote:
> v3: Add WIPHY_FLAG_LOW_PRIORITY_SCAN flag so that device can advertise
>     low priority scan capability. An error will be returned to the
>     application if device doesn't support this feature.
>     Flush scan table feature is by default enabled.
>     (Johannes Berg)

Great, but you're not advertising it to userspace? I think that should
be there so it can know whether it can request flush etc?

Also, how should flush really work with scheduled scan? Or should it be
documented to not work there?

johannes

