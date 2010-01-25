Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36646 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab0AYEL2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 23:11:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 20:11:28 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19293.7697.450587.108278@gargle.gargle.HOWL>
Date: Mon, 25 Jan 2010 09:59:05 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"jorge@dti2.net" <jorge@dti2.net>, Pavel Roskin <proski@gnu.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix eeprom INI values override for 2GHz-only cards
In-Reply-To: <4B5B4832.2020800@openwrt.org>
References: <4B5B4832.2020800@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Among other changes, this commit:
> 
>    commit 06d0f0663e11cab4ec5f2c143a118d71a12fbbe9
>    Author: Sujith <Sujith.Manoharan@atheros.com>
>    Date:   Thu Feb 12 10:06:45 2009 +0530
> 
>    ath9k: Enable Fractional N mode
> 
> changed the hw attach code to fix up initialization values only for
> dual band devices, however the commit message did not give a reason as
> to why this would be useful or necessary.
> 
> According to tests by Jorge Boncompte, this breaks at least some
> 2GHz-only cards, so the code should be changed back to the
> unconditional INI fixup.

The original fix was a workaround for MB-92 cards, which certainly
was applicable to both single/dual band cards.

During a sync-up with internal HW-specific code changes, this was
changed to 11A specific. Not sure why this was done so.
Will look into this.

Sujith
