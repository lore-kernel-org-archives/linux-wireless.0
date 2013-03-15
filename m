Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34736 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab3COWVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 18:21:52 -0400
Message-ID: <51439EF6.8000605@openwrt.org> (sfid-20130315_232156_894392_1BDBF993)
Date: Fri, 15 Mar 2013 23:21:42 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Wojciech.Dubowik@neratec.com, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.9] ath9k_hw: revert chainmask to user configuration
 after calibration
References: <1363355611-10426-1-git-send-email-nbd@openwrt.org> <20130315183433.GA2676@bombadil.infradead.org>
In-Reply-To: <20130315183433.GA2676@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-15 7:34 PM, Luis R. Rodriguez wrote:
> On Fri, Mar 15, 2013 at 02:53:31PM +0100, Felix Fietkau wrote:
>> The commit 'ath9k_hw: fix calibration issues on chainmask that don't
>> include chain 0' changed the hardware chainmask to the chip chainmask
>> for the duration of the calibration, but the revert to user
>> configuration in the reset path runs too early.
>> 
>> That causes some issues with limiting the number of antennas (including
>> spurious failure in hardware-generated packets).
>> 
>> Fix this by reverting the chainmask after the essential parts of the
>> calibration that need the workaround, and before NF calibration is run.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Reported-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
>> Tested-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
>> Cc: stable@vger.kernel.org
> 
> This applies to v3.8 as well with the following changes, do you want
> it there as well?
Yes

