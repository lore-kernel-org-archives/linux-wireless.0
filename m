Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56358 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756518AbdJJSeK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 14:34:10 -0400
To: ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: What should setting rate on 'AP' interface mean?
Message-ID: <e99d4daa-fdc2-ce26-8ffb-bd3cf131e87c@candelatech.com> (sfid-20171010_203430_337151_62988B2D)
Date: Tue, 10 Oct 2017 11:34:10 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was trying to use 'iw' to set rates on an AP interface, hoping it would
set tx-rates on all of the stations (peers) to the same thing.

It appears that the ath10k driver will set ratesets on all stations if
we specify more than one rate, but if we specify a single rate, it does
not iterate through all stations, and just sets the 'vdev' fixed rate.

So, should the driver somehow attempt to set single rate on all the stations when
using a single rate?

Or, do we need an API to force rates for individual stations (peers) and leave
the driver in the current configuration?

Or is it the firmware's responsibility to set the rate for all peers when
we set the vdev fixed rate on an AP vdev?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
