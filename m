Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34090 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbcEOAHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2016 20:07:15 -0400
Received: by mail-io0-f171.google.com with SMTP id 190so173303129iow.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 May 2016 17:07:14 -0700 (PDT)
Date: Sat, 14 May 2016 20:07:07 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, fred.veldini@gmail.com
Subject: Re: [PATCH] mac80211: mesh: flush mesh paths early in sta destroy
Message-ID: <20160515000707.GA29555@localhost> (sfid-20160515_020726_188162_5147D43C)
References: <1463248198-3926-1-git-send-email-me@bobcopeland.com>
 <f898e5e4-e27a-ff5e-6deb-ed109f6ce168@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f898e5e4-e27a-ff5e-6deb-ed109f6ce168@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2016 at 08:54:13PM +0200, Felix Fietkau wrote:
> > +	WLAN_STA_BLOCK_MPATH,
> I think this flag needs to be added to sta_flag_names in debugfs_sta.c
> 
> - Felix

Good point.  I also missed the part where mesh_path_assign_nexthop
should return an error to indicate the path shouldn't be activated.

So, I'll send a v2 tomorrow, additional comments welcome in the
meantime.

-- 
Bob Copeland %% http://bobcopeland.com/
