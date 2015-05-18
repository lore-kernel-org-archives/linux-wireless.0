Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41243 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbbEROkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 10:40:33 -0400
Message-ID: <5559F9DF.5090403@candelatech.com> (sfid-20150518_164037_167966_1D3628F7)
Date: Mon, 18 May 2015 07:40:31 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"Peer, Ilan" <ilan.peer@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"alexander.wetzel@web.de" <alexander.wetzel@web.de>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 drops packet with old IV after rekeying
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>	<1431674716.2426.2.camel@sipsolutions.net>	<CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>	<1431714949.2117.0.camel@sipsolutions.net>	<CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>	<1431806229.2120.6.camel@sipsolutions.net>	<20150517160513.GA13175@w1.fi>	<CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com>	<1431890756.2129.13.camel@sipsolutions.net>	<CANUX_P3ODruGc2rvV2gLNLU15kEmaJMXeU_ovtaBeOQGnYotoA@mail.gmail.com>	<1431893157.2129.18.camel@sipsolutions.net>	<CANUX_P0cJc4Ww5AY7sNFL5z4EPit+ngHvX=4eFXF96K-E8p3MA@mail.gmail.com>	<1431894140.2129.20.camel@sipsolutions.net>	<CB3B3D4774441E42AA3EA0E1BA8230A04DA98D91@HASMSX110.ger.corp.intel.com> <CALhHN=p1N8EzauGMddaQk29Gz3xPV7Pf=UO_8Ca7Xohsw3OoeQ@mail.gmail.com>
In-Reply-To: <CALhHN=p1N8EzauGMddaQk29Gz3xPV7Pf=UO_8Ca7Xohsw3OoeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/18/2015 01:03 AM, Janusz Dziedzic wrote:
> On 18 May 2015 at 08:14, Peer, Ilan <ilan.peer@intel.com> wrote:
>>
>>
>>> -----Original Message-----
>>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>>> owner@vger.kernel.org] On Behalf Of Johannes Berg
>>> Sent: Sunday, May 17, 2015 23:22
>>> To: Emmanuel Grumbach
>>> Cc: alexander.wetzel@web.de; Jouni Malinen; linux-wireless
>>> Subject: Re: mac80211 drops packet with old IV after rekeying
>>>
>>> On Sun, 2015-05-17 at 23:13 +0300, Emmanuel Grumbach wrote:
>>>
>>>>>> Yeah - ok. But how come we *already* set the pointer to the new key
>>>>>> while the HW is still successfully decrypting with the old key.
>>>>>> This is the point I can' figure out. I'd expect the transmitting
>>>>>> side to stop using the old key prior to sending the EAPOL (which
>>
>> There is probably no synchronization between the 4way HS and other data traffic on the transmitter side, as these are different processes. So it is possible that after receiving message 3 and before setting the keys, the HW would be able to decrypt additional frames with the old key.
>>
> In ath10k hw we have peer flag WMI_PEER_NEED_PTK_4_WAY.
> This will lock tx (discard data) until PTK_M4_SENT and install key
> after 4way HS.
> But I didn't check ptk_rekey and I am not sure this will help with all races.

I think at least the 10.1 firmware has bugs that keep this from actually working
just right.  Maybe later firmware works better.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
