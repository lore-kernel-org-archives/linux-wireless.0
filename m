Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46249 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1HELup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 07:50:45 -0400
Received: by gwaa12 with SMTP id a12so1614748gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Aug 2011 04:50:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E3BBC7F.9040902@openwrt.org>
References: <1312480447-27483-1-git-send-email-rmanohar@qca.qualcomm.com>
	<4E3AE3A0.2000308@openwrt.org>
	<20110805025452.GA28266@vmraj-lnx.users.atheros.com>
	<20110805083601.GA6702@vmraj-lnx.users.atheros.com>
	<4E3BBC7F.9040902@openwrt.org>
Date: Fri, 5 Aug 2011 19:50:44 +0800
Message-ID: <CAJ-VmomE7UCaetEGQU8xK1ysUyOzr97Wn7TVXAD3CubZfNg8VA@mail.gmail.com> (sfid-20110805_135051_425787_62794FF8)
Subject: Re: [PATCH v3 11/13] ath9k_hw: Disable Walsh spatial spreading for 2 chains
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. question: are the regulatory limits programmed into the cards
taking this spreading into effect?



Adrian

On 5 August 2011 17:48, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-08-05 10:36 AM, Rajkumar Manoharan wrote:
>>
>> On Fri, Aug 05, 2011 at 08:24:53AM +0530, Rajkumar Manoharan wrote:
>>>
>>>  On Thu, Aug 04, 2011 at 08:23:28PM +0200, Felix Fietkau wrote:
>>>  >  On 2011-08-04 7:54 PM, Rajkumar Manoharan wrote:
>>>  >  >The Walsh bit is disabled for regulatory consideration.
>>>  >  >
>>>  >  >As per the FCC rulings, only transmissions that are completely
>>>  >  >non-coherent, are allowed to waive the array gain contribution
>>>  >  >to EIRP for multi-transmit configurations. The use of 2-stream
>>>  >  >with 2 transmit and use of 3-steam with 3 transmit qualifies
>>>  >  >for this spatial multiplexing MIMO classification as long as
>>>  >  >the streams are directly mapped to each radio (not Walsh spread
>>>  >  >prior to splitting to multiple radios)
>>>  >  I think ath9k does not waive the array gain contribution. I haven't
>>>  >  checked AR9003, but on AR9002 and older, it explicitly includes the
>>>  >  array gain contribution in the tx power limit calculation. I'm not
>>>  >  sure that unconditionally disabling spatial spreading is the right
>>>  >  way to deal with this.
>>>  >
>>>  We might violate the FCC rule with 2x2 config(3dB higher at 2-stream)
>>>  if this bit is enabled. Based on chainmask we can disable Walsh bit.
>>
>> This change does not affect 3x3, since we don't use 2-chain for 2-stream.
>> And Walsh mode would follow INI setting for 2x2 or 3x3 config.
>
> The thing is, on many channels the the card is allowed to transmit at up to
> 27 dBm, and often the hardware does not even get close to that. Why limit tx
> power by disabling this bit in cases where it's not even close to going over
> the limit.
> How about disabling it only if the combined txpower is within x dBm of the
> regulatory limit, or simply adding the same kind of multi-chain limit
> calculation that is being used on AR9280?
>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
