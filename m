Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45946 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729791AbeGQBHS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 21:07:18 -0400
To: ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Setting tx retry count in ath10k
Message-ID: <b0f67dd7-dea9-508e-7ad9-f6db3ac88b90@candelatech.com> (sfid-20180717_023729_917675_1E4F5B90)
Date: Mon, 16 Jul 2018 17:37:24 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I spent a bit of time looking into setting the tx retry count in
ath10k (wave-1 firmware).  The firmware has support for setting this as
a vdev parameter, and it defaults to '2', at least in my wave-1 firmware.

I enabled propagating the setting from mac80211, ie:
iw phy wiphy0 set retry short 2 long 2

And while debugging this, I noticed that mac80211 has a default of
4, but the ath10k firmware has a default of 2.  Now, I am not sure
if I should enable setting the retry count since it will change
the behaviour even if users don't set anything.

Any opinions on this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
