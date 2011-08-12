Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57231 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1HLRaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 13:30:17 -0400
Date: Fri, 12 Aug 2011 13:17:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, Paul Stewart <pstew@google.com>
Subject: Re: [PATCH] ath9k_hw: Fix STA (AR9485) bringup issue due to
 incorrect MAC address
Message-ID: <20110812171734.GD2286@tuxdriver.com> (sfid-20110812_193021_000144_E73B0D64)
References: <1312914178-9601-1-git-send-email-senthilb@qca.qualcomm.com>
 <CAB=NE6Uzp4M9SNgti9hpob=Q49cJTwhuG5qnY3vgg9Mqjb-OCA@mail.gmail.com>
 <CAB=NE6W7LsHzTg_=MSEozKfXOiQt_Z7mB1pQ772m_FqsanTjVw@mail.gmail.com>
 <20110809184415.GB10104@senthil-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110809184415.GB10104@senthil-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 12:14:16AM +0530, Senthil Balasubramanian wrote:
> On Tue, Aug 09, 2011 at 11:32:17AM -0700, Luis R. Rodriguez wrote:
> > On Tue, Aug 9, 2011 at 11:31 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > > On Tue, Aug 9, 2011 at 11:22 AM, Senthil Balasubramanian
> > > <senthilb@qca.qualcomm.com> wrote:
> > >> Due to some recent optimization done in the way the mac address
> > >> bytes are written into the OTP memory, some AR9485 chipsets were
> > >> forced to use the first byte from the eeprom template and as AR9485
> > >> happens to use generic eeprom template which has 0x1 as the first
> > >> byte causes issues in bringing up the card.
> > >>
> > >> So fixed the eeprom template accordingly to address the issue.
> > >>
> > >> Cc: Paul Stewart <pstew@google.com>
> > >> Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> > >
> > > I don't follow the description too well, all I can tell from it is
> > > that there is an issue if the template has 0x01 set instead of 0x0 but
> > > it doesn't tell me why.
> The leading byte is 1 which is obviously incorrect for mac address.
> The reason why 1 is chosen by the driver for mac address is due to
> the way the OTP write was optimized and so the driver has taken the
> first byte alone from the template and the remaining from OTP.
> 
> > 
> > Is this not a stable fix?
> Oops.. Yes it is. Let me cc to stable. thanks for the stable reminder :-(

Are you goint to resubmit a patch w/ a better changelog and
Cc: stable@kernel.org?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
