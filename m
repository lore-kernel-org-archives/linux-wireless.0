Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37774 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701Ab2HHPM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 11:12:27 -0400
Message-ID: <502281D9.4030109@openwrt.org> (sfid-20120808_171231_321476_4DC52695)
Date: Wed, 08 Aug 2012 17:12:25 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 3.6 4/4] ath9k_hw: enable PA linearization
References: <1344344772-49459-1-git-send-email-nbd@openwrt.org> <1344344772-49459-2-git-send-email-nbd@openwrt.org> <1344344772-49459-3-git-send-email-nbd@openwrt.org> <1344344772-49459-4-git-send-email-nbd@openwrt.org> <20120808145531.GB2041@vmraj-lnx.qualcomm.com>
In-Reply-To: <20120808145531.GB2041@vmraj-lnx.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-08 4:55 PM, Rajkumar Manoharan wrote:
> On Tue, Aug 07, 2012 at 03:06:12PM +0200, Felix Fietkau wrote:
>> This feature had been disabled in ath9k because the code to support
>> it was incomplete, but now the code is in sync with the internal QCA
>> codebase, so it's time to enable it.
>> 
>> On many newer devices, the calibration is assumed to be done with PA
>> linearization enabled.
>> 
>> Tests with a particular AR933x device showed that the signal emitted
>> at full power was highly distorted and unreliable with PA linearization
>> disabled. With this patch, the signal becomes clear and stability
>> is improved.
>> 
> We faced stability issues with 938x chipsets when paprd is enabled. The commit
> 6f4810101a629b31b5427872a09ea092cfc5c4bd states one of the issue. Even if it
> helps for AR933x, let us enable it only for that chip alone.
That was in January 2011, lots of bugs have been fixed since then,
initvals have been updated, EEPROM code has changed, ...

The internal QCA codebase enables PAPRD for all AR93xx devices that
support it, meaning non-PAPRD tx receives much less test coverage there.

While this issue has only been visible on a particular AR933x device, I
believe this is not the only one that's going to be affected, as the
EEPROM of any new device is calibrated for PAPRD-enabled operation.

If you don't want to enable it now, when do you think would be the right
time to enable it? Before I sent this patch, I did a detailed code
review to make sure that any obvious code discrepancies in PAPRD between
the internal codebase and ath9k are dealt with.

What else is needed to get this issue sorted out?

- Felix
