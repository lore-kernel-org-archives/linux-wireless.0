Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42672 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753267AbcKUQKi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 11:10:38 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 9966640A626
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 08:10:37 -0800 (PST)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Break-it testing for wifi
Message-ID: <a60dac22-655e-ea93-61c2-73db05a47572@candelatech.com> (sfid-20161121_171042_142074_00CD9837)
Date: Mon, 21 Nov 2016 08:10:37 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I am thinking about adding some sort of framework to wpa_supplicant and/or the
mac80211 stack to allow purposefully creating bad station behaviour in order to
test robustness of APs.

Some ideas so far:

1)  Allow supplicant to do bad state-machine transitions (start 4-way before associating, for instance).

2)  Randomly corrupt mgt frames in driver and/or mac80211 stack and/or supplicant.

3)  Possibly allow user to make specific corruptions.  This would probably be in supplicant
     only, and I am not sure how this would be configured.  Maybe allow user to over-ride
     existing IEs and add bogus ones of their own choosing.

4)  Maybe some specific tests like putting in over-flow sized lengths of IEs.

Has anyone done anything similar they would like to share?

Johannes:  Any interest in having such a framework in upstream kernels?

Any other ideas for how to improve this feature set?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
