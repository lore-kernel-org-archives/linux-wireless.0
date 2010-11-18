Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549Ab0KRSEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 13:04:34 -0500
Message-ID: <4CE56AAB.7080507@kernel.org>
Date: Thu, 18 Nov 2010 19:04:27 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org> <1290020005.3777.6.camel@jlt3.sipsolutions.net> <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost> <4CE4D41F.1080005@kernel.org> <4CE56892.9090606@candelatech.com>
In-Reply-To: <4CE56892.9090606@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Ben.

On 11/18/2010 06:55 PM, Ben Greear wrote:
> I understand your desire for a stack dump, but it appears that sysrq-t
> isn't getting everything you want, for whatever reason.

Can you please try again and investigate why it's not working?  If
task dump is not working as expected, there is a much more serious
problem than wireless locking up.

> Does my explanation of the rtnl deadlock that I posted near the beginning
> of this thread (with some backtraces to back that up) make sense, or
> are my assumptions invalid?

Yes, it makes sense.  At this point, I'm fairly sure that something is
holding the workqueue but I really can't tell anything without proper
stack dump.

Thanks.

-- 
tejun
