Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:35629 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758779AbdCVI7D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 04:59:03 -0400
Received: by mail-ot0-f176.google.com with SMTP id y88so10753238ota.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 01:58:43 -0700 (PDT)
MIME-Version: 1.0
From: Ajay Ramakrishnan <ajayrama93@gmail.com>
Date: Wed, 22 Mar 2017 14:28:42 +0530
Message-ID: <CABpfVq5mJ4CaSBW2CqSmdi=WrTVyGV8CNvtDc0UMtU6B87MpuA@mail.gmail.com> (sfid-20170322_095909_403006_1047E256)
Subject: Gsoc 2017 - Availability of porjects in Linux Wireless
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all.

I would like to work on the GSOC in the Linux Wireless module. I would
like to know what are the available projects upon which I could work
on.

>From the to-do page, I found this: 11v and I would like to work on the below:
1. 11v DMS support:
    In AP mode, the packets needs to be saved in a queue and then need
to be sent as unicast to sleeping clients.
    STA should receive these packets after waking up listening to beacons.

Test equipments: 1 device as AP and 2 device as STA (to check the DMS support)

2. 11v BSS Transition Management support:
    In AP neighbor AP list needs to be sent to the client on request.
The action frames would be prepared at the mac80211 and given to the
driver. The driver just needs to send the packet out. Neighbor list
can be prepared based on a polling mechanism. Each AP can send the
data and during offchannel scan the AP learns details about other APs.
    The STA should be able to process this neighbor list and then scan
in those channel alone. This is a network assisted roaming. Once the
packet is received by the driver and received at mac80211, the packet
is parsed and the 11v BTM request frame is identified and neighbor
possible parent list is identified.
Based on this list, roaming is to be done and scanning is done on
those channels alone.

Test equipments: 2 or more devices as APs(to check if neighbor list is
being prepared correctly) and 1 device as STA to validate the message
exchanges


Could you please let me know if these are already implemented in the
Linux Wireless. If someone from the Linux foundation team/Linux
Wireless team is working on this, maybe we can discuss regarding the
available projects and I would like to work on wireless networks.

Thanks,
Arun
