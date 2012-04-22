Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58673 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2DVTyZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 15:54:25 -0400
Message-ID: <4F9461E9.2050504@openwrt.org> (sfid-20120422_215445_686596_B841687F)
Date: Sun, 22 Apr 2012 21:54:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH v3 2/2] mac80211: fix num_mcast_sta counting issues
References: <1335044533-37359-1-git-send-email-nbd@openwrt.org>  <1335044533-37359-2-git-send-email-nbd@openwrt.org> <1335045079.6516.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1335045079.6516.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-21 11:51 PM, Johannes Berg wrote:
> On Sat, 2012-04-21 at 23:42 +0200, Felix Fietkau wrote:
> 
>>  			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
>> +			new_4addr = true;
>>  		}
>>  
>> +		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
>> +		    sta->sdata->u.vlan.sta)
>> +			prev_4addr = true;
> 
> Doesn't that have to be before the assignment or something, otherwise
> it's always just true unless it was moved back to the AP iface, but
> still true if it was just assigned to an AP_VLAN iface?
This is just before the 'sta->sdata = vlansdata;' line, so it should be
OK. Or am I missing something here?

- Felix

