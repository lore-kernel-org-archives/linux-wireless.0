Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:49606
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab2FMOhk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 10:37:40 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] cfg80211/nl80211: Fix for wireless-testing kernel crash
Date: Wed, 13 Jun 2012 14:37:39 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6C9D@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120613_163743_751004_A274EFBD)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6BFE@mbx022-e1-nj-10.exch022.domain.local>
	,<1339586895.4519.33.camel@jlt3.sipsolutions.net>
	 <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6C39@mbx022-e1-nj-10.exch022.domain.local>,<1339590975.4519.36.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339590975.4519.36.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, June 13, 2012 6:06 PM
To: Mahesh Palivela
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: RE: [PATCH] cfg80211/nl80211: Fix for wireless-testing kernel crash

On Wed, 2012-06-13 at 12:30 +0000, Mahesh Palivela wrote:

> net/wireless/nl80211.c -> nl80211_dump_survey() survey_info structure
> is not being initialized. Without this dev->ops->dump_survey() return
> value is zero. But 'survey' argument passed to this function is
> untouched and we are trying to access the members of this structure
> and hitting crash. Hope this helps.

What driver are you using, and why does it return 0 when it didn't
actually return/fill any information?

johannes

Its our own chip driver. I just checked without doing anything we are returning zero. I will fix it on our end as well.
