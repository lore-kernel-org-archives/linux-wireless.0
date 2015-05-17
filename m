Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:35330 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbEQTtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 15:49:17 -0400
Received: by labbd9 with SMTP id bd9so191237416lab.2
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2015 12:49:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431890756.2129.13.camel@sipsolutions.net>
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	<1431674716.2426.2.camel@sipsolutions.net>
	<CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
	<1431714949.2117.0.camel@sipsolutions.net>
	<CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
	<1431806229.2120.6.camel@sipsolutions.net>
	<20150517160513.GA13175@w1.fi>
	<CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com>
	<1431890756.2129.13.camel@sipsolutions.net>
Date: Sun, 17 May 2015 22:49:15 +0300
Message-ID: <CANUX_P3ODruGc2rvV2gLNLU15kEmaJMXeU_ovtaBeOQGnYotoA@mail.gmail.com> (sfid-20150517_214920_019734_C33369F0)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 17, 2015 at 10:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2015-05-17 at 21:23 +0300, Emmanuel Grumbach wrote:
>
>> One thing that I still haven't understood here is how can we get to a
>> situation in which we already parsed the EAPOL of the GTK re-keying,
>> but not a data frame that must have been sent before the EAPOL?
>> The Rx path is serialized after all. I'd expect maybe to loose frames
>> because we are still using the old key while the new key has been sent
>> and not to get to the situation where:
>>
>> data: old Key PN = 997
>> data: old Key PN = 998
>> data: old Key PN = 999
>> set new key PN = 0
>> data: old Key PN = 1000
>> (new key's PN gets set to 1000 ** BUG **)
>> data: new Key PN = 1 <DROPPED>
>
> Yeah, this is the situation. How it happens is like this:
> (* - data, # - control)
>
>
>  * data RX in HW, decrypt w/ old key, PN=998
>  * data RX in mac80211 - PN <= 998 [old key]
>  # set key pointer to new key
>  * data RX in HW, decrypt w/ old key, PN=999
>  * data RX in mac80211 - PN <= 999 [new key!! - PROBLEM FOR NEXT FRAME]
>  # delete old key from HW crypto
>  # add new key to HW crypto

Yeah - ok. But how come we *already* set the pointer to the new key
while the HW is still successfully decrypting with the old key. This
is the point I can' figure out. I'd expect the transmitting side to
stop using the old key prior to sending the EAPOL (which #triggers the
set key pointer line). So those 2 lines don't make sense to me:

>  # set key pointer to new key
>  * data RX in HW, decrypt w/ old key, PN=999

After all, the Rx path is serialized all the way through from the air
to mac80211. The only thing I can think about is that the sending side
is still using the old key *after* it already sent its EAPOL frames.
Then, by pure change, we can still decrypt them in HW because the HW
hasn't been updated yet (these frames are successfully decrypted
because of race basically) and then, these frames come up to mac80211
*after* the EAPOL but with the old key.
This is what the submitter says:

"
The encryption key indeed changes immediately after the last packet of
the handshake, but the Initialization Vector is still counting up
against the old value.
"

So maybe that's the real issue?

>
> Perhaps then the easier way to solve it would be to simply delete HW
> crypto *before* changing the key pointer. Somewhat similar, but perhaps
> simpler, than my previous patch. This would end up with the scenario
> like this:
>
>  * data RX in HW, decrypt w/ old key, PN=998
>  * data RX in mac80211 - PN <= 998 [old key]
>  # delete old key from HW crypto
>  # set key pointer to new key
>  * data RX in HW, decryption possible
>  * data RX in mac80211, decrypt fails [old key was used, new key is
> valid]
>  # add new key to HW crypto
>
> The problem with that approach is how to handle drivers that *must* use
> HW crypto, like ath10k, and cannot fall back to software crypto. For
> those, having a state where a key is valid in software but not uploaded
> to hardware is basically an invalid state.
>
> Then again, we can probably accept that for the transition period, as
> the result really would only be to indicate to mac80211 that unencrypted
> frames must not be accepted (key pointer exists.)
>
> That'd look something like this:
> http://p.sipsolutions.net/941c1a69a9c54a73.txt
>
> johannes
>
