Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44559 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293Ab0E1RpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 13:45:11 -0400
Date: Fri, 28 May 2010 13:34:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@atheros.com
Subject: Re: [PATCH]: ath: Fix uninitialized variable warnings
Message-ID: <20100528173431.GB2405@tuxdriver.com>
References: <20100527181052.23905.67123.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20100527181052.23905.67123.sendpatchset@prarit.bos.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 27, 2010 at 02:14:54PM -0400, Prarit Bhargava wrote:
> Fixes 'make -j24 CONFIG_DEBUG_SECTION_MISMATCH=y' warning:
> 
> drivers/net/wireless/ath/ath9k/eeprom_4k.c: In function ‘ath9k_hw_get_4k_gain_boundaries_pdadcs.clone.1’:
> drivers/net/wireless/ath/ath9k/eeprom_4k.c:311: error: ‘minPwrT4’ may be used uninitialized in this function
> drivers/net/wireless/ath/ath9k/eeprom_9287.c: In function ‘ath9k_hw_get_AR9287_gain_boundaries_pdadcs’:
> drivers/net/wireless/ath/ath9k/eeprom_9287.c:302: error: ‘minPwrT4’ may be used uninitialized in this function
> drivers/net/wireless/ath/ath9k/eeprom_def.c: In function ‘ath9k_hw_get_def_gain_boundaries_pdadcs.clone.0’:
> drivers/net/wireless/ath/ath9k/eeprom_def.c:679: error: ‘minPwrT4’ may be used uninitialized in this function
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

It looks to me like minPwrT4 will get initialized as long as
numXpdGains is non-zero in all cases.  Anyone know if this is true?

It's probably not a big deal, but better to avoid an unnecessary
memset if we can.  Maybe unitialized_var is the better choice?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
