Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33320 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaBNPey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 10:34:54 -0500
Message-ID: <52FE3791.8020104@openwrt.org> (sfid-20140214_163457_377491_E7FD00B5)
Date: Fri, 14 Feb 2014 16:34:41 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: Fix ETSI compliance for AR9462 2.0
References: <1392345920-28891-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1392345920-28891-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-14 03:45, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> The minimum CCA power threshold values have to be adjusted
> for existing cards to be in compliance with new regulations.
> Newer cards will make use of the values obtained from EEPROM,
> support for this was added earlier. To make sure that cards
> that are already in use and don't have proper values in EEPROM,
> do not violate regulations, use the initvals instead.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Jeang Daniel <dyjeong@qca.qualcomm.com>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Wouldn't it be better to do this for all AR93xx chipsets in
ar9003_hw_apply_minccapwr_thresh instead of initvals?
I'm pretty sure this patch will leave most other devices non-compliant.

- Felix
