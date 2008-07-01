Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3837 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYGAUrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 16:47:03 -0400
Date: Tue, 1 Jul 2008 16:36:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Commit c4438fa71bf412862ed0b73111956b0ffd8209d3 breaks WPA
Message-ID: <20080701203658.GA9225@tuxdriver.com> (sfid-20080701_224709_770306_9729812D)
References: <486A9248.9000607@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <486A9248.9000607@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 01, 2008 at 03:23:36PM -0500, Larry Finger wrote:
> After the latest wireless-testing update, b43 was unable to connect to  
> my WPA network. Bisection leads to the following commit as the culprit:
>
> commit c4438fa71bf412862ed0b73111956b0ffd8209d3
> Author: Harvey Harrison <harvey.harrison@gmail.com>
> Date:   Thu Jun 26 13:21:50 2008 -0700
>
>     mac80211: remove ieee80211_get_hdr_info
>
>     Move the address selection into the michale_mic header calculation 
> helper
>     and pass a pointer to the ieee80211_hdr directly.
>
>     Reorganize ccmp_special_blocks while eliminating the unneeded  
> sa/da/qos
>     variables.
>
>     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> :040000 040000 c77af99ab0477f3ec3159af8566fb1de61856ab8  
> 7fa906d1d2acc6f9d88b923eed0990b9b14ea830 M      net
>
> This commit was confirmed as the problem by reverting it.

Luckily that is just in my "pending" stack.  I'll revert it ASAP.
Harvey, you are welcome to resubmit if you can tell us what broke
things! :-)

John
-- 
John W. Linville
linville@tuxdriver.com
