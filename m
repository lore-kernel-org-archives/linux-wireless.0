Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0079.outbound.protection.outlook.com ([104.47.36.79]:64455
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750815AbdABO3W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 09:29:22 -0500
Subject: Re: [PATCH] cfg80211: Random local address for Public Action frame
 exchange
To: Johannes Berg <johannes@sipsolutions.net>, <jouni@qca.qualcomm.com>
References: <1482266379-9723-1-git-send-email-jouni@qca.qualcomm.com>
 <cf228384-c98e-737e-3ba6-6c18e988210c@quantenna.com>
 <1483356523.4596.12.camel@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <vamsin@qti.qualcomm.com>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <c7eaea82-a5be-d047-c67a-ce9e58b4b65f@quantenna.com> (sfid-20170102_152926_988710_A1823079)
Date: Mon, 2 Jan 2017 17:29:12 +0300
MIME-Version: 1.0
In-Reply-To: <1483356523.4596.12.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2017 02:28 PM, Johannes Berg wrote:
> On Fri, 2016-12-30 at 22:55 +0300, IgorMitsyanko wrote:
>>> The driver needs to configure receive behavior to accept frames to
>>> the
>>> specified random address during the time the frame exchange is
>>> pending
>>> and such frames need to be acknowledged similarly to frames sent to
>>> the
>>> local permanent address when this random address functionality is
>>> not
>>> used.
>> A (probably) silly question: how wireless drivers are supposed to use
>> SA
>> in a frame? I think drivers are not concerned about source address,
>> they
>> simply pass whatever there is already set by userspace in
>> cfg80211_mgmt_tx_params::buf into air on Tx.
>> And on Rx, they filter frames based on receiver address/BSSID, pass
>> it
>> to upper layers and do not care what address is in DA (it is handled
>> by
>> upper layers).
> They do care about the DA in RX, since - as the commit message states -
> "such frames need to be acknowledged [...]"

Acknowledgment is done for transmitter<->receiver addresses,
not for source<->destination?
Patch talks about source address randomization, but I guess it actually
  meant transmitter address (basically dynamic BSSID config?). Maybe naming
should be changed in the patch.

For  NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED case,
I wonder if HW can be configured to not filter-out multiple BSSIDs or 
the idea
is that while random_sa frame is pending for ACK, HW will drop all 
frames destined
for initially configured BSSID?

>
> johannes
>
