Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34093
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbXIVMN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2007 08:13:56 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: Please pull 'z1211' branch of wireless-2.6
Date: Sat, 22 Sep 2007 14:11:11 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>, davem@davemloft.net,
	jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20070919181005.GB5483@tuxdriver.com> <20070920134730.GC6748@tuxdriver.com> <20070922094800.GB12327@deine-taler.de>
In-Reply-To: <20070922094800.GB12327@deine-taler.de>
MIME-Version: 1.0
Message-Id: <200709221411.12128.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 September 2007 11:48:00 Ulrich Kunitz wrote:
> A real high-quality driver will require Johannes' proposed
> mac80211 driver interface changes to be merged and TX
> confirmations handled in a way, that the semantics can really be
> supported by the driver. (Michael Buesh's patch is taping over the
> issue.)

No it is not. It is fixing the issue. It fixes the following issues:
* You must ignore the Txstat-requested bit in the driver.
* You must report bad frames with the excessive_retries set.

The issue you are (most likely) talking about is that we can not
reliably tell whether a frame was good in the driver. That is a different
issue completely seperate from the two points above, which my patch fixes.

With my patch rate-controlling correctly works. Without it does not.

If you find a way to fix the reliable-detection-of-good-TX issue, that's
another good fix. But I think it's not release critical, because the
device works with the current "guessing-around" code. But without the two
points above fixed, it does not correctly work at all (unless you manually
tune to the best rate each time you move the machine).

-- 
Greetings Michael.
