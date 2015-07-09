Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34776 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbbGIMgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 08:36:32 -0400
Received: by lbnk3 with SMTP id k3so74244486lbn.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 05:36:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2576505.6RpAF3j2eF@lx-wigig-72>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1436081080-27305-12-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<CANUX_P0OLXxf_kj2SaYOeeQmQ7XHOhjMWia76--CLq15pXKWRQ@mail.gmail.com>
	<2576505.6RpAF3j2eF@lx-wigig-72>
Date: Thu, 9 Jul 2015 15:36:30 +0300
Message-ID: <CANUX_P1hsQXUqkUOb5gy22PekeUb=k44xE8mTx0d=NRE1xNOdA@mail.gmail.com> (sfid-20150709_143713_558498_B6350C4C)
Subject: Re: [PATCH 11/13] wil6210: TSO implementation
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Vladimir Kondratiev <QCA_vkondrat@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wil6210@qca.qualcomm.com,
	Vladimir Shulman <QCA_shulmanv@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 9, 2015 at 2:37 PM, Vladimir Kondratiev
<QCA_vkondrat@qca.qualcomm.com> wrote:
> On Wednesday, July 08, 2015 10:06:37 PM Emmanuel Grumbach wrote:
>> So your device is able to replicate and update the IP / TCP header?
>> I don't really follow what your device is able to do.
>> You seem to be cutting the frags so that their length sums up to mss.
>> Which hints that your device can't segment the buffer by itself. OTOH,
>> I don't see how you treat the IP / TCP header copy and modification.
>>
> Emmanuel:
> Yes, it is correct - hardware know to replicate IP/TCP header; and
> DMA written in such a way that I have to arrange fragments to
> sums up to MSS.

Ok - thanks for clarifying this.

>
> So this code fragment is OK. We tested it with lots of traffic.
> However, after your comments for another code fragment,
> I found there is a way to do it better. I'll rework and send updated patch.
>

I am working on something similar but our hardware does nothing for
us. I hope to send my version next week as an RFC.

> Kalle: please drop this patch. The rest of patches should apply cleanly
> without this one.
>
> Thanks, Vladimir
