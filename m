Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35693 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbbLAJsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:48:39 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 08/11] brcmfmac: Make 5G join preference configurable.
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
	<1448447567-12189-9-git-send-email-arend@broadcom.com>
	<87si3nkb2l.fsf@kamboji.qca.qualcomm.com>
	<565D5B77.7050501@broadcom.com>
Date: Tue, 01 Dec 2015 11:48:32 +0200
In-Reply-To: <565D5B77.7050501@broadcom.com> (Arend van Spriel's message of
	"Tue, 1 Dec 2015 09:33:59 +0100")
Message-ID: <87d1uqijnz.fsf@kamboji.qca.qualcomm.com> (sfid-20151201_104851_777160_94A1EA9B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 11/30/2015 11:58 AM, Kalle Valo wrote:
>> Arend van Spriel <arend@broadcom.com> writes:
>>
>>> From: Hante Meuleman <meuleman@broadcom.com>
>>>
>>> By default the 5G band has an advantage of 8 dBm on the RSSI when
>>> it comes to selection during join and roam. This patch adds a
>>> module param to make this value configurable. Using the value 99
>>> results in configuration that 5G has always preference over 2.4G.
>>>
>>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>
>> [...]
>>
>>> +/* Module param joinboost_5g used for preferred join selection.
>>> + * Use value 99 to configure preferred join to choose 5G always over 2.4G, any
>>> + * other value configures the advantage of 5G signal strength over 2.4G signal
>>> + * strength.
>>> + */
>>> +static int brcmf_joinboost_5g_rssi = BRCMF_JOIN_PREF_RSSI_BOOST;
>>> +module_param_named(joinboost_5g, brcmf_joinboost_5g_rssi, int, 0);
>>> +MODULE_PARM_DESC(joinboost_5g, "Join preference 5G RSSI boost");
>>
>> I'm not sure here, is a module parameter really the right way to
>> configure something like this?
>
> Define "right way".

Something which can be generic for all drivers/hw with similar design.
It's not good if a user is forced to configure this differently for each
driver. I have understood that this is a common problem anyway.

> It solves a problem for us, but admittedly it is not something that is
> very usable by user-space apps. So I guess what you are suggesting
> here is to come up with a nl80211 api for this. On the mailing list
> (or hostap list) the topic pops up from time to time so there are
> people who would like to have such a knob to play with. Still would
> like to keep the module parameter although its use may change when
> nl80211 api is added.

I don't know what is the best approach, that's why I would like to hear
opinions from others. Personally I don't like the idea of adding 802.11
level configuration options to module parameters, but on the other hand
I don't have any strong opinions about this.

I guess we have two different designs, one where the roaming logic is in
firmware and other where wpasupplicant is responsible for this. (And I
assume that brcfmac belongs to the former group.) Ideally it would be
nice that we would have a same configuration knob for both but I don't
know if that's really feasible.

-- 
Kalle Valo
