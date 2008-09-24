Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from winston.telenet-ops.be ([195.130.137.75]:49959 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYIXXAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 19:00:20 -0400
Message-ID: <48DAC681.9010305@telenet.be> (sfid-20080925_010026_499308_ACB8D668)
Date: Thu, 25 Sep 2008 01:00:17 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>	 (sfid-20080911_100535_000722_EE099914) <1222287287.4257.49.camel@johannes.berg>
In-Reply-To: <1222287287.4257.49.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
> On Thu, 2008-09-11 at 10:04 +0200, Marcel Holtmann wrote:
> 
>> So the best I got was the attached screenshot of an oops. It is  
>> clearly the iwlwifi driver crashing here and killing the machine, but  
>> I have no idea why.
> 
> Incidentally, if this really is the same bug I have, you might want to
> remove the iwlagn module completely, even loading it once is a bad
> thing, it has started to corrupt things here entirely by making DMA go
> to random locations.

with the release of -rc7 i was starting to wonder what had happened to this bug,
i'm not affected by it(other hardware) but from what i gather it's a serious problem?

i have always wondered what people affected by this find if they revert the
"memory allocation optimization" patch

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=da99c4b6c25964b90c79f19beccda208df1a865a

apologies if this is a too random stab in the dark, just sounds like we might want to fix this
before .27. And since there seems to be no git bisects that pinpoint the problem ..
i figured i might as well send this.

ian

> 
> johannes
