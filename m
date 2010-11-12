Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:56201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab0KLKPz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 05:15:55 -0500
Message-ID: <4CDD13D1.9070608@kernel.org>
Date: Fri, 12 Nov 2010 11:15:45 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com> <1289437356.3748.25.camel@jlt3.sipsolutions.net> <4CDBB716.7020802@kernel.org> <4CDC2016.8020200@candelatech.com> <4CDC354C.2060503@candelatech.com> <4CDC7860.3070307@candelatech.com> <4CDD12BD.7030208@kernel.org>
In-Reply-To: <4CDD12BD.7030208@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a bit of addition.

On 11/12/2010 11:11 AM, Tejun Heo wrote:
> It depends on what the work being flushed was doing.  Which one is it
> trying to flush?  Also, if the memory pressure is high enough, due to
> the dynamic nature of workqueue, processing of works can be delayed
> while trying to create new workers to process them.

Please note that under those circumstances, what's guaranteed is
forward-progress for workqueues which are used during memory reclaim.
Continuously scheduling works which will in turn pile up on rtnl_lock
is akin to constantly allocating memory while something holding
rtnl_lock is blocked due to memory pressure.  Correctness-wise, it
isn't necessarily deadlock but the only possible recourse is OOM.

Thanks.

-- 
tejun
