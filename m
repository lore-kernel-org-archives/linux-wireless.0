Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:3714 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab0FSRd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jun 2010 13:33:26 -0400
Subject: Re: [PATCH]: ath: Fix uninitialized variable warnings
From: Pavel Roskin <proski@gnu.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	ath9k-devel@atheros.com
In-Reply-To: <4C1AA4AF.8040306@redhat.com>
References: <20100527181052.23905.67123.sendpatchset@prarit.bos.redhat.com>
	 <20100528173431.GB2405@tuxdriver.com> <1275079476.18152.18.camel@mj>
	 <4C1AA4AF.8040306@redhat.com>
Content-Type: text/plain; charset="iso-8859-7"
Date: Sat, 19 Jun 2010 13:33:07 -0400
Message-Id: <1276968787.29943.0.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-17 at 18:41 -0400, Prarit Bhargava wrote:
...
> New linux-2.6 patch using Pavel's suggestion.
> 
> 
> Fix "make -j32 CONFIG_DEBUG_SECTION_MISMATCH=y" warning:
> 
> drivers/net/wireless/ath/ath9k/eeprom_9287.c: In function ¡ath9k_hw_get_AR9287_gain_boundaries_pdadcs¢:
> drivers/net/wireless/ath/ath9k/eeprom_9287.c:301: warning: ¡minPwrT4¢ may be used uninitialized in this function
> drivers/net/wireless/ath/ath9k/eeprom_4k.c: In function ¡ath9k_hw_get_4k_gain_boundaries_pdadcs.clone.1¢:
> drivers/net/wireless/ath/ath9k/eeprom_4k.c:310: warning: ¡minPwrT4¢ may be used uninitialized in this function
> drivers/net/wireless/ath/ath9k/eeprom_def.c: In function ¡ath9k_hw_get_def_gain_boundaries_pdadcs.clone.0¢:
> drivers/net/wireless/ath/ath9k/eeprom_def.c:677: warning: ¡minPwrT4¢ may be used uninitialized in this function
> 
> Remove tMinCalPower and the corresponding function arguments  as it is not
> used.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Acked-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
