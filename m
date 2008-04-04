Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26813 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYDDXLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 19:11:20 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: mac80211: ieee80211_ops.bss_info_changed question
Date: Fri, 4 Apr 2008 16:11:04 -0700
Message-ID: <D936D925018D154694D8A362EEB08920041CCC73@orsmsx416.amr.corp.intel.com> (sfid-20080405_001123_350041_5809E8D3)
In-Reply-To: <1207320205.19189.25.camel@johannes.berg>
References: <D936D925018D154694D8A362EEB08920041CC3C6@orsmsx416.amr.corp.intel.com> <1207320205.19189.25.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, April 04, 2008 7:43 AM, Johannes Berg  wrote:

> Reinette,
> 
>> In the comments about bss_info_changed it is said that the callback
>> has to be atomic. I was looking at it and could only find that it is
>> called either from the workqueue or an ioctl. It thus seems that we
>> may be able to sleep in there. I likely missed the spot where it
>> needs to be atomic ... could you please direct me to it?
> 
> I think you may be right, I can't find any spots either. I was likely
> mislead when writing that by the fact that much of the code in
> ieee80211_sta.c uses GFP_ATOMIC while it actually runs from a
> workqueue, which is actually confusing me still.

My mistake ... it can be called from tasklet during scanning
(ieee80211_sta_rx_scan). The comment that requires it to be atomic is
correct.

Reinette
