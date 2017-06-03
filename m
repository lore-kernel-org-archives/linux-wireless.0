Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35957 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdFCPqN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Jun 2017 11:46:13 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8PC_e8HdkBw4DfGUPO0BbM-W5wftK=i6_vjwFTmS7=axyFUw@mail.gmail.com>
References: <1496424146-10928-1-git-send-email-housel@acm.org> <CA+8PC_e8HdkBw4DfGUPO0BbM-W5wftK=i6_vjwFTmS7=axyFUw@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 3 Jun 2017 18:46:11 +0300
Message-ID: <CAHp75VeU5snppJAd-Wpa_oGbAmt8ZZhsoDH75rNaQ6Ti5myVmw@mail.gmail.com> (sfid-20170603_174642_475050_9476D3CD)
Subject: Re: [PATCH] brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain
To: Franky Lin <franky.lin@broadcom.com>
Cc: "Peter S. Housel" <housel@acm.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Christian Daudt <csd@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 2, 2017 at 9:52 PM, Franky Lin <franky.lin@broadcom.com> wrote:
> On Fri, Jun 2, 2017 at 10:22 AM, Peter S. Housel <housel@acm.org> wrote:

>>                 err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
>>                                          glom_skb);
>> -               if (err) {
>> -                       brcmu_pkt_buf_free_skb(glom_skb);
>> -                       goto done;
>> -               }

> What about
>         if (!err) {
>             skb_queue_walk(pktq, skb) {
>                 memcpy(skb->data, glom_skb->data, skb->len);
>                 skb_pull(glom_skb, skb->len);
>             }
>         }
>         brcmu_pkt_buf_free_skb(glom_skb);
>
> Then no goto is needed.

For my point of view it has two subtle inconveniences:
1. Not so usual pattern in use if (!ret)
2. Less error prone in case someone decides to expand the code and
missed ! or something else there.

Since both makes an approach less error prone I wouldn't suggest doing
that as I commented in new version.

-- 
With Best Regards,
Andy Shevchenko
