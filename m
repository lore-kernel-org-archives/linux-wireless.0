Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:4460 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbXD2Lzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 07:55:54 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1294893wxd
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2007 04:55:54 -0700 (PDT)
Message-ID: <247d6d340704290455y16db43ct5fa5c9a9af4d6dbe@mail.gmail.com>
Date: Sun, 29 Apr 2007 14:55:53 +0300
From: "Guy Cohen" <guycohencool@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Cc: "James Ketrenos" <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Jiri Benc" <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <200704271132.22346.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <200704262023.52833.flamingice@sourmilk.net>
	 <46317888.9040909@linux.intel.com>
	 <200704271132.22346.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

1) Saving 18 seconds of busy system will provide you much more time of
idle system. So the benefit is much more than 18 seconds per hour. The
calculation that you gave below is just incorrect.

2) CPU utilization/Power is a big deal for handheld devices. We can't
ignore it. Linux is gaining momentum in small factor devices and we
need to welcome any HW acceleration. The point that it is implemented
in FW doesn't change the fact that this is a HW offloading from the
host.

3) Sending Tune command for every channel from the stack when a HW is
capable of doing so, doesn't make sense. The latency and overhead is
redundant and will impact user experience (e.g. a [longer] glitch in
Video streaming, shorter battery life).

Guy.

On 4/27/07, Michael Wu <flamingice@sourmilk.net> wrote:
> Ok. Since you did not provide any numbers to back up that assertion, let's try
> to find the upper bound for the cost of using software scanning.
>
> With NetworkManager, userspace requests a scan about every 2 minutes when
> connected. Assume that each scan takes 3 seconds. Assume that things are
> ridiculously inefficient and software scanning keeps the cpu on for an
> additional 20% of the scanning time. This keeps the CPU on unnecessarily for
> 18 seconds every hour, assuming nothing else is running. With an additional
> assumption that all the additional CPU time that goes into software scan
> directly subtracts from the battery life, this results in a loss of about 2
> minutes and a half of battery life.. for a laptop that can last 8 hours.
>
> An upper bound of 18 seconds of battery life lost per hour sounds okay to me
> especially when it assumes the user is just letting the laptop idle. In
> practice, I think that the difference is going to be negligible.. but what I
> think is going to happen and my guess at the upper bound doesn't matter much.
> If you can provide numbers, this discussion becomes significantly more
> productive.
>
> -Michael Wu
>
>
