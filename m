Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3AXOrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 09:47:24 -0500
Message-ID: <1359038863.21908.0.camel@jlt4.sipsolutions.net> (sfid-20130124_154729_845796_BEAB11EA)
Subject: Re: [patch] cfg80211: off by one in ieee80211_bss()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 24 Jan 2013 15:47:43 +0100
In-Reply-To: <20130124064000.GB5611@elgon.mountain>
References: <20130124064000.GB5611@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-24 at 09:40 +0300, Dan Carpenter wrote:
> We do a:
> 
> 	sprintf(buf, " Last beacon: %ums ago",
> 		elapsed_jiffies_msecs(bss->ts));
> 
> elapsed_jiffies_msecs() can return a 10 digit number so "buf" needs to
> be 31 characters long.

Applied, thanks.

johannes

