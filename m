Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:35359 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbeBTWGu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 17:06:50 -0500
Received: by mail-wr0-f171.google.com with SMTP id l43so18680736wrc.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 14:06:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87tvubdick.fsf@toke.dk>
References: <CAPWex-AFApTucOo4DGk2n30X7Y0N2NrNv2u+8ubqTL4SkhxgwA@mail.gmail.com>
 <CALLGbR+taP7GU4ftX5wFPvxD0BUsCiBDxjGXWeOJi9_nYLhEww@mail.gmail.com> <87tvubdick.fsf@toke.dk>
From: sdnlabs Janakaraj <wsuprabhu@gmail.com>
Date: Tue, 20 Feb 2018 17:06:29 -0500
Message-ID: <CAPWex-A6smsFq0_sbGwThJF0_6168sbXY8gcLattYNgNYoRe3g@mail.gmail.com> (sfid-20180220_230655_549354_8D4064AC)
Subject: Re: testing tool for packet delay
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Toke,
Thanks for sharing this information.

I took a look at Flent yesterday and planning to test it by the
weekend due to something things I have to catch up with.



On Tue, Feb 20, 2018 at 6:13 AM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@tok=
e.dk> wrote:
> Steve deRosier <derosier@gmail.com> writes:
>
>> On Mon, Feb 19, 2018 at 9:19 AM, sdnlabs Janakaraj <wsuprabhu@gmail.com>=
 wrote:
>>>
>>> Hello All,
>>>
>>> I am working on delay analysis of packets in wireless stacks. I am
>>> able to see lots of papers talk about therotical analysis. But I am
>>> more interested in practical evaluation.
>>>
>>> I am reaching out to developers community to learn how they actually
>>> evaluate the performance of the stack. In particular, I am looking for
>>> ideas to evaluate the delay experienced by packets within the
>>> mac802.11 stack.
>>>
>>
>> Hi Prabhu,
>>
>> Sounds like an interesting project. More often my instrumentation
>> focuses on aggregate performance and iperf throughput numbers suffices
>> for most of that. Occasionally I utilize internal performance measures
>> and/or data provided me by ftrace and related tools.
>>
>> If you're unfamiliar with it, I suggest you look at the Bufferbloat
>> and Make-wifi-fast projects. I suspect that their data and techniques
>> and tools might be of interest to you:
>>
>> https://www.bufferbloat.net/projects/make-wifi-fast/
>
> Bufferbloat/make-wifi-fast community member checking in ;)
>
> Basically, what we've been doing to analyse (and reduce) the latency of
> the queueing system in the WiFi stack, is to put it under load and
> measure how it behaves. This is not so much through the use of tracing
> tools as it is an end-to-end black-box measurement approach.
>
> The go-to mechanism for this is to run a latency measurement (either a
> simple ICMP ping, or a UDP measurement flow using a tool such as
> irtt[1]), then load the connection with one or more TCP flows and see
> how it impacts latency. You can of course vary the number of flows,
> diffserv markings, etc. to get different insights.
>
> I'm the author of a test tool that automates a lot of this and which can
> also collect a lot of statistics from the stack while doing so. The tool
> is called Flent[2] and is open source. Feel free to try it out and ask
> any questions that come up :)
>
> -Toke
>
> [1] https://github.com/peteheist/irtt/
> [2] https://flent.org
