Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60595 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751509AbeBTLNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 06:13:33 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Steve deRosier <derosier@gmail.com>,
        sdnlabs Janakaraj <wsuprabhu@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: testing tool for packet delay
In-Reply-To: <CALLGbR+taP7GU4ftX5wFPvxD0BUsCiBDxjGXWeOJi9_nYLhEww@mail.gmail.com>
References: <CAPWex-AFApTucOo4DGk2n30X7Y0N2NrNv2u+8ubqTL4SkhxgwA@mail.gmail.com> <CALLGbR+taP7GU4ftX5wFPvxD0BUsCiBDxjGXWeOJi9_nYLhEww@mail.gmail.com>
Date: Tue, 20 Feb 2018 12:13:31 +0100
Message-ID: <87tvubdick.fsf@toke.dk> (sfid-20180220_121337_512196_17F7D459)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> On Mon, Feb 19, 2018 at 9:19 AM, sdnlabs Janakaraj <wsuprabhu@gmail.com> wrote:
>>
>> Hello All,
>>
>> I am working on delay analysis of packets in wireless stacks. I am
>> able to see lots of papers talk about therotical analysis. But I am
>> more interested in practical evaluation.
>>
>> I am reaching out to developers community to learn how they actually
>> evaluate the performance of the stack. In particular, I am looking for
>> ideas to evaluate the delay experienced by packets within the
>> mac802.11 stack.
>>
>
> Hi Prabhu,
>
> Sounds like an interesting project. More often my instrumentation
> focuses on aggregate performance and iperf throughput numbers suffices
> for most of that. Occasionally I utilize internal performance measures
> and/or data provided me by ftrace and related tools.
>
> If you're unfamiliar with it, I suggest you look at the Bufferbloat
> and Make-wifi-fast projects. I suspect that their data and techniques
> and tools might be of interest to you:
>
> https://www.bufferbloat.net/projects/make-wifi-fast/

Bufferbloat/make-wifi-fast community member checking in ;)

Basically, what we've been doing to analyse (and reduce) the latency of
the queueing system in the WiFi stack, is to put it under load and
measure how it behaves. This is not so much through the use of tracing
tools as it is an end-to-end black-box measurement approach.

The go-to mechanism for this is to run a latency measurement (either a
simple ICMP ping, or a UDP measurement flow using a tool such as
irtt[1]), then load the connection with one or more TCP flows and see
how it impacts latency. You can of course vary the number of flows,
diffserv markings, etc. to get different insights.

I'm the author of a test tool that automates a lot of this and which can
also collect a lot of statistics from the stack while doing so. The tool
is called Flent[2] and is open source. Feel free to try it out and ask
any questions that come up :)

-Toke

[1] https://github.com/peteheist/irtt/
[2] https://flent.org
