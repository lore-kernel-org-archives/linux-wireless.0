Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA86A4CC272
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 08:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788857918; cv=none; b=kbvtU+zJmUge7bCPltGLXv6xnU2xHy9hlcOdxMexv/P6ha//HTrTEpk/e1+SkDSx0UDN/7/Jv0fU7TW06gQNb60dQknndvQlLTIHs6UasKn6fS3CZ1+y/aFSDrUM08XUNijmRLVcXbQV9JwOp1nvgriPEhCNy4EjKH9QGccHTpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788857918; c=relaxed/simple;
	bh=1AtbTXMUYinJErgwC4kmn+v5nQ0OrRBC50bwHvSguqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lkPZj0c1XFhWCIkGkwc+Ntjk7afPWce6aIhRxRBY/2nhS4nDYAqJpJn7y4ZGV73su5tP4bmbFaDasjyS8OIN+gl6HvNtvMSyDpTaPboGjjiYpgRnSrehVduwMGhP51x/CZP9+Uz/LGgVenvCE1Jf2oWEowo/5oey/Zzk9flC14w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qv4fmR6o; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qv4fmR6o"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4843e9c5960so4271159f8f.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 01:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788857906; x=1789462706; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=onoOdBqWrm3MNGj+R4Amwa8k8oFmrOGKBskwyqUHINw=;
        b=Qv4fmR6oEhRlCptUJE+b/JUMo0Q2sWhxhNNB8jiw2nje3OqiMZHqJDdjpTHqZkgh5x
         /OGAYOs51n8ynkKJIQcVz8qYbDCNofpCrjgmF+4UGbuqvMqbrQ2PrIg3xNC+8f8spVfn
         U86iwkMsRQ38gbfmNGfvuhdSqxjOp6tWnujuh3GM19v7milpEdqqS1peFgB8OcrBbKL1
         ThOb+/SM4nad5aVQGdjfbPIKGK9mxL9ofdsqsHYM0D4fOrdCW8PLTT27aEki+cEz+kCj
         YnUbLizAOwBmK0C3vklAFKws/zlftNLfteABM5TuFCDLjKuMcECSnwdUiZsiDFWaaTuh
         NTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788857906; x=1789462706;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=onoOdBqWrm3MNGj+R4Amwa8k8oFmrOGKBskwyqUHINw=;
        b=J+dLQGkT9G4St0qYc8PkRuKZKoIxsf4S0Sp+HxKK+97H/V+c2EFZypox5o2MZP4huF
         CrRrZU8KnbsHdTeA53uWehyAzoC6PzBqSwdPgezj2M2Y4g3+YBGNs1gkrXUyJYOfHNIX
         kl6E9vq6C4lauixrU3WUwAayDlu5WXT7/eG8MaPuQmeoztbar3IuxHRNJn2xqcujoLB8
         z5gKAn5u5dgGDK6MSgFTJap2ZI+mHWZsG7qOuGVsS1OltrSCu5yjuaSiNbo4tKmqRYtW
         7HAuGJx3vlyfiYYM/ixN9n4jFDgHtHZePDsYrxQlo2uFhMP9c1B9iJ37Eme3SCKEBrUZ
         flKg==
X-Forwarded-Encrypted: i=1; AKwUvBye0Xf60pOlvfP/nt84bWL4VhWf1Ju/oOVvXzk3ct2BKOMSPiwbWwYEPqDuP3q2hS4oJxULOKRstcTNsoN+mg==@vger.kernel.org
X-Gm-Message-State: AFuF++lGoVBD/tw1+3HgU4vAP0FR45j2y3xlXCicvI6NsqkEdWBQKl77
	XSs+2iFtzQhjtlQYAppVxLzcCpQGs1TKniF+jtr54Fo5pGaznrqvxjD2AdFA0qroHMM=
X-Gm-Gg: AYBFou2KxnKyp8U3fM+uisRh1jARJsC+EbvUdvnlIbj4pE4ZTFQvxNNjPqXz7xIi31C
	I41IB/afu8CCzKwbSqWZIEyGdOAHWI7QGm/xDhvdTj7FaSZT658t+uGyY5wjzG3OumKZl3ibbvb
	2YG5jdgNSPxx7R9GTPVfnQDWmzUaXrUYtldTnzetZS9/aZE0wSCKEY20iIyBHvwWY8cFfK42jDY
	tW+GI+4Q9Hkp7V2tVhqpEAU7XlJZxePi+YAABm2EUPTjY1IMzfL6rmGM/N2V6+1k6qAqyHhzCr0
	jlisWghsM/SJK7otymhO2hraZ0FSwyXn6hgjKMQ5dpYhpUYaHNRof2RPRWZgwIIk+IO00fXhiY+
	1OFVJZjeXcYWCAZMgTt++uS5d8QFYcKrBm0ef/aUQsv5zOKCUeNFVaC8CAJsqRBx4U+0MJ6KEx2
	dCK0nIg7jOE8+mp0ktJgyxFWx5hHJlmrjcIAm4oIoE6GA9H4KGfe5YRwlfKqHMB29ZCApgVE9S1
	RbcLUM3
