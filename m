Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:38599 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0LQJ51 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 04:57:27 -0500
Message-ID: <4D0B33F9.2030302@kernel.org>
Date: Fri, 17 Dec 2010 10:57:13 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT] rtlwifi: use alloc_workqueue
References: <1292529589-5904-1-git-send-email-linville@tuxdriver.com> <4D0ADCBC.1000300@lwfinger.net>
In-Reply-To: <4D0ADCBC.1000300@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 12/17/2010 04:45 AM, Larry Finger wrote:
> On 12/16/2010 01:59 PM, John W. Linville wrote:
>> create_workqueue is deprecated.  The workqueue usage does not seem to
>> demand any special treatment, so do not set any flags either.
>>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> ---
>> I don't have the hardware to test...
> 
> Hold off on this one. It seems to break the driver, but I do not
> know why just yet.

There are two differences between create_workqueue(name) and
alloc_workqueue(name, 0, 0).

* The former has WQ_MEM_RECLAIM set and forward progress is guaranteed
  regardless of memory pressure.  In this case, this shouldn't make
  any difference.

* The former has @max_active set to 1 while the latter to
  WQ_DFL_ACTIVE.  IOW, works queued on the same CPU would be allowed
  to run concurrently while before conversion only different CPUs can
  run works queued to the workqueue in parallel.  This usually
  shouldn't make difference either as works could have run in parallel
  on different CPUs before too.

Does alloc_workqueue(name, 0, 1) fix the problem?  If so, it might be
that the current workqueue usage has problem too.

Thanks.

-- 
tejun
