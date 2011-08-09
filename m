Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12804 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1HIRHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 13:07:44 -0400
Date: Tue, 9 Aug 2011 20:07:36 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Bill Jordan <bjordan@rajant.com>
CC: Felix Fietkau <nbd@openwrt.org>, <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [PATCH] ath: Fix hardware decryption of WEP
Message-ID: <20110809170736.GC19300@jouni.qca.qualcomm.com> (sfid-20110809_190748_358772_311FAB04)
References: <1312831193-8691-1-git-send-email-bjordan@rajant.com>
 <4E4095C2.3010607@openwrt.org>
 <20110809080400.GB2961@jouni.qca.qualcomm.com>
 <CAFKp-_eykU7RPzcfEPg0a+eXie-uCFreFa-er+NfeVoT543BTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAFKp-_eykU7RPzcfEPg0a+eXie-uCFreFa-er+NfeVoT543BTA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2011 at 11:58:33AM -0400, Bill Jordan wrote:
> I was attempting to fix WEP AP mode.  I was surprised to find that received
> data packets were decrypted in software.

Ah, I see. This is bit problematic when keeping in mind that there could
be multiple BSSes in use with different set of WEP configuration. If you
put one of them in the key indexes 0..3, you may not be able to use the
other BSSes correctly (in theory, it could be possible with some hacks
when only a single WEP key is configured per BSS, but I don't think it
is worth the effort to do that for WEP). As such, there would need to be
code that is capable of dynamically kicking out the key cache entries
0..3 should another BSS be set up. I don't think mac80211 has support
for this at the moment, so that may require considerable amount of extra
work. And again, it is questionable whether there is really any good
justification for doing this with WEP that is not even allowed to be
used with HT and as such, is limited in throughput anyway.

> I thought WEP should be programming the first 4 hardware keys based
> on code in ath9k_rx_skb_postprocess:
> 	} else if (ieee80211_has_protected(fc)
> 		   && !decrypt_error && skb->len >= hdrlen + 4) {
> 		keyix = skb->data[hdrlen + 3] >> 6;
> 
> 		if (test_bit(keyix, common->keymap))
> 			rxs->flag |= RX_FLAG_DECRYPTED;
> 	}
> 
> This code only works if the first 4 hardware keys are used.

There are some semi-odd hacks needed for figuring out whether the frame
was really decrypted in some cases (i.e., whether the flag in RX
descriptor is valid). This is one of those corner cases..

> In order to support dynamic WEP keys, all WEP decryption must be done
> in software? Am I understanding that correctly?

Not with dynamic WEP keys. With those, the AP does not really receive
any broadcast/multicast frames and only the per-station individual key
is used for RX at the AP. As such, hardware can pick the correct key
based on the transmitter address.

The most problematic case with key cache and support for multiple BSSes
is use of static WEP where the different BSSes have conflicting needs
for finding the key on RX processing if the different BSSes share the
same key index (and especially if they use multiple key indexes). While
it would be theoretically possible to improve this, it is way too easy
to break some other corner cases unless you are very careful with the
key cache use in the driver. As such, I don't really want to spend the
time reviewing this type of changes without a good justification for the
improvement (and anything with WEP in it is unlikely to be considered
good justification in 2011 ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
