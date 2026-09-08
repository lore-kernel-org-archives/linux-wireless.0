Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBDE544890
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 19:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897154; cv=none; b=qaXDjbLzrGFukHogh6G32gTKBlEgbqvvJ/A4FVmySYtOZS+/7XvRhsfhy4zzoiFEtPeq67N5J9zuslSjBFWBAUx8GIzN2axlGdrIJL1dgCKoRmt401sHext1IoacyHoRp6hl+V6yk8afp2FuG/YHOtlVgxmg3fA1HVEhCEGIrno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897154; c=relaxed/simple;
	bh=U5gyc3WUAS5LciUY3u+0AlVjH29s9NYZ7/BuhfYjtPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LgTKA+pN32dVPYsfZIpKOOTqmkr8w0cqqmt4lyW1/Epca/IWzuWQkOvn8OJeY2FQiLIPFrdIR05dvzFIoSxqDNex3AW7CuzC4Yc/89uKQ4/oOFUaNgikBIOT4VvJJ+F/LIX/+ityZnEm2oYor2j9qAmSqjNZrwDRVy0ENWcwEg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8uQ9MQz; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8uQ9MQz"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49954b88fffso37656245e9.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 12:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788897150; x=1789501950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=etpaJElhhexy5dBKAQiQB0UC9/SPwYp72YBuUL2oYlg=;
        b=H8uQ9MQz3TEaZuylK+ZShPFPmoQFuk9aX4Xx/v0XUCka6LZV9pihY07X3ra0YjFvkX
         NSSC1TbJ3ER8RzpVDS0dZQzLmNZhy8IgQmO5lSt6GVxfP139RPQ4XTStAlfSrArlL1vA
         IY8Vrzu92rPcvR9lSF/2S23FAPvhYDgk32vPg6YvbSUfbpKlVuKUzaUxRvzStzNKiR2E
         oZAUAFptAUWXccpsTA0YrUL2E0DOAAx/XtpA+runamF8bo/jXiXwsA0MfWufkRflgUJr
         N1bu0X3enBfkUHPP6rSpSaGGMEpYSzt63J1/oiNYvXlTYVSAKQMbcme1+lJSu/UiSRc2
         9djQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788897150; x=1789501950;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=etpaJElhhexy5dBKAQiQB0UC9/SPwYp72YBuUL2oYlg=;
        b=H158m80Y5W/UQGSDneCJPN3VsNqb93T60J9gIjSTjJO8g2AcmYYmNDgxU0ez0v+p8L
         mT82oBx436Ewx22XbSHbRabn/es2oVscRcACSZoW4G6xbqUTbHjwCMToAYl/BxUMva7y
         tFK2RN5C6vZcEAvMERcaWSqUV8jUvxlXMOZ6abUFtPbP5QC8lx+IURXGyrhFW8qPyyK8
         buPbQfYD21AD3lSAh45znAF4d+2qysZUMqr2U0tDx2dDX1Jpg1/Ay3suPxq2KPNOiPol
         nPfBUfG86ZesrALwjgenoLB4uUFDQYIxJuNGcK36M+ThdaE4EZnU6vj1Ikr//+h50VtW
         oR0g==
X-Forwarded-Encrypted: i=1; AKwUvByi/MnjJcxOd3odG2ZjS6llFErFFxS31GCQx4JqxZ3Gwv3qABOzXqvmZy3HpOqvxzJNU/hopd0guGYZsxQPVg==@vger.kernel.org
X-Gm-Message-State: AFuF++nBd/VKMqZAmqlh2DWhGmNu1L6XfS0xz841UxWvxeSFsJrwP8t3
	veOtVNVdBoeIRsrEq7uZswGIRL5+RQhqamTTQjPiVZvES46knRJnCvxwQkxJBKoN4/M=
