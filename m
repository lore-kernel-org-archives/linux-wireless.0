Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34623 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaBQCqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 21:46:19 -0500
Message-ID: <530177EF.3030000@openwrt.org> (sfid-20140217_034623_440705_F864B8BA)
Date: Mon, 17 Feb 2014 03:46:07 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: Fix ETSI compliance for AR9462 2.0
References: <1392345920-28891-1-git-send-email-sujith@msujith.org>	<52FE3791.8020104@openwrt.org> <21249.29605.11000.880663@gargle.gargle.HOWL>
In-Reply-To: <21249.29605.11000.880663@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-17 03:27, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Wouldn't it be better to do this for all AR93xx chipsets in
>> ar9003_hw_apply_minccapwr_thresh instead of initvals?
>> I'm pretty sure this patch will leave most other devices non-compliant.
> 
> The threshold values are adjusted for each chip and are not the same
> for all chips in the AR9003 family, so this is done in the initvals.
Almost all chips are using the same values in the initvals - the
exceptions seem to be the ones that have had ETSI compliance fix
attempts already. I'm pretty sure the new values (if adjusted for
different bands) would be fully compatible.

> ar9003_hw_apply_minccapwr_thresh() will be used only for chips which
> contain the new 'MinCCApwr' field in struct ar9300_BaseExtension_1.
> This is not present in almost all the AR9003-family chips. I believe it has
> been introduced in AR955x.
I know. What I meant is that in case the EEPROM does not have any
values, we can make it use reasonable fixed defaults, thus overriding
the values from the initvals.

- Felix
