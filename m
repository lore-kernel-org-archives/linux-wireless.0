Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41228 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdFGAqg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Jun 2017 20:46:36 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 513D9409E08
        for <linux-wireless@vger.kernel.org>; Tue,  6 Jun 2017 17:46:35 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Wifi-Event for when initial 4-way completes?
Message-ID: <854f7995-2cc0-3649-2c94-9ef3c219fb73@candelatech.com> (sfid-20170607_024640_921694_0B6DC9F3)
Date: Tue, 6 Jun 2017 17:46:35 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been tracking down a nasty EAPOL related bug in ath10k, and found something that may be peripheral, or maybe
it is significant.

My logic is basically to kick supplicant, watch 'iw events', and then when I see something
like "sta62 (phy #5): connected to 00:0e:8e:f8:73:96", I consider it connected and start
dhcpd.

But, it appears that the 'connected' message comes out before the EAPOL 4-way completes, so
I am starting dhclient before the encryption is really set up properly.  At best, this slows
things down and makes dhclient have to retry.

Is there some existing event or state I can probe to determine when the initial 4-way is complete?

In case there is not, maybe that event would be worth adding?

Or, should I hack on supplicant instead and grab the info out of it somehow?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
