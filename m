Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:35371 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbdFHXgJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 19:36:09 -0400
Received: by mail-ot0-f171.google.com with SMTP id a2so31264085oth.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jun 2017 16:36:09 -0700 (PDT)
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com> (sfid-20170609_013613_564917_A66F267C)
Date: Thu, 8 Jun 2017 18:36:07 -0500
MIME-Version: 1.0
In-Reply-To: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

> The problem I see is that sometimes (and quite often when I am using lots
> of vdevs and thus the NIC is busy), the keys are set before the EAPOL 4/4
> hits the air.  When the key is set, the NIC will no longer transmit the
> frame because of key-length issues in the tx-descriptor (ath10k wave-2
> in this case).

We have encountered something similar.  In our case we were seeing PAE 
packets (e.g. 4WayHandshake packet 1 of 4) before seeing the connect 
events on nl80211.

> I suspect that there is a fundamental race between the EAPOL packet-tx
> logic and the key-set logic, but supplicant appears to act as though
> they are natually synchronized.

Fundamentally there is a race between the genl/nl80211 socket to the 
kernel and the PAE socket that handles the authentication aspects.  I 
think the only way to fix this is to make sure that PAE flows over the 
genl/nl80211 socket to preserve the proper order of events.  However 
there are lots of dragons in the kernel side of this and we haven't been 
brave enough to venture into the depths yet :)

Regards,
-Denis
