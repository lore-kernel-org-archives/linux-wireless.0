Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56402 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932148AbdJWRyh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 13:54:37 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 457B240A5CB
        for <linux-wireless@vger.kernel.org>; Mon, 23 Oct 2017 10:54:35 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: A good way to get CSI info to user-space?
Message-ID: <6f9182c4-cff9-066c-173a-00d09af7c903@candelatech.com> (sfid-20171023_195440_976958_B20E3A62)
Date: Mon, 23 Oct 2017 10:54:35 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have been poking at ath10k to get some CSI reporting working.
The CSI reports are a bit over 2k bytes in length, and they could
happen quite often.  As far as I can tell, there is no good way in
the kernel to make this available.

I was thinking maybe a callback into the mac80211 stack, which would
then send a netlink event might be a useful way to implement this?

Any other suggestions on this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
