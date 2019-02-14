Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=BITCOIN_SPAM_02,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFDBC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E41222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392733AbfBNJs2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:48:28 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:48583 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388835AbfBNJs2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 04:48:28 -0500
Received: from [192.168.178.52] ([109.104.48.212]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MlNgx-1hLXYa1qrF-00lpB7; Thu, 14 Feb 2019 10:48:17 +0100
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
From:   Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
Date:   Thu, 14 Feb 2019 10:48:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190214092530.GA17273@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:OJDaf7knUAtzqy/D2fWaf9H/gBzG+GEt1Z6eRt15xARpDJAZEz2
 jxzj+CYjv+lQYdMPKnOsNcRXFyOyxhcWLDx003AGCxqro3DyGzVzNve/TTS3KPgEfWkerZ6
 Is3KvZ1rfEU+wGnexJUcvsiQGPm7nWxIDI6A2vyZQwkAv3LzY5cybRb5yrVFxNRxvLnJjHZ
 pE1pR2PZFJv+N1Wtee6ag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+0mOMnrU5SU=:n8Jpj+6aetJlILB8q+5FfW
 V0WioveIv5AEccUPElbcRClUkDbLyeaE2A+qq1zchKq01CRGoXxTSnlhiAmJvVH+vXujO8UFU
 Wds7AJuaHpu4ABOttWU31B34EizUKBAWO955uf06sGbZR9FsZ8gU/yFINAXMNa1bAjz5Di5Yb
 WHnOw6wd1+3CRSlTIGIc+WP5nvznPh000/62RYsSJ40IF2OQLLwizlIlNF2cNBbxXZgUuUTI7
 umVpV6sZ4uSeNdqLakITLMn3q7dDaupqMNDu7u3pkSwpIDsEPV67wrnBEnM6J76SDAOUBhbLp
 ywgMh2ojxQMwH1+NiO9zLHHRRsac1yqJOHkF3hYnzRq/O4ZJ2HpguGjToeXC1fubFGs54hcf5
 n9sjuXtC8TZHbME4wVjlFqlpCJ0GJCND2zyoCTmpu+ZnWueA9QX08pmhkiGXDo7BnKDuxqLpe
 eBTP3nLSZj+KNLEw+2ZtdErQ3DAOpgaM0BT4y8kjCZA+N58yZcBS9SX84U2+ZKRGt3SRq0Lho
 s22ETAwsmVN4B9haWjAih1mZTUK+1mxIwloP/L0Ibo4DERt6VpaONPTg+/vV0DfHBOppQxEcr
 Ap0nXryvKPVngTu+skKOpQV3jI6rRpq5hcB0iofYFWOzdW2dBh4pRPsqIjt1BGnAtLaz9yNzd
 6FvE7oBpoJAOdgvbgs1ZihbqdFdk/dPdGwFpje7YqKwx7oqce9M2t9sE6CNafo6Drwj/NvQ0b
 Ovn70XE9IQG9GncxIchpV6fJ63OJtDnrbFLgKCRa8t7+9+5nAMcpK3rTJoc=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stanislaw,

Am 14.02.19 um 10:25 schrieb Stanislaw Gruszka:
> On Thu, Feb 14, 2019 at 07:49:57AM +0100, Stefan Wahren wrote:
>> Hi Stanislaw,
>>
>>> Stanislaw Gruszka <sgruszka@redhat.com> hat am 12. Februar 2019 um 10:30 geschrieben:
>>>
>>>
>>>
>>> In usb_sg_init() urb->num_sgs is set 0 for sg_tablesize = 0 controllers.
>>> In mt76 we set urb->num_sgs to 1. I thought it is fine, but now I think
>>> this is bug. We can fix that without changing allocation method and
>>> still use SG allocation. Attached patch do this, please check if it works
>>> on rpi. Patch is on top of your error path fixes.
>> your patch didn't apply cleanly to yesterdays next. After some minor manual fixup, i was able to build them and here are the results starting from boot (please ignore the invalid time in the kernel log):
>> https://gist.github.com/lategoodbye/33bd5bc75b9fc935faa231bc472defa8
> I think this is due to urb->transfer_length and sg[0]->length mismatch,
> which should be addressed by my other patch. I'm attaching the patch
> rebased on -next with this line integrated, please test. 
>
> But there could be other bug's in mt76-usb SG code.
Will retry
>
>> Using multi_v7_defconfig i'm getting a warning on the first connect and always this flood of rx urb failed on disconnect. The driver seems to probe but isn't functional even after 2 tries.
>>
>> Using arm64_defconfig i don't get any warning. But except of this i'm getting similiar results to multi_v7_defconfig.
>>
>> So in comparison, Lorenzo's workaround behaves better.
> I'm pretty sure problem is mt76x0u 4.19 -> 4.20 regression intrduced by
> integrating mt76x0u in mt76-usb (things do not work from day 0
> for mt76x2u). We should find fix(es) that will be proper for -stable.
So i should also try 4.19 without any patches?
>
> Stanislaw 

