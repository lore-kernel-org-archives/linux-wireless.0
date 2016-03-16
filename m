Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52259 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965002AbcCPVtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 17:49:01 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
	linuxwifi <linuxwifi@intel.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi incomplete initialization in Linux 4.5?
Date: Wed, 16 Mar 2016 21:48:55 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA7A7B0@hasmsx107.ger.corp.intel.com> (sfid-20160316_224906_613439_C16DE671)
References: <CA+55aFxOMO6u6xu4Pz7BzbLD=SwwzdPcSU2dX2S0kkh4jFaVbw@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32EA7A541@hasmsx107.ger.corp.intel.com>
 <CA+55aFw8_rtr8v65LYXYJpWq40TyTPpt9hdBzwr8-VYpaKMdRQ@mail.gmail.com>
 <CA+55aFw0N3eurmMDmH=vJC=OOZaTOPQCGGOsR9Xn6oEU_5-MFw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/16/2016 11:44 PM, Linus Torvalds wrote:
> On Wed, Mar 16, 2016 at 2:23 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>> Do you use 20Mhz or 40MHz?
>>
>> HT20 on 2.4GHz, HT40 on 5GHz.
>>
>> At least that's the wireless AP setup.
>>
>>> Basically, I'd like to see the output of iw dev
>>
>> I'll have to walk over and check. I don't have my machines set up so
>> you can get into them over the network..
> 
> Hmm. "iw dev" seems to say that device is using the 2.4Ghz side, at
> least in the working configuration.
> 
>   phy#0
>         Unnamed/non-netdev interface
>                 wdev 0x2
>                 addr a4:34:d9:0e:20:d7
>                 type P2P-device
>         Interface wlp1s0
>                 ifindex 3
>                 wdev 0x1
>                 addr a4:34:d9:0e:20:d6
>                 type managed
>                 channel 1 (2412 MHz), width: 20 MHz, center1: 2412 MHz
> 
> I have no idea why it wouldn't connect to the 5GHz network, but it
> might just be far enough away (a couple of walls, not so much
> distance) that it is borderline. Both networks have the same essid and
> password, maybe I should add a separate 5GHz network to make it easier
> to say "connect to that one" for testing, in case the trouble happens
> with the 5GHz side only.
> 

You can check the RSSI of both networks:

sudo iw wlp1s0 scan

>      Linus
> 
