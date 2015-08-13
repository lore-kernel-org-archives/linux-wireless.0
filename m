Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn1bon0090.outbound.protection.outlook.com ([157.56.111.90]:27360
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752083AbbHMObx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 10:31:53 -0400
From: "Richards, Sean" <srichards@gpo.gov>
To: Arend van Spriel <arend@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ft86drifter@cox.net" <ft86drifter@cox.net>
Subject: RE: Wireless driver issue
Date: Thu, 13 Aug 2015 14:17:07 +0000
Message-ID: <BY1PR09MB06162EE931D171A710B8C120B57D0@BY1PR09MB0616.namprd09.prod.outlook.com> (sfid-20150813_163211_363646_11FF31A3)
References: <BY1PR09MB061612E4649D00B899E62DF9B57E0@BY1PR09MB0616.namprd09.prod.outlook.com>
 <55CB88DC.9070502@lwfinger.net>
 <BY1PR09MB0616CB744753A6CE34AA0DB2B57E0@BY1PR09MB0616.namprd09.prod.outlook.com>
 <3wfi1r0051B0Yuh01wiv6t@mac.com>
 <6FF30372-1A87-41BB-9BFC-1E92FE9FC51C@icloud.com>
 <55CBC55B.6020502@broadcom.com>
In-Reply-To: <55CBC55B.6020502@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----Original Message-----
From: Arend van Spriel [mailto:arend@broadcom.com] 
Sent: Wednesday, August 12, 2015 6:15 PM
To: Sean Richards; Larry Finger
Cc: Richards, Sean; linux-wireless@vger.kernel.org; ft86drifter@cox.net
Subject: Re: Wireless driver issue

On 08/12/2015 10:51 PM, Sean Richards wrote:
> On Aug 12, 2015, at 4:42 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>>> On 08/12/2015 02:15 PM, Richards, Sean wrote:
>>> No I am sorry it's not obvious.  I was told to report the bug to you.  I did so.  I honestly don't know much about Linux.  I like using it and reported the bug to help the community.  I am sure I won't be the only one to purchase this device and Put RedHat / Fedora on it.
>>
>> Since you are new, I will offer a little tutorial.
>>
>> Firstly, it is better if you do not post your response before the quoted material - called top posting.
>>
>> A. It puts the answer out of order and before the question.
>> Q. Why is top posting bad?
>>
>> The person that told you to report this problem to us did not know what they were saying. This mailing list is for open-source drivers. As I said in the first E-mail, and as I will explain a little more fully here, your device has no open-source driver available.
>>
>> A third point is that when you will be posting the output from lspci, always include the "-nn" switch in the command. That way the PCI IDs will be listed. Those are the codes used by the system to recognize what driver the device will use. There is always a possibility that the BCMXXXX designation may be misleading.
>>
>> There are three sources of drivers for Broadcom wireless devices:
>>
>> 1. Driver b43 is open source and mostly covers older devices. It has been written by the community based on clean-room reverse engineering. As stated earlier, the more complicated the wireless technology, the more difficult the reverse process.

It may seem to people that b43 has a bug as it tries to probe devices it does not support. Still I agree with Larry that the information in the kernel log is pretty clear about what is going on.

>> 2. Drivers brcmsmac and brcmfmac are open source and cover newer devices. These drivers have been written by Broadcom employees, thus they have access to the details of the internals of the wireless chips; however, not all new devices are supported.
>>
>> 3. Driver wl, which is partly closed source, has been written by a different set of Broadcom developers. It is a hybrid driver with two parts. The first is open-source code that handles the interfacing between the wireless chip control routines and the rest of Linux. The second part, which handles the actual operation of the wireless chip, is only provided as a binary blob. The probable reason for hiding this code is to preserve the "secrets" of the chips.
>>
>> The list of what drivers are available for the various devices is available at https://wireless.wiki.kernel.org/en/users/Drivers/b43. As shown there, driver wl is the only option for your device.
>>
>> Larry
>
> I was wondering if you could answer one more question for me.  Would you mind expanding on this comment??
>
> It will taint your kernel
>
> I am curious what you mean by that.--

A kernel can be tainted for various reasons specified in include/linux/kernel.h [1]. One of them is using an out-of-tree module. 
The hybrid driver is such a driver module. It is built against the kernel, but not part of it. Certain kernel features require an untainted kernel. So those will not be available if using the hybrid driver. Not sure if those features are listed somewhere.

Regards,
Arend

[1]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/linux/kernel.h#n476

> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thank you guys for helping me understand the situation.  Maybe I will look into the situation and see what I can do with helping to make some open source drivers for this.  I am a novice at reverse engineering and have some decent assembly experience.  Thanks again for everyone's time.

Respectfully,

Sean Richards
