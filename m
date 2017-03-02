Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48860 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdCBLA5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 06:00:57 -0500
Message-ID: <1488444909.8390.11.camel@sipsolutions.net> (sfid-20170302_120120_845285_5A283FA6)
Subject: Re: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to
 suspend async: error -16)
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 02 Mar 2017 09:55:09 +0100
In-Reply-To: <6337fa40-adcc-b889-1842-16e0f316ea3e@googlemail.com> (sfid-20170224_221653_742300_1279B3C9)
References: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com>
         <1487938277.2540.13.camel@sipsolutions.net>
         <5d69cf9b-1113-835a-8423-3796586eae20@googlemail.com>
         <1487965047.30601.2.camel@sipsolutions.net>
         <6337fa40-adcc-b889-1842-16e0f316ea3e@googlemail.com>
         (sfid-20170224_221653_742300_1279B3C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Oh. Can you see if you have CONFIG_IWLWIFI_PCIE_RTPM enabled in
> > your configuration? If you do, please turn it off and see if that
> > fixes it.
> 
> Indeed, you got it! 
> I had it on, and turning that off lets me suspend just fine after
> activating WoWLAN!

[snip]

> The problem is that it seems I cannot actually wake the machine
> anymore afterwards... 
> While in the suspend procedure, I see:
> [12385.893568] iwlwifi 0000:0a:00.0: System wakeup enabled by ACPI
> as expected, I could neither get it to make a tcp connection in tcp-
> connection mode,
> nor could I wake the machine via magic packet in magic-packet mode. 
> 
> Could that be some hardware / system firmware limitation, e.g. if my
> UEFI does not support actually powering
> the WiFi hardware if I am in S3?

Yes. Does it print something to that effect at resume time? I think it
should.

> At least, the suspend problem seems to be clearly related to some
> path only used if CONFIG_IWLWIFI_PCIE_RTPM is on. 

Would you mind filing a bug on bugzilla.kernel.org (and adding linuxwif
i@intel.com as the assignee or at least in Cc)? I think we really ought
to sort out the issues with the RTPM stuff.

johannes
