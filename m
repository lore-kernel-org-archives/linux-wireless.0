Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966609AbeEXLsU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 07:48:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Mack <daniel@zonque.org>
Cc: loic.poulain@linaro.org, linux-wireless@vger.kernel.org,
        bjorn.andersson@linaro.org, nicolas.dechesne@linaro.org,
        wcn36xx@lists.infradead.org, rfried@codeaurora.org
Subject: wcn36xx: bug #538: stuck tx management frames
References: <20180516140820.1636-1-daniel@zonque.org>
        <95b89ceb-cc25-023e-9fa2-e45b2deb5027@zonque.org>
        <874lj5jj96.fsf@kamboji.qca.qualcomm.com>
        <65b0f1d0-0c74-0efb-c7ca-c0fbae681810@zonque.org>
        <877entigth.fsf@codeaurora.org>
        <00f05d66-3076-0e49-f4af-74c797210948@zonque.org>
Date: Thu, 24 May 2018 14:48:13 +0300
In-Reply-To: <00f05d66-3076-0e49-f4af-74c797210948@zonque.org> (Daniel Mack's
        message of "Thu, 24 May 2018 11:40:58 +0200")
Message-ID: <87a7spcm0y.fsf_-_@kamboji.qca.qualcomm.com> (sfid-20180524_134850_282007_96280C48)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(I'll change the subject to better reflect what we are discussing.)

Daniel Mack <daniel@zonque.org> writes:
> On Thursday, May 24, 2018 10:44 AM, Kalle Valo wrote:
>> Daniel Mack <daniel@zonque.org> writes:
>>> On Friday, May 18, 2018 01:28 PM, Kalle Valo wrote:
>
>>>> Also I would recommend to file a bug to bugzilla.kernel.org so that all
>>>> the information is one place and it can be easily updated. Now it's
>>>> pretty difficult to get the big picture from various emails on the list.
>>>
>>> Yes, I agree it's a bit convoluted. However, there's already the bug
>>> report on 96board.org that Bjorn opened some time back, and I
>>> considered that sufficient. IMO, it has all the information needed,
>>> plus a link to a tool to reproduce the issue.
>>>
>>>    https://bugs.96boards.org/show_bug.cgi?id=538
>>
>> Yeah, bugs.96boards.org is fine. As long as there's one place which
>> collects all the information about the bug.
>>
>> But IMHO the bug report is not telling much, all I get is that TX frames
>> get stuck but not even that is confirmed. After reading it I have at
>> least these questions:
>>
>> * Is it really confirmed that the issue is that TX frames are stuck? For
>>    example, using a wireless sniffer would confirm that.
>
> Yes, that's confirmed. I have a 2nd machine tuned to the same channel
> than the network I use for testing, and once the timeouts happen, I
> cannot see any frame anymore from the MAC of the wcn36xx. No probe
> requests for scans, no authentication attempts, nothing.
>
> As my test constantly connects and disconnects, the last thing I see
> in wireshark is a deauthentication frame.

Thanks, this is good to know.

>> * Are only management frames stuck or does it also involve data frames?
>
> It seems that once a network is successfully joined, the network
> stability is fine. I haven't seen any starvation of streams lately, at
> least not with the the patches in this series which I'm running since
> a while. That is, until a disconnect/reconnect attempt is made, and at
> this point, only management frames are involved.

Ah, maybe originally you were seeing different issues with similar
symptoms? But now you have fixed the other bugsand now the stuck
transmitted management frame issue is left? Just guessing...

>> * Based on the bug report the TX stuck issue seems to happen during
>>    authentication, but what happens before that? Does wcn36xx get
>>    disconnected from AP or what?
>
> As I said, my test setup includes repeated disconnections to make the
> bug appear. It sometimes happens at the first attempt after a fresh
> boot, however, so the stress test only makes debugging a bit easier by
> increasing the likeliness.
>
>> * Any wcn36xx logs about the issue (with or without debug logs)? Also
>>    matching wpasupplicant logs would help.
>
> The problem with this is that it's not exactly clear what kind of
> effect we're looking at. With all the debug flags of the driver
> enabled, it produces so much log output that wpa_supplicant gives up
> due to timeouts. The other weird issue is that with WCN36XX_DBG_MAC
> and/or WCN36XX_DBG_SMD enabled, the effect is _much_ harder to
> trigger.

It would be great to have wcn36xx logging via tracing, just like ath10k
and iwlwifi does. This way logging shouldn't slow down the system too
much and with wpasupplicant's -T switch you can even get wpasupplicant's
debug messages to the same log with proper timestamps! And almost
forgot, you can also include mac80211 tracing logs as well:

https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/tracing

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/debug#tracing

See ath10k_dbg() and trace_ath10k_log_dbg() for ideas how to implement
this, and you can also take a look at iwlwifi. Should be pretty easy.
Patches more than welcome :)

>> * Does this only happen with encryption or also in open mode?
>
> That's a good question. I'll go check with an open network.

Thanks.

>> * How long does it take with qconnman-stress to reproduce the issue?
>
> Usually less than 10 minutes.

That's really good, makes it so much easier to verify potential fixes.

>> * Does the radio environment make any difference on reproducibility? For
>>    example, clear enviroment vs lots of traffic/interference?
>
> It seems it does, yes. Tests at night seem to take a bit more time to
> make the effect happen. But then again, it could also be unrelated. I
> can't be certain at this point.

Can you describe what kind of radio environment you have, is it a busy
office complex? How many APs around etc?

-- 
Kalle Valo
