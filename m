Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36304 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752592AbdEPT5H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 15:57:07 -0400
Received: by mail-vk0-f49.google.com with SMTP id p85so51153005vkd.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 12:57:06 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mike@hellotwist.com
In-Reply-To: <1494579146.32348.3.camel@sipsolutions.net>
References: <CAKXXJEzWfNrQxquCzA5dkD5=xCXWyeAC+_yBT35N1oDk-H_Buw@mail.gmail.com>
 <20170510122458.GA4796@w1.fi> <CAKXXJEymJXEp70bUMuNCxDAA1CLCOJN4DjnPBkf5oh6Nqn7JQA@mail.gmail.com>
 <1494579146.32348.3.camel@sipsolutions.net>
From: Michael Skeffington <mike@astro.ai>
Date: Tue, 16 May 2017 15:57:05 -0400
Message-ID: <CAKXXJEwTWEeBP3gS6nnAxrhim1XbHGjiWZRmAGnDZdizD=1nzw@mail.gmail.com> (sfid-20170516_215728_378584_E0A55824)
Subject: Re: [PATCH] mac80211: Validate michael MIC before attempting packet decode.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Thank you for that.  I need to make a quick hack to send an invalid
MIC packet from another device to test the countermeasures.  Should I
submit a new patch with this change when I've completed testing or are
you already prepared to do so?

Michael

On Fri, May 12, 2017 at 4:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Here's the driver code from rt2500usb (but it's similar in the others):
>
>                 rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
>                 if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
>                         rxdesc->flags |= RX_FLAG_DECRYPTED;
>                 else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
>                         rxdesc->flags |= RX_FLAG_MMIC_ERROR;
>
> I think if you just change it to be
>
> [...]
>                 else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
>                         rxdesc->flags |= RX_FLAG_MMIC_ERROR |
>                                          RX_FLAG_DECRYPTED;
>
> things will start working. This is arguably correct since to be able to
> check the MMIC, the frame has to have been decrypted (properly) before.
>
> johannes
