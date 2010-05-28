Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59949 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab0E1Uoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 16:44:38 -0400
Subject: Re: [PATCH]: ath: Fix uninitialized variable warnings
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Prarit Bhargava <prarit@redhat.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@atheros.com
In-Reply-To: <20100528173431.GB2405@tuxdriver.com>
References: <20100527181052.23905.67123.sendpatchset@prarit.bos.redhat.com>
	 <20100528173431.GB2405@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 16:44:36 -0400
Message-Id: <1275079476.18152.18.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 13:34 -0400, John W. Linville wrote:
> On Thu, May 27, 2010 at 02:14:54PM -0400, Prarit Bhargava wrote:
> > Fixes 'make -j24 CONFIG_DEBUG_SECTION_MISMATCH=y' warning:
> > 
> > drivers/net/wireless/ath/ath9k/eeprom_4k.c: In function ‘ath9k_hw_get_4k_gain_boundaries_pdadcs.clone.1’:
> > drivers/net/wireless/ath/ath9k/eeprom_4k.c:311: error: ‘minPwrT4’ may be used uninitialized in this function
> > drivers/net/wireless/ath/ath9k/eeprom_9287.c: In function ‘ath9k_hw_get_AR9287_gain_boundaries_pdadcs’:
> > drivers/net/wireless/ath/ath9k/eeprom_9287.c:302: error: ‘minPwrT4’ may be used uninitialized in this function
> > drivers/net/wireless/ath/ath9k/eeprom_def.c: In function ‘ath9k_hw_get_def_gain_boundaries_pdadcs.clone.0’:
> > drivers/net/wireless/ath/ath9k/eeprom_def.c:679: error: ‘minPwrT4’ may be used uninitialized in this function
> > 
> > Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> It looks to me like minPwrT4 will get initialized as long as
> numXpdGains is non-zero in all cases.  Anyone know if this is true?

It's calculated based on a value from EEPROM (xpdMask).  If xpdMask is
0, numXpdGain would be 0.  So bogus EEPROM can lead to bogus
tMinCalPower.  But the good thing is that tMinCalPower is never used.

So let's just eliminate tMinCalPower in all three files, as well as the
corresponding function arguments.

-- 
Regards,
Pavel Roskin
