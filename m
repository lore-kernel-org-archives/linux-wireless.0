Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40606 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753135AbdF0RfW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 13:35:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 3/8] qtnfmac: implement AP_VLAN iftype support
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
        <20170620195517.18373-4-sergey.matyukevich.os@quantenna.com>
Date: Tue, 27 Jun 2017 20:35:18 +0300
In-Reply-To: <20170620195517.18373-4-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Tue, 20 Jun 2017 22:55:12 +0300")
Message-ID: <878tkd49m1.fsf@purkki.adurom.net> (sfid-20170627_193547_845042_47A49FF1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> This patch implements AP_VLAN interface type support enabling
> the use of dynamic VLAN mode in hostapd.
>
> Implementation notes.
>
> 1. Passing dynamic VLAN tag to firmware
> Currently there is no established way to pass VLAN tag assigned to STA
> by Radius server to wireless driver. It is assumed that hostapd is able
> to setup all the bridging and tagging on its own. However qtnf firmware
> needs to know the assigned dynamic VLAN tags in order to perform various
> internal tasks including group key management, filtering, acceleration,
> and more.
>
> Current implementation makes use of the following workaround.
> Driver obtains dynamic VLAN tags assigned by Radius server
> from AP/VLAN interface names:
> - for primary interfaces: wlanX.Z
>   where X and Z are macid and vlan tag respectively
> - for MBSS virtual interfaces: wlanX_Y.Z
>   where X, Y, Z are macid, vifid, and vlan tag respectively
>
> Such a naming convention can be configured using
> hostapd vlan_file configuration file.
>
> 2. Packet routing to/from AP/VLAN interfaces
> Firmware operates with tagged packets after dynamic VLAN mode is
> configured. In particular, packets destined to STAs should be
> properly tagged before they can be passed to firmware. Packets
> received from STAs are properly tagged by firmware and then
> passed to wireless driver. As a result, packet routing to AP/VLAN
> interfaces is straightforward: it is enough to check VLAN tags.
>
> Normally hostapd expects untagged packets from AP/VLAN interfaces.
> Meanwhile firmware performs tagging using h/w acceleration. That
> is why it makes sense to avoid untagging packets in driver if
> they are supposed to by tagged again on host. To enable this
> behavior a new module parameter 'dyn_vlan_tagged' has been
> introduced:
>
> - dyn_vlan_tagged = 0 (default)
> In this case untagged packets are sent to and expected from AP/VLAN interfaces.
> Driver tags/untags packets going to/from firmware. This behaviour is expected
> by hostapd which is able to create bridges and VLAN interfaces automatically
> when hostapd is built with CONFIG_FULL_DYNAMIC_VLAN option enabled.
>
> - dyn_vlan_tagged = 1
> In this case tagged packets are sent to and expected from AP/VLAN interfaces.
> Hostapd build option CONFIG_FULL_DYNAMIC_VLAN should be disabled. Setup of
> networking topology on host is left up to the implementers.
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

This looks somewhat controversial to me but I'm not very familiar with
VLANs. Do other wireless drivers do something similar or how is this
usually implemented? Or not at all?

-- 
Kalle Valo
