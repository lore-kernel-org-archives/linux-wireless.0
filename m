Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33850 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754971AbdELIwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 04:52:30 -0400
Message-ID: <1494579146.32348.3.camel@sipsolutions.net> (sfid-20170512_105236_948453_C6E3F45B)
Subject: Re: [PATCH] mac80211: Validate michael MIC before attempting packet
 decode.
From: Johannes Berg <johannes@sipsolutions.net>
To: mike@hellotwist.com, Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 May 2017 10:52:26 +0200
In-Reply-To: <CAKXXJEymJXEp70bUMuNCxDAA1CLCOJN4DjnPBkf5oh6Nqn7JQA@mail.gmail.com> (sfid-20170511_222236_614264_021DE9B1)
References: <CAKXXJEzWfNrQxquCzA5dkD5=xCXWyeAC+_yBT35N1oDk-H_Buw@mail.gmail.com>
         <20170510122458.GA4796@w1.fi>
         <CAKXXJEymJXEp70bUMuNCxDAA1CLCOJN4DjnPBkf5oh6Nqn7JQA@mail.gmail.com>
         (sfid-20170511_222236_614264_021DE9B1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-05-11 at 16:22 -0400, Michael Skeffington wrote:
> I am using an rt5350 SoC using the rt2x00 driver.  We were doing
> WiFi-alliance certification testing on our device and the it wasn't
> issuing countermeasures appropriately.
> 
> Your assumption is correct.  I had overlooked that devices using this
> driver have hardware decoding and the driver sets RX_FLAG_MMIC_ERROR.
> In retrospect, the change I proposed is totally broken.
> 
> I'm running through the failure case again so I can identify where in
> the rx_decrypt function it falls through.  It seems odd that it would
> drop the packet in rx_decrypt given that it doesn't actually do any
> decryption.  I suspect thats related to the underlying bug.

Here's the driver code from rt2500usb (but it's similar in the others):

                rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
                if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
                        rxdesc->flags |= RX_FLAG_DECRYPTED;
                else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
                        rxdesc->flags |= RX_FLAG_MMIC_ERROR;

I think if you just change it to be

[...]
                else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
                        rxdesc->flags |= RX_FLAG_MMIC_ERROR |
					 RX_FLAG_DECRYPTED;

things will start working. This is arguably correct since to be able to
check the MMIC, the frame has to have been decrypted (properly) before.

johannes
