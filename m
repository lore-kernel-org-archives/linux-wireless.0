Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab0I2SFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 14:05:51 -0400
Subject: Re: [PATCH v3] mac80211:  Allow scanning single channel if other
 VIF is associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CA37B16.2040002@candelatech.com>
References: <1285708650-21858-1-git-send-email-greearb@candelatech.com>
	 <1285743733.3756.3.camel@jlt3.sipsolutions.net>
	 <4CA35BAB.8090701@candelatech.com>
	 <1285778901.3756.25.camel@jlt3.sipsolutions.net>
	 <4CA37B16.2040002@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 20:05:51 +0200
Message-ID: <1285783551.3756.30.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 10:44 -0700, Ben Greear wrote:

> > Also, I believe it needs matching code to not do all the return stuff
> > since we never left the channel, and I think it still needs to set
> > tmp_channel so that nothing will switch away underneath or so... not
> > quite sure.
> 
> Doesn't the remain_off_channel logic later in that method
> take care of not calling the return to channel logic?
> (Assuming I set the tmp_channel and tmp_channel_type as you suggest)?

If you set it, I believe it'll actually do the return work, and if you
leave it NULL it won't ... maybe just leaving it NULL is fine, as long
as we hope it won't switch away underneath, it probably shouldn't.

johannes

