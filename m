Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53834 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcISQTH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 12:19:07 -0400
Message-ID: <57E01026.9030604@candelatech.com> (sfid-20160919_181910_706641_36504C5E)
Date: Mon, 19 Sep 2016 09:19:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        "Pedersen, Thomas" <twp@qca.qualcomm.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>         <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>         <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>         <1473662637.4201.2.camel@sipsolutions.net>         <1473789454.27738.7.camel@qca.qualcomm.com>         <1473789740.5622.3.camel@sipsolutions.net>         <1474050629.31554.19.camel@qca.qualcomm.com>         (sfid-20160916_203211_452910_08E25A89) <1474275637.4469.15.camel@sipsolutions.net>
In-Reply-To: <1474275637.4469.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2016 02:00 AM, Johannes Berg wrote:
>
>> Actually, can you apply the v2 (cfg80211: add bitrate for 20MHz MCS
>> 9) of this? Systems guys confirmed they use MCS 9 @ 20MHz when LDPC
>> is enabled. Also confirmed bitrate should be ok.
>
> I don't really understand that. How can the bitrate be "OK" when the
> spec explicitly says it cannot be used?
>
> johannes
>

I think it is a moot point as far as this change goes:  Regardless of whether
the NIC should or not, it _does_.  So, mis-reporting it up the stack only hides
the issue and does not even give the user a clue that on-the-air encoding may be
slightly off-spec.

If the on-air encoding is an issue, then we need to hack the firmware to
disable this 'feature', but that is a completely separate issue.

Once this patch goes in, someone might consider properly reporting CCK
rx rates for 5Ghz band too:  ath10k can do this 'feature' as well, at least
in some firmware.  Probably can reproduce by sending off-channel mgt frames on
5Ghz when associated on 2.4, or something similar to this.  I was using ath9k as
sniffer when I found this long ago, so at least ath9k needs the change....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
