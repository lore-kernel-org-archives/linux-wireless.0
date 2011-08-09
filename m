Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54048 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1HIP6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 11:58:55 -0400
Received: by qyk38 with SMTP id 38so2332633qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 08:58:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110809080400.GB2961@jouni.qca.qualcomm.com>
References: <1312831193-8691-1-git-send-email-bjordan@rajant.com>
	<4E4095C2.3010607@openwrt.org>
	<20110809080400.GB2961@jouni.qca.qualcomm.com>
Date: Tue, 9 Aug 2011 11:58:33 -0400
Message-ID: <CAFKp-_eykU7RPzcfEPg0a+eXie-uCFreFa-er+NfeVoT543BTA@mail.gmail.com> (sfid-20110809_175859_212664_BC0F79CA)
Subject: Re: [ath9k-devel] [PATCH] ath: Fix hardware decryption of WEP
From: Bill Jordan <bjordan@rajant.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 9, 2011 at 4:04 AM, Jouni Malinen <jouni@qca.qualcomm.com> wrote:
> On Mon, Aug 08, 2011 at 08:04:50PM -0600, Felix Fietkau wrote:
>> On 2011-08-08 1:19 PM, Bill Jordan wrote:
>> > The first 4 hardware key indexes are reserved for WEP, but
>> > never programmed. The result was that WEP always used
>> > software decryption.
>
> Not really.. They have a special role receiving group addressed frames
> and may be used with static WEP configuration, but there is no strict
> reservation of them being for WEP or other key indexes not being
> available for WEP.
>
>> > diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
>> > @@ -501,7 +501,11 @@ int ath_key_config(struct ath_common *common,
>> >     if (key->keylen)
>> >             memcpy(hk.kv_val, key->key, key->keylen);
>> >
>> > -   if (!(key->flags&  IEEE80211_KEY_FLAG_PAIRWISE)) {
>> > +   if (hk.kv_type == ATH_CIPHER_WEP) {
>> > +           if (key->keyidx>= IEEE80211_WEP_NKID)
>> > +                   return -EOPNOTSUPP;
>> > +           idx = key->keyidx;
>> > +   } else if (!(key->flags&  IEEE80211_KEY_FLAG_PAIRWISE)) {
>> I'm not sure this is a good idea, this would break adding pairwise WEP
>> keys. Also, maybe WEP keys could use the BSSID in the lookup to avoid
>> the first 4 keycache slots, that way it'd work properly in multi-BSSID
>> AP setups.
>
> Agreed, this should not be applied.
>
> As far as AP mode is concerned, there is no need to actually receive
> group addressed frames, so other key slots can be used regardless of the
> key index. Multi-BSSID AP setup with multiple BSSes that use static WEP
> keys is not going to work well, but then again, no one really should be
> using WEP anymore and I have no problems forcing that special use case
> to use software encryption/decryption. While dynamic WEP key setup with
> IEEE 802.1X is not really that much better, doing changes to improve
> some static WEP cases at the cost of reduced dynamic WEP functionality
> does not sound like a good direction.
>
> If the goal here was to improve station mode functionality in the case
> where a single WEP network is being used, it should be done more
> carefully to avoid causing problems to other cases.

I was attempting to fix WEP AP mode.  I was surprised to find that received
data packets were decrypted in software.

I thought WEP should be programming the first 4 hardware keys based
on code in ath9k_rx_skb_postprocess:
	} else if (ieee80211_has_protected(fc)
		   && !decrypt_error && skb->len >= hdrlen + 4) {
		keyix = skb->data[hdrlen + 3] >> 6;

		if (test_bit(keyix, common->keymap))
			rxs->flag |= RX_FLAG_DECRYPTED;
	}

This code only works if the first 4 hardware keys are used.

In order to support dynamic WEP keys, all WEP decryption must be done
in software? Am I understanding that correctly?

Bill Jordan
