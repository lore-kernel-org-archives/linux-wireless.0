Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:42805 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733070AbeGKSyK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 14:54:10 -0400
Received: by mail-qt0-f196.google.com with SMTP id z8-v6so13464044qto.9
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2018 11:48:32 -0700 (PDT)
Date: Wed, 11 Jul 2018 11:48:27 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Alex Vesker <valex@mellanox.com>
Cc: netdev@vger.kernel.org, jiri@mellanox.com, dsahern@gmail.com,
        andrew@lunn.ch, rahul.lakkireddy@chelsio.com,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next v2 00/11] devlink: Add support for region
 access
Message-ID: <20180711114821.1d50ba63@cakuba.lan> (sfid-20180711_204835_938935_4215E510)
In-Reply-To: <1531305788-29420-1-git-send-email-valex@mellanox.com>
References: <1531305788-29420-1-git-send-email-valex@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CC: linux-wireless, wifi chips used to have similar problem

On Wed, 11 Jul 2018 13:42:57 +0300, Alex Vesker wrote:
> This is a proposal which will allow access to driver defined address
> regions using devlink. Each device can create its supported address
> regions and register them. A device which exposes a region will allow
> access to it using devlink.
> 
> The suggested implementation will allow exposing regions to the user,
> reading and dumping snapshots taken from different regions. 
> A snapshot represents a memory image of a region taken by the driver.
> 
> If a device collects a snapshot of an address region it can be later
> exposed using devlink region read or dump commands.
> This functionality allows for future analyses on the snapshots to be
> done.
> 
> The major benefit of this support is not only to provide access to
> internal address regions which were inaccessible to the user but also
> to provide an additional way to debug complex error states using the
> region snapshots.
> 
> Implemented commands:
> $ devlink region help
> $ devlink region show [ DEV/REGION ]
> $ devlink region del DEV/REGION snapshot SNAPSHOT_ID
> $ devlink region dump DEV/REGION [ snapshot SNAPSHOT_ID ]
> $ devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ]
> 	address ADDRESS length length

You got me excited with the read without snapshot but then you say below
that it's future work :)

> Show all of the exposed regions with region sizes:
> $ devlink region show
> pci/0000:00:05.0/cr-space: size 1048576 snapshot [1 2]
> pci/0000:00:05.0/fw-health: size 64 snapshot [1 2]
> 
> Delete a snapshot using:
> $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
> 
> Dump a snapshot:
> $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
> 0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
> 0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
> 0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
> 0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
> 
> Read a specific part of a snapshot:
> $ devlink region read pci/0000:00:05.0/fw-health snapshot 1 address 0 
> 	length 16
> 0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
> 
> For more information you can check devlink-region.8 man page
> 
> Future:
> There is a plan to extend the support to include a write command
> as well as performing read and dump live region

Reading live region would be very interesting and alleviate the need
for complicated ethtool dump marshalling a number of drivers started
doing (incl. nfp).  Any plans on that?

Write support I'm less excited about :)
