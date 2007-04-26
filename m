Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:10304 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753198AbXDZWRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 18:17:37 -0400
Message-ID: <46312067.9090005@linux.intel.com>
Date: Thu, 26 Apr 2007 14:57:59 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <462EE107.8040005@linux.intel.com> <20070425181656.GD5875@tuxdriver.com> <200704251634.16604.flamingice@sourmilk.net>
In-Reply-To: <200704251634.16604.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Wednesday 25 April 2007 14:16, John W. Linville wrote:
>> On Tue, Apr 24, 2007 at 10:03:03PM -0700, James Ketrenos wrote:
>>> (I would like to see hw_scan remain since iwlwifi uses it -- which we
>>> hope to submit as soon as the code restructuring is complete)
>> I was going to mention this in response to Michael's patch, but then
>> I checked your current iwlwifi git tree.  There your hw_scan routine
>> is commented-out, so I figured you didn't want/need it anymore...?
>>
...
> Besides the fact that what hw_scan does can be done by mac80211 for all 
> drivers,

With a penalty to battery life and an increase in the amount of time a scan takes.  There are improvements that can be made to make the software scanning faster, but at a penalty of added complexity on both the driver and the stack side -- for no *real* gain for users that have cards that can offload the scan.

> the use of the hw_scan callback breaks the AP autoconfiguration code 
> in ieee80211_sta.c due to its inadequate design. 

Is it breaking it just due to the auto-configuration code not knowing when to configure things?

> Calling hw_scan starts a 
> hardware scan, but there is no way to know when the scan is completed. 

That needs to be improved.

> Even if that problem were addressed, I still wouldn't like it as the design of 
> the hw_scan callback is deficient in a number of other ways and is completely 
> inapplicable to all other hardware/firmware softmac designs that I know.

Given that there are things we can do as a result of the hw_scan that we can't do on the host without imposing greater system load and slower scan results, I really don't want to lose the ability to support hardware offloading of scanning.

Could you voice some of the "other ways" the current hw_scan callback is deficient?

I'm fine with us overhauling how hw_scan works and integrates with the stack, but an all out ban on hardware scan offload just doesn't make sense.  The host can do all RC4 and AES encrypt/decrypt too but certainly we would prefer the hardware to do that for us, right?

In the short term, I would rather we leave hw_scan in the code and have the users that currently rely on hw_scan just have to manually configure the AP selection until such time as the in-kernel-AP-selection-policy code works with hw offloaded scan.

James
