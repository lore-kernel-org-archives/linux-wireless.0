Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59952 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbBJGJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 01:09:38 -0500
Received: by mail-wg0-f41.google.com with SMTP id b13so11306717wgh.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 22:09:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54D8DA6F.7040805@candelatech.com>
References: <1423224354-24955-1-git-send-email-michal.kazior@tieto.com>
	<54D4E89A.7040602@candelatech.com>
	<CA+BoTQ=HqyGKOBdOmpWOn_VjH1UTWF9nN_PE0uanaGsdeJmB6Q@mail.gmail.com>
	<54D8DA6F.7040805@candelatech.com>
Date: Tue, 10 Feb 2015 07:09:36 +0100
Message-ID: <CA+BoTQk9C_7efUs6VTZrEz5ECxsvCgfA8ObrAXKjqMpTL8pggA@mail.gmail.com> (sfid-20150210_070942_804121_89AFB28F)
Subject: Re: [RFT] ath10k: restart fw on tx-credit timeout
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matti Laakso <malaakso@elisanet.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 February 2015 at 17:03, Ben Greear <greearb@candelatech.com> wrote:
> On 02/08/2015 10:24 PM, Michal Kazior wrote:
>> On 6 February 2015 at 17:15, Ben Greear <greearb@candelatech.com> wrote:
[...]
>>> At least in my tests, I could continue
>>> to receive network traffic while WMI was blocked.
>>
>>
>> Yeah. Traffic works with the tx-credit starvation as well but what
>> good is this if you have inconsistent driver-firmware state after
>> failing to send a few commands?
>
>
> I just mention it because someone debugging the system might
> wonder why the firmware is 'locked up' while it is still passing traffic.

I might as well include this info in the commit log.


> If it is just powersave issue, could you force (overriding wmi tx-credits
> limit)
> a flush at the 1 second mark and hope it recovers by 3 second timeout?

Well, there's a couple of problems with that.

1) you suggest to call wmi_flush() which calls wmi_cmd_send() *while*
in wmi_cmd_send(),
2) you're out of credits, how do you intend to submit a frame,
3) yes, you can force it, but that's super ugly,
4) and this still doesn't guarantee you'll get your tx-credit due to
firmware quirkiness.

(but maybe the latest 10.2.4 behaves differently? who knows..)

My original stab at this involved a proactive flushing but it had it's
problems (delayed mgmt frames, could still get stuck in rare cases).


Michał
