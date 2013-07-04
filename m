Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:59714 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab3GDSZE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 14:25:04 -0400
Date: Thu, 4 Jul 2013 20:27:46 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 4/5] rt2x00: rt2800lib: introduce
 rt2800_eeprom_word_index helper
Message-ID: <20130704182746.GA2061@localhost.localdomain> (sfid-20130704_202509_059350_E1D7A6D7)
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
 <1372269318-30233-5-git-send-email-juhosg@openwrt.org>
 <20130703192813.GD2245@localhost.localdomain>
 <51D4883E.2050607@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51D4883E.2050607@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Jul 03, 2013 at 10:23:26PM +0200, Gabor Juhos wrote:
> > I have two nit-picks, but they can be fixed later on top of your current
> > patches.
> > 
> >> +	if (WARN_ON(word >= EEPROM_WORD_COUNT)) {
> >> +		rt2x00_warn(rt2x00dev, "invalid EEPROM word %d\n", word);
> >> +		return 0;
> >> +	}
> > 
> > Since we take "enum rt2800_eeprom_word" as word argument, it can not
> > have different values than already listed, so this warning is not needed.
> 
> EEPROM_WORD_COUNT is listed in the enums and the word argument can be equal to
> that, however it is not a valid index for the EEPROM map. Additionally, if
> someone puts a new enum value after EEPROM_WORD_COUNT by mistake that will be an
> invalid index as well.

I do not feel that there is big chance that someone will do such
mistakes, but yes, they are at least theoretically possible, so warning
can stay.

> My reason behind the rt2x00_warn call was that it shows the wiphy name. If you
> are testing different devices in parallel it is good to know which one causes
> the warning. However I can use 'wiphy_name(rt2x00dev->hw->wiphy)' to get that
> information.
> 
> I will send a follow-up patch which removes the rt2x00_warn calls. Do you also
> prefer WARN_ONCE instead of WARN?

I prefer WARN_ONCE variant to avoid possible spamming dmesg with lot of
warnings.

Thanks
Stanislaw
