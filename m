Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:53440 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbXIOSGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 14:06:36 -0400
Message-ID: <46EC1F5A.7030800@lwfinger.net>
Date: Sat, 15 Sep 2007 13:07:22 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix machine check errors for PPC architecture  with BCM4306/2
References: <46ec18d6.puwbD1oRuPgUil6/%Larry.Finger@lwfinger.net> <200709151948.46667.mb@bu3sch.de>
In-Reply-To: <200709151948.46667.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 15 September 2007 19:39:34 Larry Finger wrote:
>> In b43, the variable gmode merely indicates whether the given core
>> has a GPHY or a BPHY. In b43legacy, this is always true; however,
>> on a BCM4306/2 it must be set only when the PHY is connected to the
>> ssb backplane, otherwise, reads of the PHY registers are invalid.
>> For x86 architecture, these read failures cause no problems; however,
>> on the ppc architecture, they cause a machine check. This patch has been
>> tested on an i386 platform using special code to detect these invalid
>> reads, and on two different Powerbooks.
>>  
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> John,
>>
>> This patch fixes a problem with the Fedora Rawhide kernel reported by David
>> Woodhouse on the bcm43xx mailing list and by Will Woods at 
>> https://bugzilla.redhat.com/show_bug.cgi?id=233011.
>>
>> Larry
>>
>>  drivers/net/wireless/b43legacy/main.c |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
>> ===================================================================
>> --- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
>> +++ wireless-dev/drivers/net/wireless/b43legacy/main.c
>> @@ -738,8 +738,11 @@ void b43legacy_wireless_core_reset(struc
>>  
>>  	macctl = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
>>  	macctl &= ~B43legacy_MACCTL_GMODE;
>> -	if (flags & B43legacy_TMSLOW_GMODE)
>> +	if (flags & B43legacy_TMSLOW_GMODE) {
>>  		macctl |= B43legacy_MACCTL_GMODE;
>> +		dev->phy.gmode = 1;
>> +	} else
>> +		dev->phy.gmode = 0;
>>  	macctl |= B43legacy_MACCTL_IHR_ENABLED;
>>  	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
>>  }
>> @@ -3424,7 +3427,6 @@ static int b43legacy_wireless_core_attac
>>  	int err;
>>  	int have_bphy = 0;
>>  	int have_gphy = 0;
>> -	u32 tmp;
>>  
>>  	/* Do NOT do any device initialization here.
>>  	 * Do it in wireless_core_init() instead.
>> @@ -3456,9 +3458,7 @@ static int b43legacy_wireless_core_attac
>>  	if (err)
>>  		goto err_powerdown;
>>  
>> -	dev->phy.gmode = (have_gphy || have_bphy);
>> -	tmp = dev->phy.gmode ? B43legacy_TMSLOW_GMODE : 0;
>> -	b43legacy_wireless_core_reset(dev, tmp);
>> +	b43legacy_wireless_core_reset(dev, B43legacy_TMSLOW_GMODE);
>>  
>>  	err = b43legacy_phy_versioning(dev);
>>  	if (err)
>> @@ -3482,9 +3482,7 @@ static int b43legacy_wireless_core_attac
>>  			B43legacy_BUG_ON(1);
>>  		}
>>  	}
>> -	dev->phy.gmode = (have_gphy || have_bphy);
>> -	tmp = dev->phy.gmode ? B43legacy_TMSLOW_GMODE : 0;
>> -	b43legacy_wireless_core_reset(dev, tmp);
>> +	b43legacy_wireless_core_reset(dev, B43legacy_TMSLOW_GMODE);
>>  
>>  	err = b43legacy_validate_chipaccess(dev);
>>  	if (err)
>> Index: wireless-dev/drivers/net/wireless/b43legacy/b43legacy.h
>> ===================================================================
>> --- wireless-dev.orig/drivers/net/wireless/b43legacy/b43legacy.h
>> +++ wireless-dev/drivers/net/wireless/b43legacy/b43legacy.h
>> @@ -389,7 +389,7 @@ struct b43legacy_lopair {
>>  struct b43legacy_phy {
>>  	/* Possible PHYMODEs on this PHY */
>>  	u8 possible_phymodes;
>> -	/* GMODE bit enabled? */
>> +	/* True if PHY connected to ssb backplane */
>>  	bool gmode;
> 
> Nono, wait. That "PHY Connected" bit never existed. It was a bug
> in the specification. It really is "Drive the PHY in G-mode".
> It has nothing to do with "connecting" something.
> So your changes above are, strictly said, also wrong.
> The bit must be enabled, if we want to use the G-mode PHY on the
> device and disabled otherwise. This is for multi-phy devices with
> an A PHY and a B/G PHY.
> So, well. As you won't ever support an A-PHY in the driver, I am
> probably OK with always forcing the GMODE bit on (which your above code does,
> but I don't see how this could fix anything). Better, yet, fix the _real_
> cause why gmode wasn't set (that's what you are trying to fix, no?)
> And please don't break the comment above. :)
> It _really_ is a "GMODE bit enabled" bit.
> 
> Again: This has nothing to do with connecting some PHY to anything.

Your comments may be correct; however, the fact remains that with a rev 4 BCM4306, the original code
generates many, many machine checks on PPC architecture, and I get reads with all ones on i386
indicating that the read is invalid. These all occur before the firmware is loaded. Making the
"gmode" bit mimic the behavior of the phy_connected variable of bcm43xx gets rid of the problems on
both platforms. The registers that error are not just the extended GPHY registers that caused
problems in the past, but all the PHY registers.

If you can suggest a reordering of the initialization that delays PHY setup until the "magic step"
that eliminates this problem is done on/to the ssb backplane, I will be happy to test it. I was
unable to find such a solution.

Larry

