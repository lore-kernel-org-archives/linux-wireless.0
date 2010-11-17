Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55605 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874Ab0KQUNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 15:13:16 -0500
Message-ID: <4CE43756.9030403@candelatech.com>
Date: Wed, 17 Nov 2010 12:13:10 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com> <1289596096.3736.13.camel@jlt3.sipsolutions.net> <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com> <4CE292F7.4090200@kernel.org>
In-Reply-To: <4CE292F7.4090200@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2010 06:19 AM, Tejun Heo wrote:

>> Nov 15 13:12:13 localhost kernel: Showing all locks held in the system:
>> Nov 15 13:12:13 localhost kernel: 3 locks held by kworker/0:1/19:
>> Nov 15 13:12:13 localhost kernel: #0:  (events){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
>> Nov 15 13:12:13 localhost kernel: #1:  (wireless_nlevent_work){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
>> Nov 15 13:12:13 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
>> Nov 15 13:12:13 localhost kernel: 3 locks held by kworker/0:2/1054:
>> Nov 15 13:12:13 localhost kernel: #0:  (events){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
>> Nov 15 13:12:13 localhost kernel: #1:  ((&rdev->conn_work)){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
>> Nov 15 13:12:13 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
>
> Where are the backtraces for kworker/u:5, 0:1 and 0:2?

They are not in /var/log/messages either, at least not in the sysrq-t dump.
I think at least some of them are in there from the blocked-task printouts.

I've uploaded the /var/log/messages file here, in case you want to look
at it:

http://www.candelatech.com/~greearb/messages.gz

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

