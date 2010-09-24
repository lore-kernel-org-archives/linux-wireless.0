Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0IXVCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 17:02:55 -0400
Subject: Re: [wireless] wireless:  Keep phy name consistent across module
 reloads.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1285113431-25526-1-git-send-email-greearb@candelatech.com>
References: <1285113431-25526-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 23:02:50 +0200
Message-ID: <1285362170.11036.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 16:57 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> It adds needless pain to user-space scripts to change the name
> of the phy on each module reload.  Instead, find the first
> index.

Crap, I clearly missed this patch, John, please revert this.

We cannot do this because otherwise operations you attempt to do one one
PHY will race with re-creating of the same phy index. For the same
reason, interface indexes aren't reused for netdevs.

If this bothers you so much, you can easily write a udev rule that
renames all your phys to "myphy" or whatever.

johannes

