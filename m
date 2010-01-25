Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:51664 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab0AYAFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 19:05:50 -0500
Message-ID: <4B5CE054.9020306@scram.de>
Date: Mon, 25 Jan 2010 01:05:40 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: Breakage in software encryption (iwl3945)
References: <1264277460.13250.10.camel@maxim-laptop>	 <1264330613.23766.17.camel@johannes.local> <1264357465.4152.4.camel@maxim-laptop> <4B5CD773.1010107@scram.de>
In-Reply-To: <4B5CD773.1010107@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jochen Friedrich wrote:
> Hi Maxim,
> 
>>> On Sat, 2010-01-23 at 22:10 +0200, Maxim Levitsky wrote:
>>>> I updated the kernel and lost connection to my WPA2
>>>> AP. Strangely the WPA handshake completes, but DHCP not.
>>> What did you upgrade to?
>> latest -git of wireless-testing
> 
> I have the same problem since compat-wireless-2010-01-20 with 
> iwl3945. compat-wireless-2010-01-15 works OK. However, as i don't 
> use any module parameters, i guess i'm using hw encryption.

I bisected this to commit 813d76694043d00b59475baa1fbfaf54a2eb7fad. 
Reverting this patch makes compat-wireless-2010-01-20 and later run OK.

Thanks,
Jochen
