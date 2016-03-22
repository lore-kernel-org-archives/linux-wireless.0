Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:34339 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023AbcCVKFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 06:05:43 -0400
Received: by mail-qg0-f51.google.com with SMTP id w104so173967033qge.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2016 03:05:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F113B3.2050608@neratec.com>
References: <CAAA5faG+AOviPrJxd9dOuZrDAkm+4F5sy0M7w3MW0U-ufNeZ3g@mail.gmail.com>
	<56F113B3.2050608@neratec.com>
Date: Tue, 22 Mar 2016 04:05:42 -0600
Message-ID: <CAAA5faHhiwwVYJVp9TEeg7M4YksRgOhHpVnge655ztd8VuC+tw@mail.gmail.com> (sfid-20160322_110547_144695_D46954AD)
Subject: Re: making fq_codel default
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
To: Matthias May <matthias.may@neratec.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, that answers my question.
Ok, so currently Cake didn't make it into the 4.4 kernel yet I noticed.
Are there plans to add this or are there still many issues to be worked out?
In the mean time I followed some instructions to build the module and
iproute2 for cake.

sudo tc qdisc add  dev wlp4s0 root cake (iwlwifi)

reinoud@router-dev:~/Downloads/linux-4.4.5/net/sched$ sudo tc -s qdisc show

qdisc cake 8002: dev wlp4s0 root refcnt 5 unlimited diffserv4 flows
rtt 100.0ms raw
Sent 71025 bytes 516 pkt (dropped 0, overlimits 0 requeues 0)
backlog 0b 0p requeues 0
memory used: 0b of 15140Kb
capacity estimate: 0bit
            Tin 0       Tin 1       Tin 2       Tin 3
 thresh        0bit        0bit        0bit        0bit
 target       5.0ms       5.0ms       5.0ms       5.0ms
interval     100.0ms     100.0ms     100.0ms     100.0ms
Pk-delay         0us         0us         0us         0us
Av-delay         0us         0us         0us         0us
Sp-delay         0us         0us         0us         0us
 pkts             0           0           0           0
 bytes            0           0           0           0
way-inds           0           0           0           0
way-miss           0           0           0           0
way-cols           0           0           0           0
 drops            0           0           0           0
 marks            0           0           0           0
Sp-flows           0           0           0           0
Bk-flows           0           0           0           0
last-len           0           0           0           0
max-len            0           0           0           0

On Tue, Mar 22, 2016 at 3:43 AM, Matthias May <matthias.may@neratec.com> wrote:
> On 22/03/16 10:37, Reinoud Koornstra wrote:
>>
>> Hi Everyone,
>>
>> Everytime I boot I need to set fq_codel for my wireless interface:
>>
>> sudo tc qdisc add   dev wlp4s0 root fq_codel
>>
>> I also need to sudo sysctl -w net.core.default_qdisc=fq_codel
>>
>> Is there a good way to have this as the default in the kernel config
>> instead of pfifo?
>> Also, are there plans for cake support or do fq_codel in this case mean
>> cake?
>> Thanks,
>>
>> Reinoud.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> You might want to take a look at the patches in openwrt.
> Specifically this one:
> https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-4.4/662-use_fq_codel_by_default.patch
>
> Best regards
> Matthias
