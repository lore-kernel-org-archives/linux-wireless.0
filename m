Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:24521 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965098AbcCPVdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 17:33:13 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
	linuxwifi <linuxwifi@intel.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi incomplete initialization in Linux 4.5?
Date: Wed, 16 Mar 2016 21:33:08 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA7A6AA@hasmsx107.ger.corp.intel.com> (sfid-20160316_223319_600970_66CE9AEA)
References: <CA+55aFxOMO6u6xu4Pz7BzbLD=SwwzdPcSU2dX2S0kkh4jFaVbw@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32EA7A541@hasmsx107.ger.corp.intel.com>
 <CA+55aFw8_rtr8v65LYXYJpWq40TyTPpt9hdBzwr8-VYpaKMdRQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/16/2016 11:23 PM, Linus Torvalds wrote:
> On Wed, Mar 16, 2016 at 2:13 PM, Grumbach, Emmanuel
> <emmanuel.grumbach@intel.com> wrote:
>>
>> This ... typically means that the firmware got stuck while sending
>> packets. Can you tell me on what band your router operates? 2.4GHz or
>> 5.2GHz?
> 
> Both.
> 
>> Do you use 20Mhz or 40MHz?
> 
> HT20 on 2.4GHz, HT40 on 5GHz.

That's fair. Using 40MHz on 2.4GHz can be the cause of issues.

> 
> At least that's the wireless AP setup.
> 
>> Basically, I'd like to see the output of iw dev
> 
> I'll have to walk over and check. I don't have my machines set up so
> you can get into them over the network..

Not urgent. I am GMT+2, so it's kinda late here anyway :)

> 
>> Hmm, this is strange since 4.4 and 4.5 will both load -16.ucode which
>> you seemed to be running when the have the Queue hang message.
> 
> Correct. Both cases used the 16 ucode, since that's what F22 comes
> with. I upgrade the kernel, but intentionally don't touch anything
> else in the system.

Ok - we have the same device (8260), so I'll prepare a debug version of
the -16.ucode firmware and test it tomorrow morning so that *if* you
want to debug, you'll have the special firmware ready in your inbox.

> 
>                Linus
> 
