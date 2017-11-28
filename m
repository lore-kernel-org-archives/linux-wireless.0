Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:41071 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753397AbdK1Uuw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 15:50:52 -0500
Message-ID: <1511902239.19952.47.camel@perches.com> (sfid-20171128_215055_890024_89DEE92D)
Subject: Re: drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c: Odd
 array size
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andrea Merello <andrea.merello@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 28 Nov 2017 12:50:39 -0800
In-Reply-To: <f2da30a1-0b42-ce8c-2054-47fa9ae3b4e5@lwfinger.net>
References: <1511887757.19952.38.camel@perches.com>
         <f2da30a1-0b42-ce8c-2054-47fa9ae3b4e5@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding the original submitter: Andrea Merello)

On Tue, 2017-11-28 at 14:39 -0600, Larry Finger wrote:
> On 11/28/2017 10:49 AM, Joe Perches wrote:
> > 61 entries in this table:
> > 
> > static const u8 OFDM_CONFIG[] = {
> > 	0x10, 0x0F, 0x0A, 0x0C, 0x14, 0xFA, 0xFF, 0x50,
> > 	0x00, 0x50, 0x00, 0x00, 0x00, 0x5C, 0x00, 0x00,
> > 	0x40, 0x00, 0x40, 0x00, 0x00, 0x00, 0xA8, 0x26,
> > 	0x32, 0x33, 0x06, 0xA5, 0x6F, 0x55, 0xC8, 0xBB,
> > 	0x0A, 0xE1, 0x2C, 0x4A, 0x86, 0x83, 0x34, 0x00,
> > 	0x4F, 0x24, 0x6F, 0xC2, 0x03, 0x40, 0x80, 0x00,
> > 	0xC0, 0xC1, 0x58, 0xF1, 0x00, 0xC4, 0x90, 0x3e,
> > 	0xD8, 0x3C, 0x7B, 0x10, 0x10
> > };
> > 
> > but only 60 written?
> > 
> > static void rtl8187se_write_ofdm_config(struct ieee80211_hw *dev)
> > {
> > 	/* write OFDM_CONFIG table */
> > 	int i;
> > 
> > 	for (i = 0; i < 60; i++)
> > 		rtl8225se_write_phy_ofdm(dev, i, OFDM_CONFIG[i]);
> > 
> > }
> > 
> > This is the only use of OFDM_CONFIG.
> > 
> > What is the defect here?
> > 
> > Should 60 be ARRAY_SIZE(OFDM_CONFIG) or should the array be shortened?
> > 
> > One too many entries or one too few a write?
> > My guess would be one too few a write.
> 
> Joe,
> 
> You are probably right; however, as I do not have this device and cannot test, 
> the safer thing would be to crop the array back to 60 entries. That way the 
> driver's behavior does not change.

I'd guess the safest change would be adding a comment
and not making a code change at all.

cheers, Joe
