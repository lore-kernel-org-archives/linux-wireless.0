Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC1958B6BA
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 16:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886211; cv=none; b=VNrzUV7DF1DBW4zBM7hB7vW35mQJbXYWu9bVayNyJfdGOvO64nJnenWlCwfbhfYsXppP/M0OnkT0KxTB+4D4+ANOtnFJH5kdlU24SYa6+vqGAXDvph8FeGnDHTNGL0dzZjLETQyybbHQ/VIJh1CfFIZYMqn3fT4XIw501L68tsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886211; c=relaxed/simple;
	bh=NDkMboDNQp1h3ckZyvzND7zGXOoGNEIsTFGiRphdgY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=W6cUYfjlpMWP2Jvw0Sy++3rMG70BnQrL5AoIuz/uHiWPxLA9GHvYCA5pUVotzti2h3fZ/jP/Z7cbcb3tDbCuH0bUVHocJXRzti2cQ3F6SOPJESpsIq2y2cPs0eRLOwnWJ9U7f+PNV1dret+WJBK/yzZcZhGpOiihRK48xsd7nXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=f6yjC98h; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="f6yjC98h"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C2D38980086;
	Tue,  8 Sep 2026 16:50:01 +0000 (UTC)
Received: from [192.168.100.159] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 1FE8013C2B1;
	Tue,  8 Sep 2026 09:50:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1FE8013C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1788886201;
	bh=NDkMboDNQp1h3ckZyvzND7zGXOoGNEIsTFGiRphdgY0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=f6yjC98hYQABZ0/O6rC8BcDZyvYZjrdLiZS98v4AxMtVQYtBiz0c/IPT9yOkTJE70
	 nyu1mlqvyzy/ytgnWlZg2YMJRymIj27WfC36piOtnbY9fD851zU4y8UyGJETkBW2Wx
	 mKQPg2MZ6tuUE2KcAAld9UAFRLoU9mvceUgCtUgA=
Message-ID: <dce34788-a6fb-b2e0-4657-aab3843111b6@candelatech.com>
Date: Tue, 8 Sep 2026 09:50:00 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all
 cfg80211_leave() calls
To: =?UTF-8?Q?=c3=96mer_Mete_Kaya?= <omermetekaya0@gmail.com>,
 linux-wireless@vger.kernel.org
References: <20260903151542.486376-2-omermetekaya0@gmail.com>
 <20260906002657.620076-1-omermetekaya0@gmail.com>
 <20260906002657.620076-2-omermetekaya0@gmail.com>
 <81a437a9-4ffd-4d6d-84c9-c093af5c46a5@candelatech.com>
 <b65da403-8144-4524-a076-5d25c86c0c14@gmail.com>
Content-Language: en-US
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <b65da403-8144-4524-a076-5d25c86c0c14@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MDID: 1788886202-5RK9GEJdMWl7
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1788886202;5RK9GEJdMWl7;<greearb@candelatech.com>;de889796e53c34c4d532d20f77e1c862
X-PPE-TRUSTED: V=1;DIR=OUT;

On 9/8/26 01:58, Ömer Mete Kaya wrote:
> 
> 
> On 9/7/26 19:38, Ben Greear wrote:
>> On 9/5/26 5:25 PM, Ömer Mete Kaya wrote:
>>> reg_check_chans_work() holds rtnl_mutex for the entire duration of
>>> iterating over all registered devices and calling cfg80211_leave() on
>>> each invalid wdev. cfg80211_leave() can be slow (disconnect, stop AP,
>>> leave mesh), causing rtnl_mutex starvation when many wireless interfaces
>>> are present. This results in tasks waiting for rtnl_mutex for longer
>>> than hung_task_timeout_secs:
>>>
>>>     INFO: task hung in inet_rtm_newaddr
>>>     INFO: task hung in inet6_rtm_newaddr
>>>     INFO: task hung in nsim_destroy
>>>     INFO: task hung in tun_chr_close
>>>     INFO: task hung in switchdev_deferred_process_work
>>
>> Hello Omer,
>>
>> Considering that maybe something has mis-diagnosed the problem, could
>> you share details of the stack traces of
>> the hung processes and lockdep output to see if the hang is actually
>> elsewhere?  What kernel version are you
>> testing?
>>
>> Thanks,
>> Ben
>>
> 
> 
> Hi Ben,
> 
> Here is the evidence with stack traces and lockdep output. My kernel
> version is 7.2.0-02677-g544d85de4dc2 (net/main HEAD) and both unpatched
> and patched kernels were tested on the same setup(52 mac80211_hwsim
> radios (mac80211_hwsim.radios=51)).
> 
> Unpatched kernel:
> 
> The lockdep output shows reg_check_chans_work as the rtnl_mutex holder
> and ip as the waiter:
> 
> locks held by kworker/0:2/11408: 3, on CPU#0:
> #1: (reg_check_chans).work
> #2: ffffffff91118180 (rtnl_mutex){+.+.}-{4:4},
> at: reg_check_chans_work+0xad/0x1330
> 
> locks held by ip/14180: 1, on CPU#0:
> #0: ffffffff91118180 (rtnl_mutex){+.+.}-{4:4},
> at: rtnl_getlink+0xbfb/0x13b0
> 
> Hung task call trace:
> 
> INFO: task ip:14180 blocked for more than 5 seconds.
> Call Trace:
> __schedule+0x1cba/0x6a40
> schedule+0xe2/0x2e0
> schedule_preempt_disabled+0x13/0x30
> __mutex_lock+0x871/0x1cc0
> rtnl_getlink+0xbfb/0x13b0
> rtnetlink_rcv_msg+0x9a1/0xee0
> netlink_rcv_skb+0x186/0x450
> netlink_sendmsg+0x8e5/0xde0
> 
> Kernel panic, not syncing: hung_task: blocked tasks
> 
> I injected msleep(200) per wdev in reg_leave_invalid_chans() to model a
> slow cfg80211_leave() operation, to measure the hold duration. With 52
> interfaces this produced approximately 10.5 seconds of
> continuous rtnl_mutex hold:
> 
> cfg80211: reg_check_chans_work: rtnl held for 10499 ms
> 
> The structural problem is clear regardless of the exact duration:
> rtnl_mutex is held across all per-interface cleanup for every
> registered device in a single acquisition.
> 
> Patched kernel:
> 
> rtnl_mutex is acquired per-device, each hold is brief:
> 
> cfg80211: reg_check_chans_work: device 0 rtnl held 0 ms
> cfg80211: reg_check_chans_work: device 1 rtnl held 0 ms
> ...
> cfg80211: reg_check_chans_work: device 51 rtnl held 0 ms
> 
> No hung tasks were observed.

At least my kernel tends to only warn about hung tasks that are blocked
for minutes.  Did you adjust your kernel to make this timeout smaller?

Do you actually have 52 real devices that cause this problem?  If so, what
hardware is this?  Or you can only reproduce this with modified kernel that
injects a 200ms sleep?

As a note, we've tested with 50+ real wifi radios in a system, and while we've seen deadlocks
due to something weird with CMA memory allocation in Intel be200 radios, our fix was
different (and never accepted upstream).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


