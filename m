Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57101 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaFBQzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 12:55:04 -0400
Received: by mail-vc0-f176.google.com with SMTP id la4so5351838vcb.7
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2014 09:55:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P2AKnUvUyddsGC5JST51bbjpavG3X-VbJhS1Mf7fDNPcw@mail.gmail.com>
References: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com>
 <CALCETrU58grNoqQh5ZutHa8CEt4rqS6FrMWwpC6DaQ0cXqxXhw@mail.gmail.com>
 <CANUX_P22a2eC0VAw-NCKrnVQRs9t=uy1VHrBF-2dAsW+s=YfUQ@mail.gmail.com>
 <CALCETrUXGKpHfTwYti9Rzgv-ZM--_d9pW8_Jx9oR1L+GsBeZcQ@mail.gmail.com>
 <CANUX_P2sH1yzx5aeLbHXBGHAsXmkZ70ioEhH1Ad_xNrCEJbJRg@mail.gmail.com>
 <CANUX_P2XpeDOmNOX=p4yMUe5ZAZv-UQ97M0ayFcFSsTrEDS3CA@mail.gmail.com>
 <CALCETrVpvFk+qhq3PFgK+5kTnBcbtv8H_Ko+kHV0jay0ZTfmcQ@mail.gmail.com>
 <CANUX_P3NrA2GgZ-Nqgvk7do7Kzqa9kgjtpn4t9TuLKzhmqTqjQ@mail.gmail.com>
 <CALCETrX1s504Ej7sQV292NfHgrKrV-Wigk0GP7wo6GyALaM9xA@mail.gmail.com>
 <CANUX_P3jMcV=7stRtPAFZBJVG9bE10iTC0sRK_o-7vTxpy9+9w@mail.gmail.com>
 <CALCETrVPXwedhPGtDJQDSK5Kxa4NpeSDck4-nHyox_xriPBcZQ@mail.gmail.com>
 <CALCETrW0NQ6aW06WD6ZAi8-o7fZSiKPOf0xYCSEw2egYBfqyQQ@mail.gmail.com>
 <CALCETrUTsKCw_G7V=YDeP-v_GF8cK8ezY-wqcpxeuw3dzBQhQg@mail.gmail.com>
 <CANUX_P2_GZGhd7X4Ntzi5Jeng52i9Jam22DQTTU2akESPL1ffQ@mail.gmail.com>
 <CALCETrWdQwvMcgC=PESyECzkyMD8-vzjNEHOCkm5z=ENH7coHg@mail.gmail.com> <CANUX_P2AKnUvUyddsGC5JST51bbjpavG3X-VbJhS1Mf7fDNPcw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 2 Jun 2014 09:54:42 -0700
Message-ID: <CALCETrX8Km4dc-XM4Ga8T7spDJzN00jx162A3iuTo5+NWhGTZg@mail.gmail.com> (sfid-20140602_185509_063491_6B675A2E)
Subject: Re: Help debugging iwldvm / ath10k stalls
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2014 at 5:09 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>> I doubt I can bisect -- the trigger was a new AP, not a new kernel.  I
>> can't exactly cut the AP in half :)
>
> I see.. This is really weird though. Anyway.
>
>>
>>
>> Pre-suspend, i.e., working:
>>
>> [   20.949900] enabled = 1, wowlan = 0
>> [   20.950177] enabled = 1, wowlan = 0
>> [   21.614016] enabled = 1, wowlan = 0
>> [   21.614658] enabled = 1, wowlan = 0
>> [   42.667586] enabled = 0, wowlan = 0
>> [   42.672514] enabled = 1, wowlan = 0
>> [   53.088165] fuse init (API version 7.23)
>> [   53.102082] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
>> [   53.130945] SELinux: initialized (dev fusectl, type fusectl), uses
>> genfs_contexts
>> [   85.627558] enabled = 0, wowlan = 0
>> [   85.631686] enabled = 1, wowlan = 0
>> [  134.649346] e1000e: em1 NIC Link is Down
>> [  137.682277] wlan0: deauthenticating from 02:c6:26:cc:b4:c7 by local
>> choice (Reason: 3=DEAUTH_LEAVING)
>> [  137.682780] enabled = 0, wowlan = 0
>> [  137.693889] enabled = 0, wowlan = 0
>>
>> Post-suspend, i.e., not working:
>>
>> [  144.406303] enabled = 1, wowlan = 0
>> [  144.406496] enabled = 1, wowlan = 0
>> [  145.026827] enabled = 1, wowlan = 0
>> [  145.028211] enabled = 1, wowlan = 0
>> [  165.688632] enabled = 0, wowlan = 0
>> [  165.689960] enabled = 0, wowlan = 0
>> [  165.693988] enabled = 1, wowlan = 0
>> [  165.694245] enabled = 1, wowlan = 0
>> [  208.641426] enabled = 0, wowlan = 0
>> [  208.641786] enabled = 0, wowlan = 0
>> [  208.647499] enabled = 1, wowlan = 0
>> [  208.647639] enabled = 1, wowlan = 0
>> [  271.435558] enabled = 0, wowlan = 0
>> [  271.435767] enabled = 0, wowlan = 0
>> [  271.440125] enabled = 1, wowlan = 0
>> [  271.440405] enabled = 1, wowlan = 0
>>
>> With even more instrumentation added, I did get a glitch before
>> suspend/resume, but it came with more than two power setting updates.
>> Logs and patch attached, complete with call stacks.
>>
>
> I don't see any callstacks?
> Doesn't matter though.

I think the callstacks were in the attachment.  I could have messed up, though.

Anyway, I don't buy the theory that this is caused by the firmware
going out to lunch.  The queues files in debugfs show the rx queue
chugging along and all of the tx queues have read_ptr == write_ptr.
Wireshark shows incoming broadcast traffic, too.  I'd guess that the
problem is more likely to be that the card is failing to wake up and
notice pending data in the TIM.

--Andy
