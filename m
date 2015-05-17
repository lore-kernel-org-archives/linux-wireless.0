Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36823 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbEQSXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 14:23:35 -0400
Received: by lagv1 with SMTP id v1so189412046lag.3
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2015 11:23:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150517160513.GA13175@w1.fi>
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	<1431674716.2426.2.camel@sipsolutions.net>
	<CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
	<1431714949.2117.0.camel@sipsolutions.net>
	<CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
	<1431806229.2120.6.camel@sipsolutions.net>
	<20150517160513.GA13175@w1.fi>
Date: Sun, 17 May 2015 21:23:33 +0300
Message-ID: <CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com> (sfid-20150517_202600_797977_F07D3194)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 17, 2015 at 7:05 PM, Jouni Malinen <j@w1.fi> wrote:
> On Sat, May 16, 2015 at 09:57:09PM +0200, Johannes Berg wrote:
>> The key index is used for GTK rekeying. The spec makes no provision for
>> seamless PTK rekeying, it's simply not supported.
>>
>> There was/is work in progress to actually change that, but I haven't
>> seen anything definitive. Jouni might know more.
>
> It was added in IEEE Std 802.11-2012. Search for Extended Key ID for
> Individually Addressed Frames subfield of the RSN Capabilities field (a
> field within RSN element).
>
> I'm not sure whether anyone has implemented this, but anyway, we could
> relatively easily add support for this with mac80211 + hostapd +
> wpa_supplicant combination. Though, probably that would end up depending
> on a new driver capability flag, so only with some drivers.
>
>> As I said, I believe at this point the only way to fix this bug is to
>> try to drop *old* key packets immediately, but it's difficult to ensure
>> this. Effectively, it would require synchronising RX vs. key
>> installation.
>
> I did not look at the details of the reported issue. Was this an issue
> in a received frame with old key being processed by mac80211 after key
> change and while doing that, ending up configuring incorrect (way too
> large) RX PN for the new key?

Yes this is what Johannes is saying (I think). The user seems to say
that he sees a frame encrypted with the new key and that has an old IV
which is odd. Note that I started this thread by the big disclaimer of
"I don't know much about security and key handling". So I might talk
nonsense.

One thing that I still haven't understood here is how can we get to a
situation in which we already parsed the EAPOL of the GTK re-keying,
but not a data frame that must have been sent before the EAPOL?
The Rx path is serialized after all. I'd expect maybe to loose frames
because we are still using the old key while the new key has been sent
and not to get to the situation where:

data: old Key PN = 997
data: old Key PN = 998
data: old Key PN = 999
set new key PN = 0
data: old Key PN = 1000
(new key's PN gets set to 1000 ** BUG **)
data: new Key PN = 1 <DROPPED>

>
> Dropping the frames with the old key would be one option, but not really
> ideal. A somewhat nicer option would be to add a concept of generation
> to the key (i.e., the 1st, 2nd, ... key using key index N) and with the
> help of drivers (that can do this), indicate which generation of the key
> was used for RX decryption. This would allow proper replay protection
> for both keys if we were to store copies of the RX counters for both the
> previous and current key in mac80211.
>
Ah ok - but if the driver were ever to try to decrypt with the wrong
key, it'd get garbage and would drop the frame anyway, which would not
update the PN anyway. I know I am wrong, I just don't know where :)
