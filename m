Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17088 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763069AbcLSMCJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 07:02:09 -0500
From: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "nbd@nbd.name" <nbd@nbd.name>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/3] mac80211: Implement data xmit for 802.11 encap offload
Date: Mon, 19 Dec 2016 12:02:00 +0000
Message-ID: <5857CC37.80003@qti.qualcomm.com> (sfid-20161219_130308_167628_8D40F52D)
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
        <1481781608-5181-3-git-send-email-vthiagar@qti.qualcomm.com>
        <1481794142.31776.5.camel@sipsolutions.net>
        <58528607.7090101@qti.qualcomm.com>
        <85c98160-3ee9-07db-cb4c-9e300f0ba798@nbd.name>
        <1481809984.2582.5.camel@sipsolutions.net>
        <58537DA3.1090901@qti.qualcomm.com> <878trckurn.fsf@purkki.adurom.net>
In-Reply-To: <878trckurn.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 19 December 2016 05:15 PM, Kalle Valo wrote:
> "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com> writes:
>
>> On Thursday 15 December 2016 07:23 PM, Johannes Berg wrote:
>>>
>>>>> I agree. Dynamic switch part is buggy, we can start with not
>>>>> allowing interfaces resulting in dynamic switch.
>>>>
>>>> Does this mean that when bringing up multiple interfaces, users would
>>>> need to figure out the 'magic' order that works?
>>>
>>> I think we need to talk about hardware capabilities at this point.
>>
>> QCA988X does not have capability to configure vif specific decap mode. E=
ncap mode
>> is configurable per packet for all the ath10k based chips so this part s=
hould be
>> fine to support per vif configuration. Newer QCA chips like QCA9984, QCA=
4019, QCA9888
>> and QCA99X0 supports decap mode configuration per vif.
>
> When you say "all" are you also taking into account QCA6174 and QCA9377?

Good point. I see some workarounds for QCA6174 to send data frames in ether=
net mode,
so QCA6174 should be fine in this regard. I assume QCA9377 also works fine =
with
ethernet encap configuration per htt desc, need to confirm.

Vasanth=
