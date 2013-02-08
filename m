Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55322 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3BHNcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 08:32:11 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20756.65038.7020.514691@gargle.gargle.HOWL> (sfid-20130208_143216_295293_7EA9F90C)
Date: Fri, 8 Feb 2013 19:00:54 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
In-Reply-To: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> In many tests throughput with ath9k_rate_control has been shown to be
> worse than with minstrel_ht (the mac8021 default RC).
> 
> This module also has some other problems, like starting to use the
> highest possible rate early in the connection, causing problems with
> reliability of connection/authentication attempts.
> 
> It also has a much more limited search space, ignoring many potentially
> useful rates, caused by the design decision to operate on a sorted rate
> set with the assumption that higher rates are always more unreliable
> than lower rates. In some scenarios this assumption is not true, and
> this can cause it to fall back to a really bad rate.
> 
> minstrel_ht has been tested extensively in AP and client mode by lots of
> users (mostly in the OpenWrt project, where it has been the default for
> years).
> 
> The only advantage that ath9k_rate_control previously had over minstrel_ht
> was the support for using CCK rates as fall back in case MCS rates got
> too bad, but this has now also been taken care of.

Various rates are marked as invalid in the ath9k rate control module. I don't
know all the reasons, but the recommendation to disable certain rates came from
the internal algorithms team. How will this be handled ?

Sujith
