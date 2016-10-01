Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:36104 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750906AbcJAMDN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Oct 2016 08:03:13 -0400
Received: by mail-yb0-f174.google.com with SMTP id z8so36545850ybh.3
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2016 05:03:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ed4a7366-3f67-79da-0868-876a69b1da54@broadcom.com>
References: <CANfLQrY6AVJoh8PW+5Ev0seKqnNRxRhK-N735q6Aa4KvdUVEcg@mail.gmail.com>
 <CANfLQrZxEUX0UMwrVNZHps9ztqxmOaeovy34fey2NkErCDDarQ@mail.gmail.com> <ed4a7366-3f67-79da-0868-876a69b1da54@broadcom.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 1 Oct 2016 17:32:52 +0530
Message-ID: <CABPxzYKWJ=uGchDkEOd_jL__h5qiR_BAmkPJ-CiaQC-SF5JtCA@mail.gmail.com> (sfid-20161001_140625_304051_1EBDD25D)
Subject: Re: bcmdhd: Strange Power Save messages
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Gucea Doru <gucea.doru@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Andra Paraschiv <andra.paraschiv7@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 1, 2016 at 2:52 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
>
> On 29-09-16 13:32, Gucea Doru wrote:
>> On Tue, Sep 27, 2016 at 12:03 PM, Gucea Doru <gucea.doru@gmail.com> wrote:
>>> What is the decision triggering the exit from the PS mode immediately
>>> after the ping request? I am asking this because 802.11 PS legacy
>>> specifies that the client should wait for a beacon with TIM set in
>>> order to wake up: in my case, there is no beacon between the ping
>>> request message and the Null frame that announces the exit from the PS
>>> mode.
>>
>>
>> Any help would be highly appreciated :)
>
> Actually though I already sent you are reply, but alas here it is.
>
> bcmdhd is our aosp driver. I am maintaining the upstream brcm80211
> drivers. Regardless your question is more for firmware running on the
> device. So like the same behavior would be observed when using brcmfmac
> with same firmware.
>
>> IEEE Std 802.11-2012, section 10.2.1.8 specifies that "when the STA
>> detects that the bit corresponding to its AID is 1 i the TIM, the STA
>> shall issue a PS Poll". In my capture there are cases when the STA
>> exits the PS mode without waiting for a beacon.
>
> It is a bit tricky, but the standard does not explicitly say the STA
> should be in power-save at any other time. So it is difficult to say
> what event occurred on the STA side to exit PS mode. Also STA means
> P2P-Client as you say. That means that you have multiple interfaces:
> regular STA and P2P-Client. So is the STA connected to some other AP or
> just not connected. wpa_supplicant will do intermittent scan or initiate
> scheduled scan by which firmware will scan at a certain interval. That
> is just some things I can come up with and I am sure there are more.
Keeping the STA aside, as far as AP is concerned the STA is still in PS,
so it should set the TIM/DTIM bit to 1 before sending out data to the STA.
Because the STA might be in power-off mode things seem to work.
