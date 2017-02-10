Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59830 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdBJW6c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 17:58:32 -0500
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Subject: VHT 160Mhz and nss related config.
Message-ID: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com> (sfid-20170210_235835_296103_8149499F)
Date: Fri, 10 Feb 2017 14:58:31 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, it appears that the ath10k QCA9984 4x4 160Mhz chip can do 4x4 MIMO at VHT80, but
it can do only 2x2 MIMO at VHT160/80+80.

When configuring a peer, we need to tell the firmware the number of spatial streams
of the peer at VHT160 and at VHT80 and lower.  They are not the same value.

I cannot think of any standard way to get this information based on VHT capabilities
and such.  Currently, one could just assume VHT160 NSS is 1/2 of the VHT80 NSS,
but that is unlikely to be true for all vendors.

Any ideas?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