X-Gm-Gg: AYBFou1d4a260kSGOH8cZhrF1/gCfbx7y/j9sCRBP521qhzkNrugCPkTgByZ76lrTIC
	NHrKit1TO/zodfUid0CYLHayrAmk1jbWf0Uhksfkf/kUIDJDfdH73w4N8gH28va9qhAT365kUhb
	bICG0p6n5WFb1C2DfWssexWyGb84JAwngorWKdOzi1shCblKVkg0fuxL77kgBjN7nDw30RCiamz
	lmGULOIt6+whAbAiYW3eOf53KQojxlR/1eAE/+aruamQWTux48AMWh53tuZI9joWy3z2SX9rj0v
	XugvBObGVwr/64kI2mZK+YeexE8qljkU4WR2KCy+qLd6NStD2l8AjpIkeeqkozCaaMGT+4iMiGt
	BUYbp0/9g3X0jTN2QiGy1zcQGQqAn7Ac31+ZuIkUb3IfwAD7SfRkXXNRnHEUjEqv2NB9+px8bah
	xDwdCLZ2RVAlLmDSJXzxQDzx8Jrft6OVaZru9+gKNWYpYHFCsE58zG2acRITpMpmnq4cx7jQ==
X-Received: by 2002:a05:600c:a0b:b0:49c:cee2:1697 with SMTP id 5b1f17b1804b1-49cf8262133mr317984435e9.16.1788897149865;
        Tue, 08 Sep 2026 12:52:29 -0700 (PDT)
