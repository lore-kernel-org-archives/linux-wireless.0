Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33064 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaJ0OTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 10:19:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [PATCH 0/3] Add mcast event when hwsim radios are created and removed
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1414411714.3836.7.camel@jlt4.sipsolutions.net>
Date: Mon, 27 Oct 2014 07:19:11 -0700
Cc: Jukka Rissanen <jukka.rissanen@linux.intel.com>,
	linux-wireless@vger.kernel.org
Message-Id: <1D755566-F088-454B-AEC5-C635FFCB488A@holtmann.org> (sfid-20141027_151926_681526_665BD87D)
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com> <1414408856.3836.3.camel@jlt4.sipsolutions.net> <1414409397.2705.198.camel@jrissane-mobl.ger.corp.intel.com> <1414409485.3836.5.camel@jlt4.sipsolutions.net> <1414410917.2705.201.camel@jrissane-mobl.ger.corp.intel.com> <1414411714.3836.7.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>>> That's not particularly hard to figure out, for example by looking at
>>> sysfs.
>>> 
>>> Is this really so time-constrained/important/... that you can't do that?
>> 
>> It does not seem very practical to dig this information from sysfs as
>> the same information can be easily get via netlink as this patch shows.
> 
> Well, that's a slippery slope. I'd consider it more practical to use
> existing APIs instead of (gratuitously) inventing new ones. It'll even
> work on older kernels as an added benefit.

I see that different. The component that handles the emulation of the new wireless device should be independent from the component driving it. I prefer to have a race free way of obtaining the needed information without having to monitor nl80211 and sysfs for this. Especially with the use cases that we have in mind it has no business with these other interfaces.

We have been down this route with the bridge interface where people had to dig out information from sysfs and it did not work out nicely. So now everything moves to netlink.

Regards

Marcel

