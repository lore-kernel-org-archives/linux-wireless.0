Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51403 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3JJVfk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 17:35:40 -0400
Message-ID: <52571DAA.60502@openwrt.org> (sfid-20131010_233543_462500_083CD511)
Date: Thu, 10 Oct 2013 23:35:38 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in commit 0d528d8
References: <52571723.5020000@lwfinger.net>
In-Reply-To: <52571723.5020000@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-10-10 11:07 PM, Larry Finger wrote:
> Commit 0d528d8 by Felix Fietkau, entitled "mac80211: improve the rate control 
> API", causes the rtlwifi-family of drivers to be unable to connect to an 802.11g 
> network. A bisection led to this commit, which was confirmed by reversing the patch.
> 
> The drivers can connect to a 802.11n networks, which is why the problem has gone 
> undetected from kernel 3.10 till now.
> 
> These drivers use the rate-control mechanism in their firmware. I suspect that 
> this is causing the problem. What actions do the drivers need to take that were 
> not required before this patch?
I don't recall any necessary extra actions introduced by this patch.
Please compare the rate selection info passed to the driver before and
after this patch, by dumping info->control.rates.

- Felix
