Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34931 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbcCVNY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 09:24:56 -0400
Received: by mail-oi0-f54.google.com with SMTP id w20so118826632oia.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2016 06:24:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAA5faHhiwwVYJVp9TEeg7M4YksRgOhHpVnge655ztd8VuC+tw@mail.gmail.com>
References: <CAAA5faG+AOviPrJxd9dOuZrDAkm+4F5sy0M7w3MW0U-ufNeZ3g@mail.gmail.com>
	<56F113B3.2050608@neratec.com>
	<CAAA5faHhiwwVYJVp9TEeg7M4YksRgOhHpVnge655ztd8VuC+tw@mail.gmail.com>
Date: Tue, 22 Mar 2016 06:24:55 -0700
Message-ID: <CAA93jw5YjyxV0MVTnzPNHXYetx0TiHsJygH7DfqPyZjA8pEeRA@mail.gmail.com> (sfid-20160322_142500_560099_55D8F010)
Subject: Re: making fq_codel default
From: Dave Taht <dave.taht@gmail.com>
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: Matthias May <matthias.may@neratec.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	cake@lists.bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 22, 2016 at 3:05 AM, Reinoud Koornstra
<reinoudkoornstra@gmail.com> wrote:
> Thanks, that answers my question.

Adding this to /etc/sysctl.conf or /etc/sysctl.d/bufferbloat.conf is
generally what we do

net.core.default_qdisc=fq_codel

A lot of us are running ecn by default and put in ecn on also:

net.ipv4.tcp_ecn=1

> Ok, so currently Cake didn't make it into the 4.4 kernel yet I noticed.
> Are there plans to add this or are there still many issues to be worked out?

The last major test series in late december showed issues with the
then codel implementation, which was presumably fixed, and then also
the new "triple queue isolation" code landed, which is still something
of a head scratcher to test for the problem it's trying to solve
(better per host fairness while still getting ).

It has been my hope to see cake mainlined for about 4 linux kernel
versions now, but the code has sprouted a great deal more
instrumentation that I, personally, would like (like nearly all the
stats below), and additional complexity, that may not be needed, it
still could use some fixes (particularly in GRO peeling), diffserv
modeling still has disputes, and performance analysis and tuning on
the kinds of hardware (arm, mips) it is intended for, especially at a
gbit.

It is being incorporated in a couple openwrt builds, could use more
eyeballs and testers, to firmly escape second system syndrome.
Discussions are held on the cake mailing list.

https://lists.bufferbloat.net/pipermail/cake/2015-December/001755.html

I hope we can resume major testing on it again by the end of april.

> In the mean time I followed some instructions to build the module and
> iproute2 for cake.

Comparison tests on your workloads and your specific devices between
pfifo, fq_codel, and cake are welcomed, but I am pessimistic about any
effects without a bql-like layer underneath it. The consensus
generally is that while some cake-like algos might apply to wifi, the
work needs to happen at the ieee80211 layer rather than the qdisc
layer.

The principal use case for cake for wifi has been in analyzing codel's
behavior in the face of shifting rates on

tc change dev wifi0 root cake bandwidth 10mbit
sleep 2
tc change dev wifi0 root cake bandwidth 50mbit
sleep 2
tc change dev wifi0 root cake bandwidth 20mbit




> sudo tc qdisc add  dev wlp4s0 root cake (iwlwifi)
>
> reinoud@router-dev:~/Downloads/linux-4.4.5/net/sched$ sudo tc -s qdisc show
>
> qdisc cake 8002: dev wlp4s0 root refcnt 5 unlimited diffserv4 flows
> rtt 100.0ms raw
> Sent 71025 bytes 516 pkt (dropped 0, overlimits 0 requeues 0)
> backlog 0b 0p requeues 0
> memory used: 0b of 15140Kb
> capacity estimate: 0bit
>             Tin 0       Tin 1       Tin 2       Tin 3
>  thresh        0bit        0bit        0bit        0bit
>  target       5.0ms       5.0ms       5.0ms       5.0ms
> interval     100.0ms     100.0ms     100.0ms     100.0ms
> Pk-delay         0us         0us         0us         0us
> Av-delay         0us         0us         0us         0us
> Sp-delay         0us         0us         0us         0us
>  pkts             0           0           0           0
>  bytes            0           0           0           0
> way-inds           0           0           0           0
> way-miss           0           0           0           0
> way-cols           0           0           0           0
>  drops            0           0           0           0
>  marks            0           0           0           0
> Sp-flows           0           0           0           0
> Bk-flows           0           0           0           0
> last-len           0           0           0           0
> max-len            0           0           0           0

Groovy. Go pound it flat with some tests and let us know if any of
these statistics are useful to you.

> On Tue, Mar 22, 2016 at 3:43 AM, Matthias May <matthias.may@neratec.com> wrote:
>> On 22/03/16 10:37, Reinoud Koornstra wrote:
>>>
>>> Hi Everyone,
>>>
>>> Everytime I boot I need to set fq_codel for my wireless interface:
>>>
>>> sudo tc qdisc add   dev wlp4s0 root fq_codel
>>>
>>> I also need to sudo sysctl -w net.core.default_qdisc=fq_codel
>>>
>>> Is there a good way to have this as the default in the kernel config
>>> instead of pfifo?
>>> Also, are there plans for cake support or do fq_codel in this case mean
>>> cake?
>>> Thanks,
>>>
>>> Reinoud.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> You might want to take a look at the patches in openwrt.
>> Specifically this one:
>> https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-4.4/662-use_fq_codel_by_default.patch
>>
>> Best regards
>> Matthias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
