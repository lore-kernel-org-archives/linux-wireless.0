Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57725 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2BFLQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 06:16:53 -0500
Received: by bkcjm19 with SMTP id jm19so4573280bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 03:16:51 -0800 (PST)
Message-ID: <4F2FB6A0.5030901@gmail.com> (sfid-20120206_121657_111442_70918D9B)
Date: Mon, 06 Feb 2012 12:16:48 +0100
From: "zefir.kurtisi@gmail.com" <zefir.kurtisi@gmail.com>
MIME-Version: 1.0
To: "Goldenshtein, Victor" <victorg@ti.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
References: <1327581484-22047-1-git-send-email-victorg@ti.com>	<1327581484-22047-4-git-send-email-victorg@ti.com>	<4F277F85.1090901@sipsolutions.net> <CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com> <4F2B18AA.90809@neratec.com>
In-Reply-To: <4F2B18AA.90809@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2012 05:06 PM, zefir.kurtisi@gmail.com wrote:
> On 02.02.2012 17:06, Goldenshtein, Victor wrote:
>> On Tue, Jan 31, 2012 at 7:43 AM, Johannes Berg
>> <johannes@sipsolutions.net>  wrote:
>>> On 1/26/2012 4:37 AM, Victor Goldenshtein wrote:
>>>>
>>>> The dfs master device should monitor radar channels
>>>> for potential radar interference for a minimum of
>>>> CAC (channel availability check) time, during this
>>>> period no tx can occur. If no radar interference
>>>> is detected the dfs master may initiate the tx with
>>>> new NL80211_CMD_DFS_ENABLE_TX command.
>>>
>>>
>>> So do we think that no safeguards here at all are acceptable? Not even
>>> checking that radar detection was enabled, CAC time expired, etc.?
>>
>> We can add a check whether dfs is supported by the driver
>> (rdev->wiphy.features&  NL80211_FEATURE_DFS).
>>
>> The nl/cfg/mac doesn't have the info whether the radar detection is
>> enabled and definitely doesn't heard about CAC time, on other hand the
>> driver which starts/handles radar detection know whether it started or
>> not. I think the driver should perform this simple "sanity" checks,
>> otherwise we"ll need to save different DFS states in the mac, not sure
>> that this is what we want.
>>
>>
>>
> I noticed this issue working on interfacing ath9k to your DFS 
> [ ... more unfinished garbage ]

Sorry folks for that garbage. My Thunderbird crashed in the middle of writing and for some reason sent out the draft after restart (which I noticed right now).

So, what I really wanted to comment is:

I noticed this issue working on interfacing ath9k to your DFS management component. When a DFS channel is initially set, the driver has no information whether to block TX or not (as opposed to ap_process_chanswitch() providing these flags). What is the assumption here? Is the driver required to check itself whether a DFS channel is set and raise some internal tx_disabled flag to be reset via hw_dfs_en_tx()? With all the logic being located in hostap, this looks inconsistent (but doable).

Aside from that, I managed to interface ath9k to the proposed component. So far, it enables me to set up a DFS monitor to physically test my pattern detectors, while it fails to run in master mode. Need to go through the trace logs to isolate the problem and will report then.


Thanks
Zefir
