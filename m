Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46835 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1LPNxm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 08:53:42 -0500
Message-ID: <4EEB4D61.80602@lwfinger.net> (sfid-20111216_145347_354114_661E7407)
Date: Fri, 16 Dec 2011 07:53:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unexpected taint message
References: <4EEB0EFC.5000302@broadcom.com>  (sfid-20111216_102800_182196_AFD2D6CF) <1324038636.3429.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1324038636.3429.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2011 06:30 AM, Johannes Berg wrote:
> On Fri, 2011-12-16 at 10:27 +0100, Arend van Spriel wrote:
>> To whoever may know,
>>
>> Upon loading our driver module I get the following message:
>>
>> kernel: [  344.805106] Disabling lock debugging due to kernel taint
>>
>> What exactly are the criteria for tainting? Our driver locking strategy
>> is something we want to refactor and having lock debugging during that
>> transition may be a life safer.
>
> cat /proc/sys/kernel/tainted

Please note that Documentation/sysctl/kernel.txt is missing the explanation for 
two bits in the value printed:

2048 - The system is working around a severe firmware bug.
4096 - An out-of-tree module has been loaded.

On my system, bit 4096 is set due to loading the VirtualBox module, which 
disables lock debugging lock debugging. I suspect that loading VMware would 
cause the same condition.

I also found that loading brcmsmac did not trigger the license taint. I think 
you are OK with the dual license.

Larry


