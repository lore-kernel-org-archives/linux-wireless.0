Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59814 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbZFAIQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 04:16:35 -0400
Received: by ewy24 with SMTP id 24so7647619ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 01:16:36 -0700 (PDT)
Message-ID: <4A238EA2.4040106@tuffmail.co.uk>
Date: Mon, 01 Jun 2009 09:17:38 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
References: <1243524688.10632.0.camel@johannes.local>	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>	 <1243763887.19302.29.camel@johannes.local>	 <1243796509.6570.35.camel@localhost.localdomain> <1243841639.5299.8.camel@johannes.local>
In-Reply-To: <1243841639.5299.8.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-05-31 at 21:01 +0200, Marcel Holtmann wrote:
>
>   
>>> You have a point there, but I'm not sure it even cares? When restarted
>>> it will probably want to impose its current policy anyway? It would be
>>> easy to add that we send the global default value for newly added ones
>>> too but I'm not sure it's necessary -- Marcel?
>>>       
>> we can be smart and send an additional CHANGE_ALL when opening the
>> control device if it is set. We can also just send these anyway. Doesn't
>> really matter? Does it?
>>     
>
> Well, I don't think we want/need this.
>
> See, Henrique says that the use case is Thinkpads which store the
> previous state in the BIOS. But that matters to you only if you use a
> mixture of operation systems, which we don't have to support.
>   

"Other OS's" also includes the BIOS.  My BIOS setup screen has an option 
to toggle the wireless state.  It's great to have this just work, and 
annoying to have regressions.

And it's not a "mixture" of operating systems if you dual-boot linux, 
but that will have the same problem.  We'll get rather weird behaviour 
if you dual boot A and B, where linux version A restores state to a 
file, and linux version B uses the hardware persistent state.

> On the other hand, people on machines that don't store the rfkill state
> in the BIOS might care about having their machine boot up with the same
> rfkill state(s) as they shut down with, so the sane thing to do would be
> to have rfkilld store the state persistently, and then recover it at
> boot. At which point the BIOS state becomes irrelevant and a detail we
> actually end up not even _wanting_ to support because it means we need
> to be aware of machine differences in userspace.
>   

Complexity sucks, but I don't think this is irrelevant.  I can see you 
don't want to rely on the kernel for the default value (even though it's 
controllable by module option).

I like one of the solutions Marcels suggested, that /dev/rfkill should 
report the "global default values" only when they have been set - either 
by userspace or by a platform driver.

Thanks
Alan
