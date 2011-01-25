Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab1AYK1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 05:27:16 -0500
Subject: Re: [PATCH] cfg80211: Allow non-zero indexes for device specific
 pair-wise ciphers
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1295950882-16785-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1295950882-16785-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 11:27:10 +0100
Message-ID: <1295951230.3650.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-25 at 12:21 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Some vendor specific cipher suites require non-zero key indexes for pairwise
> keys, but as of currently, the cfg80211 does not allow it.

Well, technically, that is incorrect -- just adding a vendor-specific
cipher to 802.11-2007 (11i) will uphold that requirement. Using
different mechanisms like WAPI might run afoul of this check... But
technically WAPI could also use CCMP etc. and then you might have to use
non-zero even for CCMP, so this code would again be wrong.

OTOH, I don't really see a good way to capture this in code...

johannes

