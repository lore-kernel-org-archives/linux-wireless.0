Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:39834 "EHLO
        resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752098AbdHJBUv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 21:20:51 -0400
Reply-To: james@nurealm.net
Subject: Re: wireless drivers fail to report link speed?
To: Dan Williams <dcbw@redhat.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Cc: Andy Gospodarek <andy@greyhouse.net>
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
 <1502228547.24881.5.camel@redhat.com>
 <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
 <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
 <5a5cb91f-443c-8cc1-ea1f-50de4d07cb25@candelatech.com>
 <3d16a276-0e15-c722-483c-c17d715ebb5e@nurealm.net>
 <598AD624.1060003@broadcom.com>
 <318f60de-5589-1218-9848-d3514724e9c1@nurealm.net>
 <1502303131.9777.7.camel@redhat.com>
From: James Feeney <james@nurealm.net>
Message-ID: <21548605-ffb3-1206-208c-9c01f5d8bf7b@nurealm.net> (sfid-20170810_032055_361787_0BB591B5)
Date: Wed, 9 Aug 2017 19:20:06 -0600
MIME-Version: 1.0
In-Reply-To: <1502303131.9777.7.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Dan

On 08/09/2017 12:25 PM, Dan Williams wrote:
> The relevant questions, in my view, are:
> 
> 1) why does the bonding driver now require this information?

Well, it *always* required the information.  Just now, Mahesh has finally
decided "up with this I will not put", not being able to get the information needed.

Please see Mahesh's first patch:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?id=c4adfc822bf5d8e97660b6114b5a8892530ce8cb

----

bonding: make speed, duplex setting consistent with link state

bond_update_speed_duplex() retrieves speed and duplex settings. There
is a possibility of failure in retrieving these values but caller has
to assume it's always successful. This leads to having inconsistent
slave link settings. If these (speed, duplex) values cannot be
retrieved, then keeping the link UP causes problems.

The updated bond_update_speed_duplex() returns 0 on success if it
retrieves sane values for speed and duplex. On failure it returns 1
and marks the link down.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

----

Mahesh does not explain what these specific "problems" might be, though.

Generally, the bonding module has to be able to dynamically prioritize, enable,
and disable different network interfaces, as network circumstances change.  It
constantly monitors link speeds and connectivity, comparing links and
reconfiguring interfaces.


> 2) is this information reasonable to request from WiFi drivers?
>
> 3) how would this information affect the operation of the bonding
> driver if it doesn't mean the same thing as it means for wired devices?

I don't know that that dialog, between bonding module and wireless, have ever
happened, until now, since there just was never any link information returned
from the wireless drivers.

You might want to look through "linux/Documentation/networking/bonding.txt".

I do know that the Bonding Driver Option "primary_reselect=better" does not work
with a wireless interface - because the bonding module does not receive the
wireless link speed.  That's not the bonding module's fault, it turns out.

But then, with no information, the bonding module would be forced to "punt".
For instance, it is not correct to simply assume that a wired connection is
always faster than a wireless connection, though that assumption might be needed
as a fall-back with older non-reporting wireless drivers.

> Again, there is a problem that should be solved.  I am only advocating
> that instead of simply adding ethtool get_settings support to WiFi
> drivers and washing our hands of it, which may have unintended
> consequences, we gather all the information first, and discuss whether
> the bonding driver may need to adjust its expectations before this kind
> of change is made.

Yes, please.


James
