Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:35444 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122Ab3CGPwP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:52:15 -0500
Message-ID: <5138B656.5090408@neratec.com> (sfid-20130307_165226_276202_1D908EA0)
Date: Thu, 07 Mar 2013 16:46:30 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.8 1/3] ath9k_hw: fix calibration issues on chainmask
 that don't include chain 0
References: <1358715322-46447-1-git-send-email-nbd@openwrt.org> <5138A4C8.7040500@neratec.com> <5138AB4A.7000405@openwrt.org>
In-Reply-To: <5138AB4A.7000405@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2013 03:59 PM, Felix Fietkau wrote:
> On 2013-03-07 3:31 PM, Wojciech Dubowik wrote:
>> There is a regression introduced by this patch when power save is off on
>> the station for idle checks.
>> I have AR9590 station with rx and tx chain set to 0x1 connected
>> to legacy AP (based on Ar9390) with RF cable and 40dB attenuator.
>>
>> Before this patch in connection polling the station was properly sending
>> null function to check whether AP is still there. After this patch it sends
>> broadcast probe request which is anyway wrong or some 16 or so packets
>> of random data (rarely). It manifests itself in lost connection because
>> there
>> is no ack from AP which is expected for null function.
>>
>> I have been following skb's up to the descriptor setting in ath9k and it was
>> all ok i.e. proper null function with valid addresses.
>>
>> I have been bisecting it twice because it doesn't make much sense but maybe
>> it's a HW issue?
> You're right, it does not make much sense. I can't figure out how this
> patch could possibly change the runtime behavior with tx chainmask set
> to 0x1. Have you tried reverting this patch in a current build to see if
> that fixes the issue?
It does fix it. I will check tomorrow whether it's only AR9590 or also
previous revisions. I will also try with different chainmasks. I will have
to rescrew my setup...

Wojtek
