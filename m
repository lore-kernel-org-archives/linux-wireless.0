Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33881 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbbERIDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 04:03:32 -0400
Received: by wguv19 with SMTP id v19so117034995wgu.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 01:03:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04DA98D91@HASMSX110.ger.corp.intel.com>
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
Date: Mon, 18 May 2015 10:03:30 +0200
Message-ID: <CALhHN=p1N8EzauGMddaQk29Gz3xPV7Pf=UO_8Ca7Xohsw3OoeQ@mail.gmail.com> (sfid-20150518_100337_427491_183C9E8D)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"alexander.wetzel@web.de" <alexander.wetzel@web.de>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 May 2015 at 08:14, Peer, Ilan <ilan.peer@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Johannes Berg
>> Sent: Sunday, May 17, 2015 23:22
>> To: Emmanuel Grumbach
>> Cc: alexander.wetzel@web.de; Jouni Malinen; linux-wireless
>> Subject: Re: mac80211 drops packet with old IV after rekeying
>>
>> On Sun, 2015-05-17 at 23:13 +0300, Emmanuel Grumbach wrote:
>>
>> > >> Yeah - ok. But how come we *already* set the pointer to the new key
>> > >> while the HW is still successfully decrypting with the old key.
>> > >> This is the point I can' figure out. I'd expect the transmitting
>> > >> side to stop using the old key prior to sending the EAPOL (which
>
> There is probably no synchronization between the 4way HS and other data traffic on the transmitter side, as these are different processes. So it is possible that after receiving message 3 and before setting the keys, the HW would be able to decrypt additional frames with the old key.
>
In ath10k hw we have peer flag WMI_PEER_NEED_PTK_4_WAY.
This will lock tx (discard data) until PTK_M4_SENT and install key
after 4way HS.
But I didn't check ptk_rekey and I am not sure this will help with all races.

>> > >> #triggers the set key pointer line). So those 2 lines don't make sense to
>> me:
>> > >>
>> > >> >  # set key pointer to new key
>> > >> >  * data RX in HW, decrypt w/ old key, PN=999
>> > >>
>> > >> After all, the Rx path is serialized all the way through from the
>> > >> air to mac80211. The only thing I can think about is that the
>> > >> sending side is still using the old key *after* it already sent its EAPOL
>> frames.
>> > >
>> > > Not sure, isn't the key only installed on EAPOL acknowledgement or so?
>> > > With PTK rekeying, I'm not really sure what the timing is, and
>> > > there's not really any way it can be correct (without extended key
>> > > ID support.)
>> >
>> > Whatever the timing is, since the Rx path is serialized, there
>> > shouldn't be any timing issues. Or at least, I can't figure out how
>> > these lines above could be in the order you put them.
>>
>> I agree that it'll depend on how the key is installed on the sender, however, I
>> have no idea how that's done and how much potential delay there is between
>> sending the EAPOL frame and installing the key there.
>> If you're looking at RX path synchronisation only then you're assuming a
>> perfect sender, but that clearly cannot be the case.
>>
>
> AFAIK, the PTK is installed immediately after the 4th message is sent without waiting to ACK or any other delay. As the AP (should) installs the keys only after processing the 4th message, so a delay is expected.
>
> Regards,
>
> Ilan.
