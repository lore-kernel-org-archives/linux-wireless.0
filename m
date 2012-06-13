Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2FMMgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 08:36:20 -0400
Message-ID: <1339590975.4519.36.camel@jlt3.sipsolutions.net> (sfid-20120613_143624_201185_1AF38CB2)
Subject: RE: [PATCH] cfg80211/nl80211: Fix for wireless-testing kernel crash
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jun 2012 14:36:15 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6C39@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6BFE@mbx022-e1-nj-10.exch022.domain.local>
	,<1339586895.4519.33.camel@jlt3.sipsolutions.net>
	 <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6C39@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 12:30 +0000, Mahesh Palivela wrote:

> net/wireless/nl80211.c -> nl80211_dump_survey() survey_info structure
> is not being initialized. Without this dev->ops->dump_survey() return
> value is zero. But 'survey' argument passed to this function is
> untouched and we are trying to access the members of this structure
> and hitting crash. Hope this helps.

What driver are you using, and why does it return 0 when it didn't
actually return/fill any information?

johannes

