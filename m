Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36898 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751894AbeFEW1b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 18:27:31 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 862C940A5ED
        for <linux-wireless@vger.kernel.org>; Tue,  5 Jun 2018 15:27:28 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: How to let devcoredump know data has been read?
Message-ID: <6f54d11c-74a5-568a-ba1e-3f37edb28384@candelatech.com> (sfid-20180606_002735_887335_A07EC74D)
Date: Tue, 5 Jun 2018 15:27:28 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been testing ath10k on 4.16, which uses the devcoredump API
to notify about dumps.

I am able to see the binary crash dump at /sys/class/devcoredump/devcd2/data,
for instance, but if I do another crash quickly, I get no new uevent sent
and no new crash.

I see there is a 5 minute timer on the coredump data, but it also seems to indicate
that if I read the crash, the data should be cleared and ready to be
recreated again?  How do you notify the system that the crash data has
been read?

I tried 'cat' on the data file, but that did not seem to clear anything.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
