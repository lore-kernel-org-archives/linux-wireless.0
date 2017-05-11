Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:34240 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754823AbdEKUWg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 16:22:36 -0400
Received: by mail-ua0-f175.google.com with SMTP id g49so35963961uaa.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 13:22:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mike@hellotwist.com
In-Reply-To: <20170510122458.GA4796@w1.fi>
References: <CAKXXJEzWfNrQxquCzA5dkD5=xCXWyeAC+_yBT35N1oDk-H_Buw@mail.gmail.com>
 <20170510122458.GA4796@w1.fi>
From: Michael Skeffington <mike@astro.ai>
Date: Thu, 11 May 2017 16:22:35 -0400
Message-ID: <CAKXXJEymJXEp70bUMuNCxDAA1CLCOJN4DjnPBkf5oh6Nqn7JQA@mail.gmail.com> (sfid-20170511_222240_188183_FB9D1C82)
Subject: Re: [PATCH] mac80211: Validate michael MIC before attempting packet decode.
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using an rt5350 SoC using the rt2x00 driver.  We were doing
WiFi-alliance certification testing on our device and the it wasn't
issuing countermeasures appropriately.

Your assumption is correct.  I had overlooked that devices using this
driver have hardware decoding and the driver sets RX_FLAG_MMIC_ERROR.
In retrospect, the change I proposed is totally broken.

I'm running through the failure case again so I can identify where in
the rx_decrypt function it falls through.  It seems odd that it would
drop the packet in rx_decrypt given that it doesn't actually do any
decryption.  I suspect thats related to the underlying bug.

On Wed, May 10, 2017 at 8:24 AM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, May 09, 2017 at 02:16:31PM -0400, Michael Skeffington wrote:
>> In order to allow wpa_supplicant to correctly identify a perceived WPA TKIP key
>> recovery attack the michael MIC must be checked before the packet decode is
>> attempted.  A packet with an invalid MIC will always fail a decrypt check which
>> previously was being checked first.  Therefore the MIC failure bit of
>> status flags
>> describing the error would remain unset.
>
> Which driver and WLAN hardware are you using? Michael MIC is encrypted,
> so to be able to check that, the frame will obviously need to be
> decrypted first. If that WEP decryption fails, this frame needs to be
> dropped without indicating Michael MIC failure. WEP part here is
> completely independent of Michael MIC.
>
> It is possible that there is a driver that handles these steps in
> hardware/firmware and if so, that driver may have a bug if you do not
> see Michael MIC failures reported correctly. Anyway, as Johannes pointed
> out, this part in mac80211 is in the correct sequence and that cannot be
> changed since it would completely break TKIP for more or less all
> software-based cases.
>
> --
> Jouni Malinen                                            PGP id EFC895FA
