Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:33634 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdFIAHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 20:07:17 -0400
Received: by mail-ot0-f181.google.com with SMTP id k4so31514379otd.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jun 2017 17:07:16 -0700 (PDT)
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
 <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
 <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com> (sfid-20170609_020723_334469_4A93564B)
Date: Thu, 8 Jun 2017 19:07:11 -0500
MIME-Version: 1.0
In-Reply-To: <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On 06/08/2017 06:43 PM, Ben Greear wrote:
> On 06/08/2017 04:36 PM, Denis Kenzior wrote:
>> Hi Ben,
>>
>>> The problem I see is that sometimes (and quite often when I am using
>>> lots
>>> of vdevs and thus the NIC is busy), the keys are set before the EAPOL
>>> 4/4
>>> hits the air.  When the key is set, the NIC will no longer transmit the
>>> frame because of key-length issues in the tx-descriptor (ath10k wave-2
>>> in this case).
>>
>> We have encountered something similar.  In our case we were seeing PAE
>> packets (e.g. 4WayHandshake packet 1 of 4) before seeing the connect
>> events on nl80211.
>>
>>> I suspect that there is a fundamental race between the EAPOL packet-tx
>>> logic and the key-set logic, but supplicant appears to act as though
>>> they are natually synchronized.
>>
>> Fundamentally there is a race between the genl/nl80211 socket to the
>> kernel and the PAE socket that handles the authentication aspects.  I
>> think the only way to
>> fix this is to make sure that PAE flows over the genl/nl80211 socket
>> to preserve the proper order of events.  However there are lots of
>> dragons in the kernel
>> side of this and we haven't been brave enough to venture into the
>> depths yet :)
>
> I think that would just push the problem lower.  Probably a real fix
> would be to somehow propagate
> the tx-status for the specific packet back to the supplicant and only
> then it would know that the
> key could be set.
>

Having userspace track individual packets in the kernel sounds  wrong to 
me.  This also won't help with the packets being received out-of-order. 
It would be nice if both the RX and TX ordering was preserved.  Hence my 
thinking about running PAE over NL80211.  It would then be up to the 
kernel / drivers to guarantee that the various packets are ordered 
appropriately.

Regardless of the solution, we're happy to help in order to get this fixed.

Regards,
-Denis
