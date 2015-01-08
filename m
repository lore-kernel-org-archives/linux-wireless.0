Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39773 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbbAHHlz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 02:41:55 -0500
Message-ID: <1420702907.2029.2.camel@sipsolutions.net> (sfid-20150108_084202_182023_384C47E0)
Subject: Re: [PATCH net-next] mac80211: silent build warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Ying Xue <ying.xue@windriver.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 08 Jan 2015 08:41:47 +0100
In-Reply-To: <1420700655-9427-1-git-send-email-ying.xue@windriver.com>
References: <1420700655-9427-1-git-send-email-ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-01-08 at 15:04 +0800, Ying Xue wrote:
> Silent the following build warnings:
> 
> net/mac80211/mlme.c: In function ‘ieee80211_rx_mgmt_beacon’:
> net/mac80211/mlme.c:1348:3: warning: ‘pwr_level_cisco’ may be used uninitialized in this function [-Wuninitialized]
> net/mac80211/mlme.c:1315:6: note: ‘pwr_level_cisco’ was declared here

We seem to get this every year or so... just upgrade your compiler and
it will be smart enough to prove that it's wrong here.

I really *don't* want to shut up the compiler forcefully since it will
cause modern compilers to *not* warn if it actually *is* unused - and 0
is not a useful value - this code is tricky enough and we want compiler
help in case we need to modify it in the future.

johannes

