Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:1577 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbYHYL5b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 07:57:31 -0400
Date: Mon, 25 Aug 2008 14:57:15 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: ath5k: bad udelay call, build failure on ARM
Message-ID: <20080825115715.GA13506@deprecation.cyrius.com> (sfid-20080825_135735_091143_E99A8630)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k fails to build on ARM with:

__bad_udelay is specifically designed on ARM to fail when udelay is
called in a bad way.  arch/arm/include/asm/delay.h has this to say
about __bad_udelay:

/*
 * This function intentionally does not exist; if you see references to
 * it, it means that you're calling udelay() with an out of range value.
 *
 * With currently imposed limits, this means that we support a max delay
 * of 2000us. Further limits: HZ<=1000 and bogomips<=3355
 */
extern void __bad_udelay(void);

Can you check why your driver is calling udelay() with a value > 2000?

-- 
Martin Michlmayr
http://www.cyrius.com/
