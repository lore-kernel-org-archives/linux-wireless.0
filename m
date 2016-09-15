Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42781 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765783AbcIOOGx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 10:06:53 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "emmanuel.grumbach@intel.com" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH v2 09/21] ath10k: print fw debug messages in hex.
Date: Thu, 15 Sep 2016 14:06:48 +0000
Message-ID: <87k2edb6kp.fsf@kamboji.qca.qualcomm.com> (sfid-20160915_160700_078054_FF02FC00)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-10-git-send-email-greearb@candelatech.com>
        <87oa3qefac.fsf@kamboji.qca.qualcomm.com>       <57D96910.2010608@candelatech.com>
In-Reply-To: <57D96910.2010608@candelatech.com> (Ben Greear's message of "Wed,
        14 Sep 2016 08:13:20 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 09/14/2016 07:18 AM, Valo, Kalle wrote:
>> greearb@candelatech.com writes:
>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> This allows user-space tools to decode debug-log
>>> messages by parsing dmesg or /var/log/messages.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>
>> Don't tracing points already provide the same information?
>
> Tracing tools are difficult to set up and may not be available on
> random embedded devices.  And if we are dealing with bug reports from
> the field, most users will not be able to set it up regardless.
>
> There are similar ways to print out hex, but the logic below creates
> specific and parseable logs in the 'dmesg' output and similar.
>
> I have written a tool that can decode these messages into useful human-re=
adable
> text so that I can debug firmware issues both locally and from field repo=
rts.
>
> Stock firmware generates similar logs and QCA could write their own decod=
e logic
> for their firmware versions.

Reinventing the wheel by using printk as the delivery mechanism doesn't
sound like a good idea. IIRC Emmanuel talked about some kind of firmware
debugging framework, he might have some ideas.

--=20
Kalle Valo=
