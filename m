Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45058 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0K2KUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 05:20:19 -0500
Message-ID: <4CF37E6F.2030409@ti.com>
Date: Mon, 29 Nov 2010 12:20:31 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH ] wl12xx: BA receiver support
References: <1290616392-16532-1-git-send-email-shahar_levi@ti.com> <1291024275.4284.4443.camel@wimaxnb.nmp.nokia.com>
In-Reply-To: <1291024275.4284.4443.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2010 11:51 AM, Juuso Oikarinen wrote:
> On Wed, 2010-11-24 at 18:33 +0200, ext Shahar Levi wrote:
>> Add new ampdu_action ops to support receiver BA.
>> The BA initiator session management in FW independently.
>>
>> Signed-off-by: Shahar Levi<shahar_levi@ti.com>
>> ---
[...]
>> +	/* Single link for now */
>> +	acx->link_id = 1;
>> +	acx->tid = tid_index;
>> +	acx->enable = policy;
>> +	acx->win_size = 0;
>> +
>
> Here the window size is configured to 0.
>
> As here the mac80211 does the processing and responding of the add BA
> request from the AP, how does the firmware know what window size
> eventually was taken into use?
>
> Also, as we already discussed on IRC, the mac80211 currently responds to
> the add BA request with the same window size suggested by the AP - in
> case of my test AP, this value is 64 - which is too large for the
> firmware to cope. So the firmware imposed limit to the window size must
> be handled somehow.
>
> -Juuso
you right. as discussed on IRC it should be done on the FW. we still 
looking on that.
thanks.


