Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47096 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758090AbXHXSzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 14:55:14 -0400
Message-ID: <46CF298B.7040001@lwfinger.net>
Date: Fri, 24 Aug 2007 13:55:07 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/15] cfg80211: clean up key add/remove interface
References: <20070824122705.549190000@sipsolutions.net> <20070824122907.784517000@sipsolutions.net>
In-Reply-To: <20070824122907.784517000@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

I found a compile problem when all the patches were installed in that 'ops' was not defined in 
wireless/core.c. This patch should be

+       WARN_ON(!drv->ops->add_key && drv->ops->del_key);
+       WARN_ON(drv->ops->add_key && !drv->ops->del_key);

and not WARN_ON(!ops->add_key etc.

A similar change is also required in patch 11/15.

I'm now ready to test your changes.

Larry
