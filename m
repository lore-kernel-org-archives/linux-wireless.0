Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35236 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbcJAJWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Oct 2016 05:22:13 -0400
Received: by mail-wm0-f43.google.com with SMTP id f193so25063281wmg.0
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2016 02:22:12 -0700 (PDT)
Subject: Re: bcmdhd: Strange Power Save messages
To: Gucea Doru <gucea.doru@gmail.com>,
        Arend van Spriel <arend@broadcom.com>
References: <CANfLQrY6AVJoh8PW+5Ev0seKqnNRxRhK-N735q6Aa4KvdUVEcg@mail.gmail.com>
 <CANfLQrZxEUX0UMwrVNZHps9ztqxmOaeovy34fey2NkErCDDarQ@mail.gmail.com>
Cc: Andra Paraschiv <andra.paraschiv7@gmail.com>,
        linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ed4a7366-3f67-79da-0868-876a69b1da54@broadcom.com> (sfid-20161001_112217_967865_C5D7A1B3)
Date: Sat, 1 Oct 2016 11:22:11 +0200
MIME-Version: 1.0
In-Reply-To: <CANfLQrZxEUX0UMwrVNZHps9ztqxmOaeovy34fey2NkErCDDarQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 29-09-16 13:32, Gucea Doru wrote:
> On Tue, Sep 27, 2016 at 12:03 PM, Gucea Doru <gucea.doru@gmail.com> wrote:
>> What is the decision triggering the exit from the PS mode immediately
>> after the ping request? I am asking this because 802.11 PS legacy
>> specifies that the client should wait for a beacon with TIM set in
>> order to wake up: in my case, there is no beacon between the ping
>> request message and the Null frame that announces the exit from the PS
>> mode.
> 
> 
> Any help would be highly appreciated :)

Actually though I already sent you are reply, but alas here it is.

bcmdhd is our aosp driver. I am maintaining the upstream brcm80211
drivers. Regardless your question is more for firmware running on the
device. So like the same behavior would be observed when using brcmfmac
with same firmware.

> IEEE Std 802.11-2012, section 10.2.1.8 specifies that "when the STA
> detects that the bit corresponding to its AID is 1 i the TIM, the STA
> shall issue a PS Poll". In my capture there are cases when the STA
> exits the PS mode without waiting for a beacon.

It is a bit tricky, but the standard does not explicitly say the STA
should be in power-save at any other time. So it is difficult to say
what event occurred on the STA side to exit PS mode. Also STA means
P2P-Client as you say. That means that you have multiple interfaces:
regular STA and P2P-Client. So is the STA connected to some other AP or
just not connected. wpa_supplicant will do intermittent scan or initiate
scheduled scan by which firmware will scan at a certain interval. That
is just some things I can come up with and I am sure there are more.

Regards,
Arend
