Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46630 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab1AKQbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 11:31:41 -0500
Received: by ewy5 with SMTP id 5so9385865ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 08:31:40 -0800 (PST)
Message-ID: <4D2C85FE.4030709@lwfinger.net>
Date: Tue, 11 Jan 2011 10:31:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Locking problem reported for mainline
References: <4D2A9309.7000500@lwfinger.net> <201101101913.17311.chunkeey@googlemail.com> <4D2B59EA.4000200@lwfinger.net> <201101102018.35232.chunkeey@googlemail.com>
In-Reply-To: <201101102018.35232.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2011 01:18 PM, Christian Lamparter wrote:
> On Monday 10 January 2011 20:11:38 Larry Finger wrote:
>> On 01/10/2011 12:13 PM, Christian Lamparter wrote:
>>> Does this patch help?
>>>
>>> ---
>>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>>> index a6701ed..8f13a83 100644
>>> --- a/net/mac80211/rx.c
>>> +++ b/net/mac80211/rx.c
>>
>> Did not compile. In ieee80211_release_reorder_frame at lines 552 and 554, rx is
>> not defined.
>>
> Oops,
> 
> you are right. Fixed the copy&paste error, so this one should compile.

No, the patch did not help.

Is there a document that explains what the meaning of these semantics?

inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
kdostartupconfi/3502 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&(&list->lock)->rlock#5){?.-...}, at: [<ffffffff812995c6>]
skb_queue_tail+0x26/0x60
{HARDIRQ-ON-W} state was registered at:
...

It appears that the problem is with rtlwifi, thus I need to sort it out. Google
has not been my friend in this case.

Thanks,

Larry

