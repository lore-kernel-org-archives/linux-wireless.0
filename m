Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36496 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab2LMTAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 14:00:18 -0500
Message-ID: <50CA25B1.3080901@candelatech.com> (sfid-20121213_200022_181487_2E19B9A0)
Date: Thu, 13 Dec 2012 11:00:01 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Add a new work-queue for destructing stations?
References: <50CA1470.4030107@candelatech.com>  (sfid-20121213_184629_945929_240FAE82) <1355421541.9463.8.camel@jlt4.sipsolutions.net>  <50CA1C44.5030300@candelatech.com>  <1355423047.9463.9.camel@jlt4.sipsolutions.net>  <50CA1EB6.9030903@candelatech.com>  <1355423836.9463.14.camel@jlt4.sipsolutions.net>  <50CA20D4.90707@candelatech.com>  <1355424117.9463.16.camel@jlt4.sipsolutions.net>  <50CA22BC.7090008@candelatech.com>  <1355424597.9463.17.camel@jlt4.sipsolutions.net>  (sfid-20121213_194937_732132_61453C42) <1355424835.9463.18.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355424835.9463.18.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2012 10:53 AM, Johannes Berg wrote:
> On Thu, 2012-12-13 at 19:49 +0100, Johannes Berg wrote:
>
>>>> Well the concern there is that we expose the workqueue to the driver,
>>>> and it might even put sdata-referencing work items on it and expect them
>>>> to be flushed out before stop_interface() is called?
>
> Wait actually, that isn't a concern. The flush_workqueue() was new in
> commit b22cfcfca, before that drivers couldn't rely on it. It seems very
> unlikely that in the meantime drivers have come to rely on it and we
> didn't document this, so ... with the proposed change to sta_free_wk we
> should be fine.

We still need to cancel the other mac80211 work items though, right?

I didn't understand your proposal for the sta_free_wk changes,
but I can at least work on tracking down the mac80211 work items
if that helps...

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

