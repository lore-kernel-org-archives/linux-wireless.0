Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4399 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbZH1VkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 17:40:12 -0400
Message-ID: <4A984EBA.9040608@canonical.com>
Date: Fri, 28 Aug 2009 15:40:10 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: reinette chatre <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station inserted
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>	 <1251445557.4189.14.camel@johannes.local>	 <1251474321.3805.73.camel@rc-desk> <1251493298.3456.34.camel@johannes.local>
In-Reply-To: <1251493298.3456.34.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi Reinette,
> 
>> This work is motivated by an attempt to untangle the iwlwifi station
>> management to be able to use mac80211's sta notify callback. From 4965
>> and up the rate scaling in the device is done per station, so an entry
>> in the station table is required for the rate scaling initialization to
>> succeed. 
> 
> Interesting. I've been thinking about making it go the other way --
> remove rate scaling hooks completely. wl1271 apparently has rate scaling
> completely in the firmware, so the RS algorithm on the host is just
> overhead. I've been thinking putting 4965+ RS into the _driver_ makes
> more sense since it really does a lot in the firmware and not on the
> host.
> 
> Do you think we should try to go that route? I'd think it would probably
> be a hardware flag ("no RS algo please") and then we'd skip all the
> hooks and put things into the driver. The advantage is that we don't
> care about the mac80211 API any more, things get cleaner and we can just
> do all RS init from sta_notify().
> 

Wouldn't that make it difficult to experiment with external rate scaling 
algorithms? Not that minstrel or the other in-driver rate scaling 
algorithms always get it right, but they are certainly more transparent 
(and changeable) then firmware.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
