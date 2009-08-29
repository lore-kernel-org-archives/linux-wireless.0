Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55478 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752203AbZH2LdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 07:33:24 -0400
Message-ID: <4A991203.8070407@gmx.de>
Date: Sat, 29 Aug 2009 13:33:23 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [RFT] ar9170: use eeprom's frequency calibration values
References: <200908212252.41053.chunkeey@web.de> <1250927567.23605.9.camel@johannes.local>
In-Reply-To: <1250927567.23605.9.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2009 09:52 AM, Johannes Berg wrote:
> On Fri, 2009-08-21 at 22:52 +0200, Christian Lamparter wrote:
> 
>> Johannes, in phy.c (now at line) line 429
>>
>> int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
>> {
>> [...]
>>         /* XXX: use EEPROM data here! */
>>
>>         err = ar9170_init_power_cal(ar);
>>         if (err)
>> [...]
>> }
>>
>> do you still know what EEPROM data is missing here? 
> 
> Sorry, no, I don't remember, and can't seem to find it either in otus
> right now.

Maybe this refers to the values in eepromBoardData initialized from the eeprom in otus/hal/hpmain.c, lines 522 ff.
and written into the registers in line 828?

I guess they should come from the modal_header[] in struct ar9170_eeprom, but I cannot map the 
offset in hpmain.c for hpPriv->eepromImage[] into the modal_header's members.

Regards,
Joerg


