Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53586 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbcDEJnN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:43:13 -0400
Message-ID: <1459849388.18188.28.camel@sipsolutions.net> (sfid-20160405_114316_243864_C1D12E22)
Subject: Re: [PATCH] mac80211: fix "warning:
 =?UTF-8?Q?=E2=80=98target=5Fmetric=E2=80=99?= may be used uninitialized"
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Mahoney <jeffm@suse.com>, linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 11:43:08 +0200
In-Reply-To: <5702AF3B.1070507@suse.com> (sfid-20160404_201525_372943_AA6833DD)
References: <5702AF3B.1070507@suse.com>
	 (sfid-20160404_201525_372943_AA6833DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-04-04 at 14:15 -0400, Jeff Mahoney wrote:
> This fixes:
> 
> net/mac80211/mesh_hwmp.c:603:26: warning: ‘target_metric’ may be used
> uninitialized in this function
> 
> target_metric is only consumed when reply = true so no bug exists
> here,
> but gcc doesn't notice that.  Initializing to 0 clears the warning.
> 

What gcc version are you using? Mine doesn't seem to have a problem
following the logic here.

johannes
