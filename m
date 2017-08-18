Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eidolon.nox.tf ([185.142.180.128]:36080 "EHLO eidolon.nox.tf"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751679AbdHRXiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 19:38:23 -0400
Date: Sat, 19 Aug 2017 01:38:22 +0200
From: David Lamparter <equinox@diac24.net>
To: Ben Greear <greearb@candelatech.com>
Cc: David Lamparter <equinox@diac24.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [POC/GIT] mac80211 multicast rate selection (help wanted!)
Message-ID: <20170818233822.GV773745@eidolon> (sfid-20170819_013827_660982_F86C23C1)
References: <20170818222910.GT773745@eidolon>
 <eb338f20-9829-9848-bb27-448261ff528d@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eb338f20-9829-9848-bb27-448261ff528d@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:49:39PM -0700, Ben Greear wrote:
> On 08/18/2017 03:29 PM, David Lamparter wrote:
> > I've taken up an hacking endeavour in trying to improve multicast on
> > wifi, specifically to get it off the stupid 1 MBit rate.  Before anyone
> > yells "that's not allowed by the spec" - it actually is, please refer to
> > section 9.7.5 of 802.11-2012. ("... using one of the rates included in
> > the BSSBasicRateSet parameter ...")  Also, Cisco and Aruba are doing
> > this in their enterprise APs, and it's rather nice.
> 
> For ath10k, at least, rate-ctrl is controlled in the firmware.
> But, the driver can set the multicast rate to a fixed value.

Yeah, I've hacked this straight in minstrel_ht, so it's only gonna work
on mac80211 drivers.

The information about which STAs are joined to a multicast group is
available to all drivers though, so, if a hardmac driver has sufficient
information on STA rates, it could still dynamically pick a multicast
rate on a per-packet level and tell that to the MAC.

> I am pretty sure this works on stock firmware, maybe with some driver
> tweaks.  It definitely works on my ath10k-ct driver/firmware (tested on
> the wave-1 stuff, not sure anyone has tested on the wave-2 stuff yet).
> 
> My api is through the ath10k debugfs API, so a kludge at best, but it could
> be wired into a better API with some work.

I actually need to try the CT stuff, particularly the TX rate reporting
-- wonder how useful the information is (cf. above).  Unfortunately the
only ath10k I have is in my plastic router...  a bit annoying to hack
around on.

> I'll read through your stuff when I get a chance.

Thanks in advance, all input appreciated!


-David
