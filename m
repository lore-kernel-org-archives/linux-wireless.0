Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36122 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751366AbdIEOUf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 10:20:35 -0400
Message-ID: <1504621233.12380.21.camel@sipsolutions.net> (sfid-20170905_162039_586672_69F283CB)
Subject: VLAN/bridge "compression" in wifi (was: Re: [PATCH 3/8] qtnfmac:
 implement AP_VLAN iftype support)
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 05 Sep 2017 16:20:33 +0200
In-Reply-To: <1504619151.12380.16.camel@sipsolutions.net> (sfid-20170905_154707_931614_625FC941)
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
         <20170620195517.18373-4-sergey.matyukevich.os@quantenna.com>
         (sfid-20170620_215603_912928_26F5E0B9) <1504619151.12380.16.camel@sipsolutions.net>
         (sfid-20170905_154707_931614_625FC941)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+netdev

On Tue, 2017-09-05 at 15:45 +0200, Johannes Berg wrote:
> 
> In a way this feature seems mis-designed - you never have 802.1Q tags
> over the air, but you're inserting them on RX and stripping them on
> TX, probably in order to make bridging to ethernet easier and not
> have to have 802.1Q acceleration on the ethernet port, or - well - in
> order to have an ability to do this with an ethernet card that only
> has a single CPU port.

Ok this isn't really right either - it's only for saving the 802.1Q
acceleration on the Ethernet port, really - and saving the extra
bridges.

To clarify, I think what you - conceptually - want is the following
topology:

        +--- eth0.1  ---  br.1  ---  wlan0.1
        |
eth0 ---+--- eth0.2  ---  br.2  ---  wlan0.2
        | 
        +--- eth0.3  ---  br.3  ---  wlan0.3

where eth0.N is just "ip link add link eth0 name eth0.N type vlan id N"
and br.N is obviously a bridge for each, and the wlan0.N are AP_VLAN
type interfaces that isolate the clients against each other as far as
wifi is concerned.

Is this correct? As far as I understand, that's the baseline topology
that you're trying to achieve, expressed in terms of Linux networking.

Now, you seem to want to compress this to

                  +---  wlan0.1
                  |
eth0  ---  br  ---+---  wlan0.2
                  |
                  +---  wlan0.3

and have the 802.1Q tag insertion/removal that's normally configured to
happen in eth0.N already be handled in wlan0.N.

Also correct?


We clearly don't have APIs for this, and I don't think it makes sense
in the Linux space - the bridge and wlan0.N suddenly have tagged
traffic rather than untagged, and the VLAN tagging is completely hidden
from the management view.

johannes
