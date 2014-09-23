Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45631 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaIWOTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 10:19:55 -0400
Message-ID: <5421818A.9040501@candelatech.com> (sfid-20140923_161959_737522_ED609A31)
Date: Tue, 23 Sep 2014 07:19:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: request firmware flush in ath10k_flush.
References: <1411151304-31544-1-git-send-email-greearb@candelatech.com> <CA+BoTQm1rZO+yBbYxihpgEvR1cGZWS4Pr0AP+KMODcG4jpd_jQ@mail.gmail.com>
In-Reply-To: <CA+BoTQm1rZO+yBbYxihpgEvR1cGZWS4Pr0AP+KMODcG4jpd_jQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/23/2014 02:16 AM, Michal Kazior wrote:
> On 19 September 2014 20:28,  <greearb@candelatech.com> wrote:
> [...]
>> +       /* If we are CT firmware, ask it to flush all tids on all peers on
>> +        * all vdevs.  Normal firmware will just crash if you do this.
>> +        */
>> +       if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
>> +               ath10k_wmi_peer_flush(ar, 0xFFFFFFFF, peer_addr, 0xFFFFFFFF);
>
> I recall you've explained this some time ago, but can you refresh my
> memory, please? Is this any different from iterating over all peers
> and flushing each? Or does your firmware do so extra magic that is
> impossible to do with normal firmware commands?

My firmware does that iteration internally.

You could probably do that in the driver, but it would be a lot
of messages (for all vdevs, all peers, all tids)...
I was not sure if there were limits to the number
of commands you should attempt during the flush...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