Received: from [192.168.18.21] ([46.197.185.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm323544805e9.13.2026.09.08.12.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 12:52:29 -0700 (PDT)
Message-ID: <faf385e5-5fe7-4b66-bd06-e5f9a88d12ba@gmail.com>
Date: Tue, 8 Sep 2026 22:52:28 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all
 cfg80211_leave() calls
To: Ben Greear <greearb@candelatech.com>, linux-wireless@vger.kernel.org
References: <20260903151542.486376-2-omermetekaya0@gmail.com>
 <20260906002657.620076-1-omermetekaya0@gmail.com>
 <20260906002657.620076-2-omermetekaya0@gmail.com>
 <81a437a9-4ffd-4d6d-84c9-c093af5c46a5@candelatech.com>
 <b65da403-8144-4524-a076-5d25c86c0c14@gmail.com>
 <dce34788-a6fb-b2e0-4657-aab3843111b6@candelatech.com>
Content-Language: en-US
From: =?UTF-8?Q?=C3=96mer_Mete_Kaya?= <omermetekaya0@gmail.com>
In-Reply-To: <dce34788-a6fb-b2e0-4657-aab3843111b6@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/8/26 19:50, Ben Greear wrote:
> On 9/8/26 01:58, Ömer Mete Kaya wrote:
>>
>>
>> On 9/7/26 19:38, Ben Greear wrote:
>>> On 9/5/26 5:25 PM, Ömer Mete Kaya wrote:
>>>> reg_check_chans_work() holds rtnl_mutex for the entire duration of
>>>> iterating over all registered devices and calling cfg80211_leave() on
>>>> each invalid wdev. cfg80211_leave() can be slow (disconnect, stop AP,
>>>> leave mesh), causing rtnl_mutex starvation when many wireless
>>>> interfaces
>>>> are present. This results in tasks waiting for rtnl_mutex for longer
>>>> than hung_task_timeout_secs:
>>>>
>>>>     INFO: task hung in inet_rtm_newaddr
>>>>     INFO: task hung in inet6_rtm_newaddr
>>>>     INFO: task hung in nsim_destroy
>>>>     INFO: task hung in tun_chr_close
>>>>     INFO: task hung in switchdev_deferred_process_work
>>>
>>> Hello Omer,
>>>
>>> Considering that maybe something has mis-diagnosed the problem, could
>>> you share details of the stack traces of
>>> the hung processes and lockdep output to see if the hang is actually
>>> elsewhere?  What kernel version are you
>>> testing?
>>>
>>> Thanks,
>>> Ben
>>>
>>
>>
>> Hi Ben,
>>
>> Here is the evidence with stack traces and lockdep output. My kernel
>> version is 7.2.0-02677-g544d85de4dc2 (net/main HEAD) and both unpatched
>> and patched kernels were tested on the same setup(52 mac80211_hwsim
>> radios (mac80211_hwsim.radios=51)).
>>
>> Unpatched kernel:
>>
>> The lockdep output shows reg_check_chans_work as the rtnl_mutex holder
>> and ip as the waiter:
>>
>> locks held by kworker/0:2/11408: 3, on CPU#0:
>> #1: (reg_check_chans).work
>> #2: ffffffff91118180 (rtnl_mutex){+.+.}-{4:4},
>> at: reg_check_chans_work+0xad/0x1330
>>
>> locks held by ip/14180: 1, on CPU#0:
>> #0: ffffffff91118180 (rtnl_mutex){+.+.}-{4:4},
>> at: rtnl_getlink+0xbfb/0x13b0
>>
>> Hung task call trace:
>>
>> INFO: task ip:14180 blocked for more than 5 seconds.
>> Call Trace:
>> __schedule+0x1cba/0x6a40
>> schedule+0xe2/0x2e0
>> schedule_preempt_disabled+0x13/0x30
>> __mutex_lock+0x871/0x1cc0
>> rtnl_getlink+0xbfb/0x13b0
>> rtnetlink_rcv_msg+0x9a1/0xee0
>> netlink_rcv_skb+0x186/0x450
>> netlink_sendmsg+0x8e5/0xde0
>>
>> Kernel panic, not syncing: hung_task: blocked tasks
>>
>> I injected msleep(200) per wdev in reg_leave_invalid_chans() to model a
>> slow cfg80211_leave() operation, to measure the hold duration. With 52
>> interfaces this produced approximately 10.5 seconds of
>> continuous rtnl_mutex hold:
>>
>> cfg80211: reg_check_chans_work: rtnl held for 10499 ms
>>
>> The structural problem is clear regardless of the exact duration:
>> rtnl_mutex is held across all per-interface cleanup for every
>> registered device in a single acquisition.
>>
>> Patched kernel:
>>
>> rtnl_mutex is acquired per-device, each hold is brief:
>>
>> cfg80211: reg_check_chans_work: device 0 rtnl held 0 ms
>> cfg80211: reg_check_chans_work: device 1 rtnl held 0 ms
>> ...
>> cfg80211: reg_check_chans_work: device 51 rtnl held 0 ms
>>
>> No hung tasks were observed.
> 
> At least my kernel tends to only warn about hung tasks that are blocked
> for minutes.  Did you adjust your kernel to make this timeout smaller?

Yes, I reduced hung_task_timeout_secs to 5 seconds for the test.
With the default 140-second timeout my reproduction would not have
triggered a hang, though syzbot does with that timeout. Actually, I've
started to have doubts about the extent of its real-world impact, it
depends heavily on callback latency and number of active interfaces.

> Do you actually have 52 real devices that cause this problem?  If so, what
> hardware is this?  Or you can only reproduce this with modified kernel that
> injects a 200ms sleep?

I used mac80211_hwsim virtual radios,
and the hang could only be reproduced with artificial delays.
The 200ms value was chosen as a rough estimate of a slow
driver callback, not based on measured real hardware latency.

actual syzbot crash report :

  locks held by kworker running reg_check_chans_work:
    #2: rtnl_mutex, at: reg_check_chans_work+0xac net/wireless/reg.c:2469
    #3: wiphy.mtx,  at: reg_check_chans_work+0x1a1 net/wireless/reg.c:2472

  locks held by syz-executor (inet6_rtm_newaddr):
    #0: rtnl_mutex, at: inet6_rtm_newaddr+0x65e

  INFO: task syz-executor blocked for more than 143 seconds.

This directly shows reg_check_chans_work holding rtnl_mutex while
inet6_rtm_newaddr waits — 143 seconds, with the default timeout.

Regarding my earlier test: with mac80211_hwsim virtual radios,
cfg80211_leave() takes 0 ms per interface. Syzbot also uses virtual
radios, why does it take 143 seconds there?
Maybe because syzbot creates hundreds of wireless
interfaces across many network namespaces simultaneously, making the
loop over all devices very long.

My analysis was primarily code-based, reg_check_chans_work() holds
rtnl_mutex across all devices in a single acquisition, and
cfg80211_leave() can invoke slow driver operations. The lockdep
output confirms the structural issue exists.

> As a note, we've tested with 50+ real wifi radios in a system, and while
> we've seen deadlocks
> due to something weird with CMA memory allocation in Intel be200 radios,
> our fix was
> different (and never accepted upstream).
> 
> Thanks,
> Ben
> 
Thank you too,
Ömer Mete

