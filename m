Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:34490 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbbERTeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 15:34:22 -0400
Received: by laat2 with SMTP id t2so234572351laa.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 12:34:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431961331.10489.1.camel@sipsolutions.net>
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	<1431674716.2426.2.camel@sipsolutions.net>
	<CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
	<1431714949.2117.0.camel@sipsolutions.net>
	<CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
	<1431806229.2120.6.camel@sipsolutions.net>
	<20150517160513.GA13175@w1.fi>
	<CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com>
	<1431890756.2129.13.camel@sipsolutions.net>
	<CANUX_P3ODruGc2rvV2gLNLU15kEmaJMXeU_ovtaBeOQGnYotoA@mail.gmail.com>
	<1431893157.2129.18.camel@sipsolutions.net>
	<CANUX_P0cJc4Ww5AY7sNFL5z4EPit+ngHvX=4eFXF96K-E8p3MA@mail.gmail.com>
	<1431894140.2129.20.camel@sipsolutions.net>
	<CB3B3D4774441E42AA3EA0E1BA8230A04DA98D91@HASMSX110.ger.corp.intel.com>
	<1431961331.10489.1.camel@sipsolutions.net>
Date: Mon, 18 May 2015 22:34:20 +0300
Message-ID: <CANUX_P1gfcq9_qiZSDwqNzu2PCcw-DEfu7JkSHZqb8UHmyWU8g@mail.gmail.com> (sfid-20150518_213425_702833_4C1DC6F5)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	"alexander.wetzel@web.de" <alexander.wetzel@web.de>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2015 at 6:02 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2015-05-18 at 06:14 +0000, Peer, Ilan wrote:
>
>> There is probably no synchronization between the 4way HS and other
>> data traffic on the transmitter side, as these are different
>> processes. So it is possible that after receiving message 3 and before
>> setting the keys, the HW would be able to decrypt additional frames
>> with the old key.
>
> Right. I think the "new key with old PN" part is probably not really
> happening, although it seems possible. I'd think we should look at the
> receiver first and only then move on to the transmitter if issues
> persist. Having a sniffer capture of the problem with known keys (!)
> would be useful though.
>

The submitter seems to say he sees the new key with old PN in the air.
He attached sniffer captures with known keys. I guess that Wireshark
is able to try different keys and check which one is the one that
leads to a successful decryption.
https://bugzilla.kernel.org/show_bug.cgi?id=92451#c14

I can indeed see that the PN is going back to one way after the EAPOL
frame exchange is finished.
Note that Windows doesn't seem to be suffering from this problem
(again - based on what the user said).
So basically, the sender is not behaving nice. It bumps the PN of the
new key. If the sender would have kept using the old key for a while
and change the IV and the key atomically, we would have been fine. We
would have dropped the packets until the sender finally uses the new
key, and this would not have bumped the PN of the new key. The problem
(IMHO) is that the sender use the *new* key which means that there is
no decryption failure with the old PN. And only later the PN goes back
to 1. I don't know how we can possibly work around this. And just like
the user is saying, I wonder how Windows doesn't suffer from the same
problem as mac80211...

>
>> AFAIK, the PTK is installed immediately after the 4th message is sent
>> without waiting to ACK or any other delay. As the AP (should) installs
>> the keys only after processing the 4th message, so a delay is
>> expected.
>
> Makes sense.
>
> johannes
>
