Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53006 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab0KRHIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 02:08:05 -0500
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mac80211:  Fix deadlock in =?UTF-8?Q?ieee=38=30=32=31=31=5Fdo?=
 =?UTF-8?Q?=5Fstop=2E?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Thu, 18 Nov 2010 08:07:58 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
In-Reply-To: <4CE4C8DD.6010806@kernel.org>
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org> <1290020005.3777.6.camel@jlt3.sipsolutions.net> <4CE4C8DD.6010806@kernel.org>
Message-ID: <51f5dd53c39a77fff4efc1a99b189725@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Nov 2010 07:34:05 +0100, Tejun Heo <tj@kernel.org> wrote:
>> No, I don't think it's safe for mac80211.
> 
> I see.  In the longer run tho, it would be much better to convert to
> NRT workqueue.  The behavior would be more robust with much lower
> latencies.

I really don't think it's possible without going to some scheme
where we use a single work struct and kick off things out of it,
or implement our own threading or similar things ...

But why is this unreliable and/or high latency anyway? It used
to be just fine .. maybe this is one of the cases where we should
actually be using a dedicated thread ...

johannes
