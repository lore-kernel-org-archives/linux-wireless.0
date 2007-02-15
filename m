Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:33993 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030438AbXBOSQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 13:16:51 -0500
Message-ID: <45D4A37D.8000203@linux.intel.com>
Date: Thu, 15 Feb 2007 19:16:29 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: round_jiffies for schedule_delayed_work?
References: <1171489163.6093.30.camel@johannes.berg> <20070215150615.GB3310@tuxdriver.com>
In-Reply-To: <20070215150615.GB3310@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Feb 14, 2007 at 10:39:23PM +0100, Johannes Berg wrote:
>> Hi,
>>
>> I was looking through recent commits in wireless-dev and found
>> e226b8aa8921b6b75dcd0142a990b8c7bc1548fd which is correct, but I was
>> wondering if it may be possible to do it more efficiently.
>>
>> We don't really need this code running every second after we init,
>> having it run every second on average is good enough. I don't see any
>> way to do this with the delayed work API though since
>> schedule_delayed_work simply adds the timer at jiffies+delay.
>>
>> Should we be using a timer and round_jiffies() instead?
> 
> Using round_jiffies seems reasonable.  Perhaps the delayed work API
> can be extended to use it?

there is round_jiffies_relative() you can use for this kind of purpose....
