Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:38557 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbeDCQ40 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 12:56:26 -0400
Received: by mail-wr0-f178.google.com with SMTP id m13so19404277wrj.5
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 09:56:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0663e93cc5ca45e6b7191760414b1189@aphydexm01f.ap.qualcomm.com>
References: <0663e93cc5ca45e6b7191760414b1189@aphydexm01f.ap.qualcomm.com>
From: Steve deRosier <derosier@gmail.com>
Date: Tue, 3 Apr 2018 09:55:43 -0700
Message-ID: <CALLGbRJgAtOdZ1puzfgpWxc_ZrDVmWXtmFrBu=-gA0C++WrLoA@mail.gmail.com> (sfid-20180403_185631_455506_AFB46337)
Subject: Re: Wi-Fi Disconnection on Suspend for no wowlan triggers
To: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Amarnath Hullur Subramanyam <amarnath@qti.qualcomm.com>,
        Rajesh Chauhan <rajeshc@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sunil,

On Tue, Apr 3, 2018 at 5:39 AM, Sunil Dutt Undekari
<usdutt@qti.qualcomm.com> wrote:
> Hi All ,
>
> I would like to discuss on the commit 8125696991194aacb1173b6e8196d19098b44e17 (cfg80211/mac80211: disconnect on suspend) which triggers the STA disconnection on suspend if no wowlan triggers are registered.

This commit went in over five years ago. Sometime around v3.9

> I guess the intention here is to disconnect from the AP if the device cannot wake up on a packet / not configured with wowlan triggers .

It being a long time and not feeling like digging too deep into the
patch, what I can guess from a quick look is basically this:

* Before the patch, waking up from suspend would throw warnings into
the log. This patch fixes this.
* As you can't wake the processor, and you're a thin-mac chip who
depends on mac80211, you _can't_ do anything without wowlan.
* If your chip is not configured for wowlan, on a suspend, it might as
well go to sleep, as there's no sense in wasting power as you can't do
anything anyway.
* If you're going to sleep and can't respond to the AP, it's polite to
disconnect. And the AP is going to forcibly do so to you anyway after
some time of not hearing from you.

Hence the above in general concept seems perfectly correct and I don't
see any point in doing anything else with a mac80211 device.

> Can this behavior get enhanced to only do so on driver's preference -  do a disconnect for only the host drivers that would want to do so (through an additional feature capability) ?
>

Can? Perhaps. Send a patch. And maybe you could explain in detail what
the actual problem is you're trying to solve. Patches that are "maybe,
someday, someone might want to..." don't have a terribly high chance
of getting merged.  But solutions to real-life actual problems do. And
it's really difficult for us to speak on vague hypothetical musings.

- Steve

--
Steve deRosier
Cal-Sierra Consulting LLC
https://www.cal-sierra.com/
