Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35238 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbcEOMX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2016 08:23:28 -0400
Received: by mail-ig0-f172.google.com with SMTP id bi2so39650192igb.0
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2016 05:23:28 -0700 (PDT)
Date: Sun, 15 May 2016 08:23:20 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, fred.veldini@gmail.com
Subject: Re: [PATCH] mac80211: mesh: flush mesh paths early in sta destroy
Message-ID: <20160515122320.GA3118@localhost> (sfid-20160515_142339_680110_575327AE)
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

On further reflection, using a flag for this is racy anyway, even if
quite narrow.  Maybe I should just flush in part2 unconditionally and have
a second synchronize_net().

-- 
Bob Copeland %% http://bobcopeland.com/
