Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933474Ab2JXJA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 05:00:56 -0400
Message-ID: <1351069288.10709.2.camel@jlt4.sipsolutions.net> (sfid-20121024_110100_387830_F8C342AE)
Subject: Re: [PATCH v6 4/6] wireless: use OR operation to set wiphy features
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 24 Oct 2012 11:01:28 +0200
In-Reply-To: <87d308z1no.fsf@purkki.adurom.net>
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
	 <1350542071-26498-5-git-send-email-bzhao@marvell.com>
	 <87d308z1no.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-24 at 11:59 +0300, Kalle Valo wrote:

> Is there a way to check that drivers don't accidentally clear the flags
> (ie. use '=' instead '|=')? For example by adding a dummy flag and
> checking afterwards that it's not cleared?
> 
> I'm just worried that this detail might be too easy to miss, for example
> somehow I had missed this patch and noticed only when rebasing ath6kl
> patches.

Yes, that should be possible, set some dummy flag in wiphy_new() and
test & clear it in wiphy_register()?

johannes

