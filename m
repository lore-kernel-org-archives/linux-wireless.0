Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64264 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaCKPhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 11:37:06 -0400
Received: by mail-ie0-f175.google.com with SMTP id to1so9011106ieb.34
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 08:37:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <531F28D8.8010001@openwrt.org>
References: <1393073299-4831-1-git-send-email-nbd@openwrt.org>
	<CAGXE3d_wmuDi2kUjvhLGxSFMAxwcYgjLXJ78fPgyHmDN7m0cSw@mail.gmail.com>
	<531ED921.5040601@openwrt.org>
	<CAGXE3d-ku6EZsAo6ZksXxU4g9KTANnphmSGz3H_NUMfkaJGnew@mail.gmail.com>
	<531F28D8.8010001@openwrt.org>
Date: Tue, 11 Mar 2014 16:37:05 +0100
Message-ID: <CAGXE3d8v3T1NvbSW_jhLAUdr=FGQ7FVJt6VHAsMKCbZ165EPsg@mail.gmail.com> (sfid-20140311_163711_128611_2EEC7D8B)
Subject: Re: [PATCH 3.14] ath9k: fix ps-poll responses under a-mpdu sessions
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 11, 2014 at 4:16 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2014-03-11 15:22, Helmut Schaa wrote:
>> On Tue, Mar 11, 2014 at 10:36 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> On 2014-03-11 10:28, Helmut Schaa wrote:
>>>> On Sat, Feb 22, 2014 at 1:48 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>>> When passing tx frames to the U-APSD queue for powersave poll responses,
>>>>> the ath_atx_tid pointer needs to be passed to ath_tx_setup_buffer for
>>>>> proper sequence number accounting.
>>>>>
>>>>> This fixes high latency and connection stability issues with ath9k
>>>>> running as AP and a few kinds of mobile phones as client, when PS-Poll
>>>>> is heavily used
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>>> ---
>>>>
>>>> Hi Felix,
>>>>
>>>> this commit introduced a regression for me when using Intel Win7
>>>> clients on a ath9k AP.
>>>>
>>>> I was not able to track the exact issue down yet :( but it seems to be
>>>> related to the Intel
>>>> client constantly tearing down the BA session and entering/leaving PS mode.
>>>>
>>>> Any idea?
>>> Please make some packet captures and describe more clearly what the
>>> regression is. Do you see connections stalling, big latencies, etc?
>>
>> From what I can see with this patch action frames (like ADDBA and DELBA) get
>> sequence numbers from TID 0 assigned instead of a seq number from the global
>> counter. And that seems to "confuse" the client.
>>
>> The following patch solves the issue for me and seems to still keep
>> Felix original intention ...
> Looks good to me, also because it ensures that action/mgmt frames are
> sent out faster, even with filled data queues.
> To really make sure that this issue does not happen again, we should
> also have a check in ath_tx_setup_buffer where it actually assigns the
> seqno.

Good point, I'll add that too.
Helmut
