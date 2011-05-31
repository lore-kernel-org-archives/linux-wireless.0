Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38763 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1EaTqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:46:32 -0400
Message-ID: <4DE54596.8090003@openwrt.org> (sfid-20110531_214635_078381_7E4FC85B)
Date: Tue, 31 May 2011 21:46:30 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/3] mac80211: create a STA entry for a WDS interface
 after receiving a beacon
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>	 <1306869394-83047-2-git-send-email-nbd@openwrt.org> <1306870318.29989.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1306870318.29989.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-31 9:31 PM, Johannes Berg wrote:
> On Tue, 2011-05-31 at 21:16 +0200, Felix Fietkau wrote:
>
>>  +	rcu_read_lock();
>>  +
>>  +	sta = sta_info_get(sdata, sdata->u.wds.remote_addr);
>>  +
>>  +	if (!sta) {
>>  +		rcu_read_unlock();
>>  +		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
>>  +				     GFP_KERNEL);
>>  +		if (!sta)
>>  +			return;
>>  +
>>  +		new = true;
>>  +	}
>
> ...
>
>>  +	rcu_read_unlock();
>
> definitely doesn't look right.
It's a bit weird because in the case of a new sta being allocated, the 
rcu read lock is acquired by sta_info_insert_rcu, and the code inbetween 
does not need to be covered by the rcu read lock as the sta entry has 
not been added to the list yet.
It should be correct though, unless I'm missing something...

- Felix
