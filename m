Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37408 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbcDFNOt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 09:14:49 -0400
Message-ID: <1459948485.17504.76.camel@sipsolutions.net> (sfid-20160406_151452_846779_D35BC872)
Subject: Re: [PATCH] mac80211: fix "warning:
 =?UTF-8?Q?=E2=80=98target=5Fmetric=E2=80=99?= may be used uninitialized"
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Mahoney <jeffm@suse.com>, linux-wireless@vger.kernel.org
Date: Wed, 06 Apr 2016 15:14:45 +0200
In-Reply-To: <5702AF3B.1070507@suse.com>
References: <5702AF3B.1070507@suse.com>
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

Applied.

johannes
