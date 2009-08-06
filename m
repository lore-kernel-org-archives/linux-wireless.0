Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1087 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbZHFUj2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 16:39:28 -0400
Subject: Re: [PATCH] cfg80211: fix disassociation warning due to misuse of
 wdev->current_bss
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1249564158.4852.24.camel@johannes.local>
References: <20090806085242.23637.82992.stgit@ct.roinet.com>
	 <1249549574.4852.17.camel@johannes.local>  <1249563308.15613.9.camel@ct>
	 <1249564158.4852.24.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 16:39:24 -0400
Message-Id: <1249591164.19169.41.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-06 at 15:09 +0200, Johannes Berg wrote:
> On Thu, 2009-08-06 at 08:55 -0400, Pavel Roskin wrote:
> 
> > Now that the check is fixed, it turn out there is a related problem in
> > the same function.  If the device is in the managed mode and disconnects
> > from an AP due to a low signal,
> 
> Who decides to disconnect?

I was unscrewing the antenna from the AP, and the AP wasn't visible in
the scan results without an antenna, so I assume that the station was
deciding to disconnect on its own.

> This isn't making any sense to me. Once you're connected,
> wdev->auth_bsses[i] shouldn't be set any more.

I see that you have posted several patches for the issue.  I'll test
them on the same hardware tomorrow to avoid introducing extra variables.

-- 
Regards,
Pavel Roskin
