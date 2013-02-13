Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3BMJPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 04:15:21 -0500
Message-ID: <1360746917.8868.4.camel@jlt4.sipsolutions.net> (sfid-20130213_101542_447684_750D0D24)
Subject: Re: [PATCH] cfg80211: check vendor IE length to avoid overrun
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Wed, 13 Feb 2013 10:15:17 +0100
In-Reply-To: <1360692698-24208-1-git-send-email-coelho@ti.com>
References: <1360692698-24208-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 20:11 +0200, Luciano Coelho wrote:
> cfg80211_find_vendor_ie() was checking only that the vendor IE would
> fit in the remaining IEs buffer.  If a corrupt includes a vendor IE
> that is too small, we could potentially overrun the IEs buffer.
> 
> Fix this by checking that the vendor IE fits in the reported IE length
> field and skip it otherwise.

Applied. I changed the BUILD_BUG_ON to be != 1 since it has to be that,
but if one breaks that ...

johannes

