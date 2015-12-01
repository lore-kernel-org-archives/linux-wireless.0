Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:21683 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbbLAIeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 03:34:01 -0500
Message-ID: <565D5B77.7050501@broadcom.com> (sfid-20151201_093408_913178_7A825F10)
Date: Tue, 1 Dec 2015 09:33:59 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 08/11] brcmfmac: Make 5G join preference configurable.
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>	<1448447567-12189-9-git-send-email-arend@broadcom.com> <87si3nkb2l.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87si3nkb2l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2015 11:58 AM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> By default the 5G band has an advantage of 8 dBm on the RSSI when
>> it comes to selection during join and roam. This patch adds a
>> module param to make this value configurable. Using the value 99
>> results in configuration that 5G has always preference over 2.4G.
>>
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>
> [...]
>
>> +/* Module param joinboost_5g used for preferred join selection.
>> + * Use value 99 to configure preferred join to choose 5G always over 2.4G, any
>> + * other value configures the advantage of 5G signal strength over 2.4G signal
>> + * strength.
>> + */
>> +static int brcmf_joinboost_5g_rssi = BRCMF_JOIN_PREF_RSSI_BOOST;
>> +module_param_named(joinboost_5g, brcmf_joinboost_5g_rssi, int, 0);
>> +MODULE_PARM_DESC(joinboost_5g, "Join preference 5G RSSI boost");
>
> I'm not sure here, is a module parameter really the right way to
> configure something like this?

Define "right way". It solves a problem for us, but admittedly it is not 
something that is very usable by user-space apps. So I guess what you 
are suggesting here is to come up with a nl80211 api for this. On the 
mailing list (or hostap list) the topic pops up from time to time so 
there are people who would like to have such a knob to play with. Still 
would like to keep the module parameter although its use may change when 
nl80211 api is added.

Regards,
Arend
