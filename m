Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7902 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1HISpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 14:45:50 -0400
Date: Wed, 10 Aug 2011 00:14:16 +0530
From: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH] ath9k_hw: Fix STA (AR9485) bringup issue due to
 incorrect MAC address
Message-ID: <20110809184415.GB10104@senthil-lnx.users.atheros.com> (sfid-20110809_204553_487831_B5F8B997)
References: <1312914178-9601-1-git-send-email-senthilb@qca.qualcomm.com>
 <CAB=NE6Uzp4M9SNgti9hpob=Q49cJTwhuG5qnY3vgg9Mqjb-OCA@mail.gmail.com>
 <CAB=NE6W7LsHzTg_=MSEozKfXOiQt_Z7mB1pQ772m_FqsanTjVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB=NE6W7LsHzTg_=MSEozKfXOiQt_Z7mB1pQ772m_FqsanTjVw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2011 at 11:32:17AM -0700, Luis R. Rodriguez wrote:
> On Tue, Aug 9, 2011 at 11:31 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Tue, Aug 9, 2011 at 11:22 AM, Senthil Balasubramanian
> > <senthilb@qca.qualcomm.com> wrote:
> >> Due to some recent optimization done in the way the mac address
> >> bytes are written into the OTP memory, some AR9485 chipsets were
> >> forced to use the first byte from the eeprom template and as AR9485
> >> happens to use generic eeprom template which has 0x1 as the first
> >> byte causes issues in bringing up the card.
> >>
> >> So fixed the eeprom template accordingly to address the issue.
> >>
> >> Cc: Paul Stewart <pstew@google.com>
> >> Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> >
> > I don't follow the description too well, all I can tell from it is
> > that there is an issue if the template has 0x01 set instead of 0x0 but
> > it doesn't tell me why.
The leading byte is 1 which is obviously incorrect for mac address.
The reason why 1 is chosen by the driver for mac address is due to
the way the OTP write was optimized and so the driver has taken the
first byte alone from the template and the remaining from OTP.

> 
> Is this not a stable fix?
Oops.. Yes it is. Let me cc to stable. thanks for the stable reminder :-(
> 
>   Luis
