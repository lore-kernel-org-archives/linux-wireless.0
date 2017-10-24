Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:48036 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751267AbdJXTTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 15:19:22 -0400
Received: by mail-lf0-f48.google.com with SMTP id k40so25221223lfi.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Oct 2017 12:19:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59EF65AE.8060803@candelatech.com>
References: <150851690590.5158.11970481736247725763.stgit@potku.adurom.net>
 <c9bdd915-0667-eee0-3b52-1fdf15abf249@dd-wrt.com> <CAGyitvP0wquoo_8_ma3rcj+riJ5Wgfo7+pmbUOx9pQRwFcQHYA@mail.gmail.com>
 <87376dds5e.fsf@kamboji.qca.qualcomm.com> <9407ed1f-2bd9-3fd0-981d-1a20452e8ba9@dd-wrt.com>
 <CAGyitvNj+74HafQ9Aps1HTmknTxa0ZUgV7hao1A8mJ4rV7cibw@mail.gmail.com>
 <8760b5cfnz.fsf@kamboji.qca.qualcomm.com> <59EF65AE.8060803@candelatech.com>
From: Jasmine Strong <jas@eero.com>
Date: Tue, 24 Oct 2017 12:19:00 -0700
Message-ID: <CAGyitvOjxws3=pSp6pLH2mwxCC7bcGVFc7GA90+6aH40-AwW7A@mail.gmail.com> (sfid-20171024_211943_615174_0F5E4F5C)
Subject: Re: [PATCH] ath10k: rebuild crypto header in RX data frames
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That can't be the case here, since we see it break the mesh too (where
the clients are other QCA radios.)

We're now seeing very slow mesh peering with a 9882 leaf to a 4019
gateway, with the second version of this patch.
It took more than five minutes for one of the leaves to successfully
peer (and the other 9882 leaf, despite achieving
peering, never managed to get DHCP, implying that something is broken
with data frames and this patch on qca9882.)

On Tue, Oct 24, 2017 at 9:09 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/23/2017 09:50 PM, Kalle Valo wrote:
>>
>> Jasmine Strong <jas@eero.com> writes:
>>
>>> That's what I saw.  A bcom client was able to associate and not pass
>>> any traffic.  This is on all three of 9882, 9888 and 4019.
>>
>>
>> Thanks for the report, we'll investigate it. And I see that your email
>> was now succesfully delivered to the list:
>>
>> http://lists.infradead.org/pipermail/ath10k/2017-October/010325.html
>
>
>
> I'm not sure if this is helpful or not, but in the transition from 10.1 to
> 10.2 firmware,
> there was some tricky re-work of the PN counter logic in the firmware
> source.  It had
> specific impact on the broadcom driver interaction.
>
> Possibly a similar issue is being seen with this driver patch?
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
