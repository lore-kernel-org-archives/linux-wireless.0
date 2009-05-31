Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56529 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZEaNR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 09:17:28 -0400
Received: by ewy24 with SMTP id 24so7265351ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 06:17:28 -0700 (PDT)
Message-ID: <4A2283A4.70106@tuffmail.co.uk>
Date: Sun, 31 May 2009 14:18:28 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
References: <1243524688.10632.0.camel@johannes.local>	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com> <1243763887.19302.29.camel@johannes.local>
In-Reply-To: <1243763887.19302.29.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-05-31 at 10:13 +0100, Alan Jenkins wrote:
>
>   
>> If I read correctly, userspace can write to the global states, but
>> can't read them?  I think it's awkward to implement rfkill-input in
>> userspace without being able to read the global states.  The daemon
>> would have to save the states in a file, in case it is restarted.
>>     
>
> You have a point there, but I'm not sure it even cares? When restarted
> it will probably want to impose its current policy anyway? It would be
> easy to add that we send the global default value for newly added ones
> too but I'm not sure it's necessary -- Marcel?
>
> johannes

This applies equally to the type-specific values; I think you'd get 
multiple "global default values".

I don't think restarting the daemon should necessarily impose a policy 
default state, because "whatever the kernel initialized it to" is 
actually a good default, when platform devices have persistent rfkill state.

Actually, I suppose it would meet my expectations if the daemon simply 
uses the state of an arbitrary rfkill device of each type, because the 
kernel initializes them all to the same value.  If you don't mind the 
slightly arbitrary looking code, it should be fine.

alan
