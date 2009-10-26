Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:21681 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbZJZJMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 05:12:00 -0400
Message-ID: <4AE567D2.8040102@nokia.com>
Date: Mon, 26 Oct 2009 11:11:46 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Kalle Valo <kalle.valo@iki.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>
Subject: Re: [RFC 1/3] mac80211: WIP - add operating BSSID to device configuration
 struct
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>	<1255696042-28413-2-git-send-email-luciano.coelho@nokia.com> <87tyxmh8i9.fsf@purkki.valot.fi>
In-Reply-To: <87tyxmh8i9.fsf@purkki.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Kalle Valo wrote:
> Luciano Coelho <luciano.coelho@nokia.com> writes:
> 
>> Some chips need to know the BSSID that we are interested in before we start
>> the association process.  This patch adds an operating BSSID to the device
>> configuration struct ieee80211_conf so that it can be passed to the driver
>> when op_config is called.
>>
>> With this solution we also solve the problem of some chips that require
>> an explicit disconnect command when disassociating.
> 
> You could explain here more how disconnection is possible. It's not
> obvious from the commit log.
> 
>> + * @oper_bssid: BSSID on which we are operating; some chips need to know
>> + *    which BSSID we are "tuned" to in order to improve power management,
>> + *    coexistence with other technologies (such as Bluetooth) and other
>> + *    filtering issues.
> 
> "Tuned" is confusing here. Also I think it's enough to specify the
> reasons in the commit log, and here just explain what the parameters
> is used for. Maybe something like this:
> 
> * @oper_bssid: BSSID on which we are operating; some chips need to
> *    know the BSSID before association. If zero, there is no
> *    association established nor any requests of it.
> 

Very good points.  I'll fix this as part of my rework on these patches.  Thanks 
for your comments!

-- 
Cheers,
Luca.
