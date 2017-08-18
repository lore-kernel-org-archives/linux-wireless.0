Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41756 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751816AbdHRWtk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 18:49:40 -0400
Subject: Re: [POC/GIT] mac80211 multicast rate selection (help wanted!)
To: David Lamparter <equinox@diac24.net>,
        linux-wireless@vger.kernel.org
References: <20170818222910.GT773745@eidolon>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <eb338f20-9829-9848-bb27-448261ff528d@candelatech.com> (sfid-20170819_004945_474639_07F8C7DA)
Date: Fri, 18 Aug 2017 15:49:39 -0700
MIME-Version: 1.0
In-Reply-To: <20170818222910.GT773745@eidolon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/18/2017 03:29 PM, David Lamparter wrote:
> Hello Linux Wireless hackers,
>
>
> I've taken up an hacking endeavour in trying to improve multicast on
> wifi, specifically to get it off the stupid 1 MBit rate.  Before anyone
> yells "that's not allowed by the spec" - it actually is, please refer to
> section 9.7.5 of 802.11-2012. ("... using one of the rates included in
> the BSSBasicRateSet parameter ...")  Also, Cisco and Aruba are doing
> this in their enterprise APs, and it's rather nice.

For ath10k, at least, rate-ctrl is controlled in the firmware.
But, the driver can set the multicast rate to a fixed value.

I am pretty sure this works on stock firmware, maybe with some driver
tweaks.  It definitely works on my ath10k-ct driver/firmware (tested on
the wave-1 stuff, not sure anyone has tested on the wave-2 stuff yet).

My api is through the ath10k debugfs API, so a kludge at best, but it could
be wired into a better API with some work.

I'll read through your stuff when I get a chance.

Thanks,
Ben

>
> So, from some completely unrelated datacenter work, I have hacked up the
> bridge to hand back down to the driver detailed info on multicast
> receivers.  Then I took this and fudged around in the minstrel_ht code
> and, well, it gave me 9 MBit/s ;)
>
> Now, I have pretty little no clue about the Linux wireless stack, so I'd
> appreciate if someone could tell me how massively wrong I'm doing this
> and which places in particular are the wrongest!
>
> You can find the code here:
> https://github.com/eqvinox/vpls-linux-kernel/commits/mdb-hack
> https://github.com/eqvinox/vpls-iproute2/tree/mdb-hack
>
> Please note that all of this is proof-of-concept level, it probably
> leaks tons of memory, has great race conditions and eats your cat for
> breakfast.  It also contains some debug printks like this:
> [ 9006.253504] mac80211_hwsim hwsim0 wlan0: multi-dst TX: 02:00:00:00:02:00 02:00:00:00:01:00
> [ 9006.255007] mac80211_hwsim hwsim0 wlan0: rc 02:00:00:00:02:00 => rate #1
> [ 9006.256095] mac80211_hwsim hwsim0 wlan0: rc 02:00:00:00:01:00 => rate #12
> [ 9006.257186] mac80211_hwsim hwsim0 wlan0: result rate #1
>
>
> Cheers,
>
> -David
>
>
> P.S.: yes, I know about unicast conversion.  But that's not helpful
> when, for example, you want to get a 10 MBit multicast TV livestream to
> 5 simultaneous wifi clients...
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
