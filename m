Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41488 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0FIIu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 04:50:57 -0400
Subject: Re: [PATCHv3] mac80211: Fix circular locking dependency in ARP
 filter handling
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>
In-Reply-To: <1276068754.3727.0.camel@jlt3.sipsolutions.net>
References: <1276066224-17880-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1276068754.3727.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 11:50:21 +0300
Message-ID: <1276073421.5277.33026.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 09:32 +0200, ext Johannes Berg wrote:
> On Wed, 2010-06-09 at 09:50 +0300, Juuso Oikarinen wrote:
> 
> > v3: - queue reconfig filter work to kernel default wq instead of mac80211 wq
> 
> I think it would make more sense to use a different lock instead, like
> the iflist mutex?

Yeah had that originally, but apparently the iflist mutex is acquired
*after* the mgd mutex in some places of the code, especially all around
mlme.c, and here I would have to acquire them in reverse order. So I
changed to the rtnl lock.

-Juuso


> johannes
> 


