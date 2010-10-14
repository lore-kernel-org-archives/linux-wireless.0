Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35696 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0JNVjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 17:39:17 -0400
Message-ID: <4CB77881.2030908@candelatech.com>
Date: Thu, 14 Oct 2010 14:39:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com> <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com> <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com> <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com> <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com> <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com> <4CB4AA89.1070009@candelatech.com> <AANLkTinpWvMtexFTYVm5rEZY=gY7qY8WxHFtVGB0o6Se@mail.gmail.com> <4CB5E885.7090305@candelatech.com> <AANLkTi=c=w8MvXZ=vqxkRgbXasacQTYXUX8o_zXoZgxC@mail.gmail.com> <4CB5F0D4.4020907@candelatech.com> <AANLkTimCyHRRoh34Cfv=b+h-9SoeuJzur46WyEZ7BKT-@mail.gmail.com> <4CB776AF.6090504@candelatech.com> <AANLkTimCqjjuz-6zbUozsFzv2DE0K044gyvf-52V4d+7@mail.gmail.com>
In-Reply-To: <AANLkTimCqjjuz-6zbUozsFzv2DE0K044gyvf-52V4d+7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2010 02:32 PM, Luis R. Rodriguez wrote:
> On Thu, Oct 14, 2010 at 2:31 PM, Ben Greear<greearb@candelatech.com>  wrote:

>>> arch/x86/built-in.o: In function `store_stack':
>>> /home/mcgrof/wireless-testing/arch/x86/kernel/dumpstack.c:259:
>>> undefined reference to `store_trace'
>>
>> You are compiling on 32-bit system?  I see the method in
>> the patch, but probably only for 32-bit x86...
>
> Ah no I'm on 64-bit.

Probably you could cut-n-paste dump_trace in dumpstack_64.c,
rename it store_trace, and hack it a bit as I did the one in
dumpstack_32.c

I don't currently have any ath9k systems running 64-bit, but
I could put one together if needed.

By the way, if you have any extra ideas of what to try next,
I'll consider trying it.  I am very low on ideas personally :P

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

