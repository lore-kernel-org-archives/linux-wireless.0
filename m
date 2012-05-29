Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab2E2MgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 08:36:15 -0400
Message-ID: <1338294968.4342.32.camel@jlt3.sipsolutions.net> (sfid-20120529_143618_289253_9F26EE39)
Subject: Re: [PATCH v2 09/22] ath9k: Handle fatal interrupts properly
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 14:36:08 +0200
In-Reply-To: <4FC4C12A.1050804@openwrt.org> (sfid-20120529_142944_112351_CE560AC4)
References: <20413.45797.72462.431840@gargle.gargle.HOWL>
	 <4FC4C12A.1050804@openwrt.org> (sfid-20120529_142944_112351_CE560AC4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-29 at 14:29 +0200, Felix Fietkau wrote:
> On 2012-05-24 6:02 AM, Sujith Manoharan wrote:
> > When a fatal interrupt is received or it is detected that the baseband
> > has hung, the chip has to be reset immediately.  Otherwise, we end up
> > processing spurious interrupts. Ensure that we bail out properly in
> > the ISR when the reset work hasn't completed yet.
> > 
> > Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Wouldn't it be much easier to just use a bool variable instead of the
> combination of lock+flag? A simple variable assignment is atomic...

Is that guaranteed for bool variables?

johannes

