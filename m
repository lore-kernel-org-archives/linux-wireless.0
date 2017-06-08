Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43856 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751382AbdFHXnY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 19:43:24 -0400
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
To: Denis Kenzior <denkenz@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
 <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com> (sfid-20170609_014328_357309_E3D29C55)
Date: Thu, 8 Jun 2017 16:43:23 -0700
MIME-Version: 1.0
In-Reply-To: <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/2017 04:36 PM, Denis Kenzior wrote:
> Hi Ben,
>
>> The problem I see is that sometimes (and quite often when I am using lots
>> of vdevs and thus the NIC is busy), the keys are set before the EAPOL 4/4
>> hits the air.  When the key is set, the NIC will no longer transmit the
>> frame because of key-length issues in the tx-descriptor (ath10k wave-2
>> in this case).
>
> We have encountered something similar.  In our case we were seeing PAE packets (e.g. 4WayHandshake packet 1 of 4) before seeing the connect events on nl80211.
>
>> I suspect that there is a fundamental race between the EAPOL packet-tx
>> logic and the key-set logic, but supplicant appears to act as though
>> they are natually synchronized.
>
> Fundamentally there is a race between the genl/nl80211 socket to the kernel and the PAE socket that handles the authentication aspects.  I think the only way to
> fix this is to make sure that PAE flows over the genl/nl80211 socket to preserve the proper order of events.  However there are lots of dragons in the kernel
> side of this and we haven't been brave enough to venture into the depths yet :)

I think that would just push the problem lower.  Probably a real fix would be to somehow propagate
the tx-status for the specific packet back to the supplicant and only then it would know that the
key could be set.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
