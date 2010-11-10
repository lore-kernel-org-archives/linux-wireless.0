Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37353 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab0KJTpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 14:45:00 -0500
Message-ID: <4CDAF634.1010001@candelatech.com>
Date: Wed, 10 Nov 2010 11:44:52 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath5k:  Adjust opmode when interfaces are removed.
References: <1286564475-10105-1-git-send-email-greearb@candelatech.com> <201010121044.39093.br1@einfach.org> <4CB3C3A3.5040309@candelatech.com> <201010121148.19073.br1@einfach.org>
In-Reply-To: <201010121148.19073.br1@einfach.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 07:48 PM, Bruno Randolf wrote:
> On Tue October 12 2010 11:10:43 Ben Greear wrote:
>> On 10/11/2010 06:44 PM, Bruno Randolf wrote:
>>> On Sat October 9 2010 04:01:15 greearb@candelatech.com wrote:
>>>> +
>>>> +	/* Calculate combined mode - when APs are active, operate in AP mode.
>>>> +	 * Otherwise use the mode of the new interface. This can currently
>>>> +	 * only deal with combinations of APs and STAs. Only one ad-hoc
>>>> +	 * interfaces is allowed above.
>>>
>>> the comment reference to "above" does not make sense here any more.
>>
>> This patch is already in..but I can send a followup cleanup patch.
>
> just for the comment it's probably not worth it, but...
>
>>>> ieee80211_vif *vif) +static void ath_do_set_opmode(struct ath5k_softc
>>>> *sc)
>>>> +{
>>>> +	struct ath5k_hw *ah = sc->ah;
>>>> +	ath5k_hw_set_opmode(ah, sc->opmode);
>>>> +	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
>>>> +		  sc->opmode,
>>>> +		  ath_opmode_to_string(sc->opmode) ?
>>>> +		  ath_opmode_to_string(sc->opmode) : "UKNOWN");
>>>> +}
>>>
>>> what's the point of this function? just to add the debug print?
>>
>> Yes.  At one point, I had it being called from several places..but now it's
>> called from only one place currently, I think.  I could make it explicitly
>> inline code if someone cared.
>
> i think i do care. could you please just open-code it at the one place where
> you call this function?

I just posted a patch to do these two things.

Thanks for the suggestions!

Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

