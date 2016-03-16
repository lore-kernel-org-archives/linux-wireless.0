Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35548 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbcCPVo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 17:44:27 -0400
Received: by mail-io0-f181.google.com with SMTP id g203so76175571iof.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 14:44:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFw8_rtr8v65LYXYJpWq40TyTPpt9hdBzwr8-VYpaKMdRQ@mail.gmail.com>
References: <CA+55aFxOMO6u6xu4Pz7BzbLD=SwwzdPcSU2dX2S0kkh4jFaVbw@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32EA7A541@hasmsx107.ger.corp.intel.com>
	<CA+55aFw8_rtr8v65LYXYJpWq40TyTPpt9hdBzwr8-VYpaKMdRQ@mail.gmail.com>
Date: Wed, 16 Mar 2016 14:44:26 -0700
Message-ID: <CA+55aFw0N3eurmMDmH=vJC=OOZaTOPQCGGOsR9Xn6oEU_5-MFw@mail.gmail.com> (sfid-20160316_224431_441580_94A8C0D1)
Subject: Re: iwlwifi incomplete initialization in Linux 4.5?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
	linuxwifi <linuxwifi@intel.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2016 at 2:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>> Do you use 20Mhz or 40MHz?
>
> HT20 on 2.4GHz, HT40 on 5GHz.
>
> At least that's the wireless AP setup.
>
>> Basically, I'd like to see the output of iw dev
>
> I'll have to walk over and check. I don't have my machines set up so
> you can get into them over the network..

Hmm. "iw dev" seems to say that device is using the 2.4Ghz side, at
least in the working configuration.

  phy#0
        Unnamed/non-netdev interface
                wdev 0x2
                addr a4:34:d9:0e:20:d7
                type P2P-device
        Interface wlp1s0
                ifindex 3
                wdev 0x1
                addr a4:34:d9:0e:20:d6
                type managed
                channel 1 (2412 MHz), width: 20 MHz, center1: 2412 MHz

I have no idea why it wouldn't connect to the 5GHz network, but it
might just be far enough away (a couple of walls, not so much
distance) that it is borderline. Both networks have the same essid and
password, maybe I should add a separate 5GHz network to make it easier
to say "connect to that one" for testing, in case the trouble happens
with the 5GHz side only.

     Linus
