Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48872 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbbEQT0A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 15:26:00 -0400
Message-ID: <1431890756.2129.13.camel@sipsolutions.net> (sfid-20150517_212602_571987_728B955C)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 17 May 2015 21:25:56 +0200
In-Reply-To: <CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com> (sfid-20150517_202334_293302_FFD28DB5)
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	 <1431674716.2426.2.camel@sipsolutions.net>
	 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
	 <1431714949.2117.0.camel@sipsolutions.net>
	 <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
	 <1431806229.2120.6.camel@sipsolutions.net> <20150517160513.GA13175@w1.fi>
	 <CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com>
	 (sfid-20150517_202334_293302_FFD28DB5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-05-17 at 21:23 +0300, Emmanuel Grumbach wrote:

> One thing that I still haven't understood here is how can we get to a
> situation in which we already parsed the EAPOL of the GTK re-keying,
> but not a data frame that must have been sent before the EAPOL?
> The Rx path is serialized after all. I'd expect maybe to loose frames
> because we are still using the old key while the new key has been sent
> and not to get to the situation where:
> 
> data: old Key PN = 997
> data: old Key PN = 998
> data: old Key PN = 999
> set new key PN = 0
> data: old Key PN = 1000
> (new key's PN gets set to 1000 ** BUG **)
> data: new Key PN = 1 <DROPPED>

Yeah, this is the situation. How it happens is like this:
(* - data, # - control)


 * data RX in HW, decrypt w/ old key, PN=998
 * data RX in mac80211 - PN <= 998 [old key]
 # set key pointer to new key
 * data RX in HW, decrypt w/ old key, PN=999
 * data RX in mac80211 - PN <= 999 [new key!! - PROBLEM FOR NEXT FRAME]
 # delete old key from HW crypto
 # add new key to HW crypto

Perhaps then the easier way to solve it would be to simply delete HW
crypto *before* changing the key pointer. Somewhat similar, but perhaps
simpler, than my previous patch. This would end up with the scenario
like this:

 * data RX in HW, decrypt w/ old key, PN=998
 * data RX in mac80211 - PN <= 998 [old key]
 # delete old key from HW crypto
 # set key pointer to new key
 * data RX in HW, decryption possible
 * data RX in mac80211, decrypt fails [old key was used, new key is
valid]
 # add new key to HW crypto

The problem with that approach is how to handle drivers that *must* use
HW crypto, like ath10k, and cannot fall back to software crypto. For
those, having a state where a key is valid in software but not uploaded
to hardware is basically an invalid state.

Then again, we can probably accept that for the transition period, as
the result really would only be to indicate to mac80211 that unencrypted
frames must not be accepted (key pointer exists.)

That'd look something like this:
http://p.sipsolutions.net/941c1a69a9c54a73.txt

johannes

