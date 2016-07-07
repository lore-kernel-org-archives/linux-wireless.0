Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39972 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbcGGTiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2016 15:38:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-kernel@vger.kernel.org,
	Doug Anderson <dianders@chromium.org>,
	Brian Norris <computersforpeace@gmail.com>,
	Stephen Barber <smbarber@chromium.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	wnhuang@chromium.org
Subject: Re: [PATCH] mwifiex: mask PCIe interrupts before removal
References: <1467325262-82799-1-git-send-email-briannorris@chromium.org>
	<20160707181652.GA70075@google.com>
Date: Thu, 07 Jul 2016 22:37:59 +0300
In-Reply-To: <20160707181652.GA70075@google.com> (Brian Norris's message of
	"Thu, 7 Jul 2016 11:16:53 -0700")
Message-ID: <877fcxck88.fsf@purkki.adurom.net> (sfid-20160707_213837_260435_5DBE3A63)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> Hi,
>
> On Thu, Jun 30, 2016 at 03:21:02PM -0700, Brian Norris wrote:
>> The PCIe driver didn't mask the host interrupts before trying to tear
>> down. This causes lockups at reboot or rmmod when using MSI-X on 8997,
>> since the MSI handler gets confused and locks up the system.
>> 
>> Also tested on 8897, which does not support MSI-X (and wasn't
>> experiencing this same bug). No regressions seen there.
>
> Ping? This is a bugfix, and it'd be nice to either know what's wrong
> with it, or see it merged.

It's on my queue for 4.8:

https://patchwork.kernel.org/patch/9209027/

-- 
Kalle Valo
