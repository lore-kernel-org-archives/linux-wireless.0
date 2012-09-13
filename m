Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34315 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab2IMRzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 13:55:18 -0400
Message-ID: <50521E02.4030809@openwrt.org> (sfid-20120913_195524_808465_5A560369)
Date: Thu, 13 Sep 2012 19:55:14 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: OpenWrt Development List <openwrt-devel@lists.openwrt.org>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Sven Eckelmann <sven@narfation.org>,
	Adrian Chadd <adrian.chadd@gmail.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	Marek Lindner <lindner_marek@yahoo.de>
Subject: Re: [OpenWrt-Devel] AR9330 hornet board stops beaconing after a few
 days (0xdeadbeef)
References: <20120813165340.GA10044@pandem0nium> <CAD2nsn1=q_YCXjQOLyc+KeG6Bji=7b_VHN4PDA7poXk5Kkdi6Q@mail.gmail.com> <CAJ-VmonwheNtv8xfEJnWpD-XOmSEebMFJAmQmWUfe2Pd3tMnqA@mail.gmail.com> <168362233.PzT7LJrFi2@bentobox> <20120913165124.GA13877@pandem0nium>
In-Reply-To: <20120913165124.GA13877@pandem0nium>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-09-13 6:51 PM, Simon Wunderlich wrote:
> ath9k fellows,
> 
> as it seems no one could find the cause for this problem so far. I'd therefore
> like to create a workaround by checking one/some registers for 0xdeadbeef and
> reset the chip if this is found.
> 
> Can anyone recommend a register which should never go 0xdeadbeef in a normal case?
> 
> From what i've seen, AR_CFG (0x0014) might be a good choice. My regdumps say:
> 
> bad regdump:  0x000014 0xdeadbeef    
> good regdump: 0x000014 0x0008010a
> 
> Unfortunately I don't have documentation to find out if this register can ever
> go deadbeef in a normal case. :)
> 
> What do you think? (of course, a proper solution is still appreciated ...)
If ah->power_mode == ATH9K_PM_AWAKE, then no regularly used register may
return 0xdeadbeef. You can use a combination of the register and the
power mode as an indicator.

- Felix