X-Received: by 2002:a5d:5d83:0:b0:485:8c16:5eec with SMTP id ffacd0b85a97d-4858c166045mr23990510f8f.38.1788857906198;
        Tue, 08 Sep 2026 01:58:26 -0700 (PDT)
Received: from [192.168.18.21] ([46.197.185.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4859207c28fsm29191671f8f.5.2026.09.08.01.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 01:58:25 -0700 (PDT)
Message-ID: <b65da403-8144-4524-a076-5d25c86c0c14@gmail.com>
Date: Tue, 8 Sep 2026 11:58:24 +0300
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
Content-Language: en-US
From: =?UTF-8?Q?=C3=96mer_Mete_Kaya?= <omermetekaya0@gmail.com>
In-Reply-To: <81a437a9-4ffd-4d6d-84c9-c093af5c46a5@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/7/26 19:38, Ben Greear wrote:
> On 9/5/26 5:25 PM, Ömer Mete Kaya wrote:
>> reg_check_chans_work() holds rtnl_mutex for the entire duration of
>> iterating over all registered devices and calling cfg80211_leave() on
>> each invalid wdev. cfg80211_leave() can be slow (disconnect, stop AP,
>> leave mesh), causing rtnl_mutex starvation when many wireless interfaces
>> are present. This results in tasks waiting for rtnl_mutex for longer
>> than hung_task_timeout_secs:
>>
>>    INFO: task hung in inet_rtm_newaddr
>>    INFO: task hung in inet6_rtm_newaddr
>>    INFO: task hung in nsim_destroy
>>    INFO: task hung in tun_chr_close
>>    INFO: task hung in switchdev_deferred_process_work
> 
> Hello Omer,
> 
> Considering that maybe something has mis-diagnosed the problem, could
> you share details of the stack traces of
> the hung processes and lockdep output to see if the hang is actually
> elsewhere?  What kernel version are you
> testing?
> 
> Thanks,
> Ben
> 


Hi Ben,

Here is the evidence with stack traces and lockdep output. My kernel
version is 7.2.0-02677-g544d85de4dc2 (net/main HEAD) and both unpatched
and patched kernels were tested on the same setup(52 mac80211_hwsim
radios (mac80211_hwsim.radios=51)).

Unpatched kernel:

The lockdep output shows reg_check_chans_work as the rtnl_mutex holder
and ip as the waiter:

locks held by kworker/0:2/11408: 3, on CPU#0:
#1: (reg_check_chans).work
#2: ffffffff91118180 (rtnl_mutex){+.+.}-{4:4},
at: reg_check_chans_work+0xad/0x1330

locks held by ip/14180: 1, on CPU#0:
#0: ffffffff91118180 (rtnl_mutex){+.+.}-{4:4},
at: rtnl_getlink+0xbfb/0x13b0

Hung task call trace:

INFO: task ip:14180 blocked for more than 5 seconds.
Call Trace:
__schedule+0x1cba/0x6a40
schedule+0xe2/0x2e0
schedule_preempt_disabled+0x13/0x30
__mutex_lock+0x871/0x1cc0
rtnl_getlink+0xbfb/0x13b0
rtnetlink_rcv_msg+0x9a1/0xee0
netlink_rcv_skb+0x186/0x450
netlink_sendmsg+0x8e5/0xde0

Kernel panic, not syncing: hung_task: blocked tasks

I injected msleep(200) per wdev in reg_leave_invalid_chans() to model a
slow cfg80211_leave() operation, to measure the hold duration. With 52
interfaces this produced approximately 10.5 seconds of
continuous rtnl_mutex hold:

cfg80211: reg_check_chans_work: rtnl held for 10499 ms

The structural problem is clear regardless of the exact duration:
rtnl_mutex is held across all per-interface cleanup for every
registered device in a single acquisition.

Patched kernel:

rtnl_mutex is acquired per-device, each hold is brief:

cfg80211: reg_check_chans_work: device 0 rtnl held 0 ms
cfg80211: reg_check_chans_work: device 1 rtnl held 0 ms
...
cfg80211: reg_check_chans_work: device 51 rtnl held 0 ms

No hung tasks were observed.


Best regards,
Ömer Mete Kaya
