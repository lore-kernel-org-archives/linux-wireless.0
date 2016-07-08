Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57491 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbcGHNsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 09:48:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: mask PCIe interrupts before removal
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467325262-82799-1-git-send-email-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	<linux-kernel@vger.kernel.org>,
	Doug Anderson <dianders@chromium.org>,
	Brian Norris <computersforpeace@gmail.com>,
	Stephen Barber <smbarber@chromium.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Brian Norris <briannorris@chromium.org>
Message-Id: <20160708134842.0AA02611CB@smtp.codeaurora.org> (sfid-20160708_154904_333264_4AF3EC57)
Date: Fri,  8 Jul 2016 13:48:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> The PCIe driver didn't mask the host interrupts before trying to tear
> down. This causes lockups at reboot or rmmod when using MSI-X on 8997,
> since the MSI handler gets confused and locks up the system.
> 
> Also tested on 8897, which does not support MSI-X (and wasn't
> experiencing this same bug). No regressions seen there.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Tested-by: Douglas Anderson <dianders@chromium.org>

Thanks, 1 patch applied to wireless-drivers-next.git:

d41376ca8ba7 mwifiex: mask PCIe interrupts before removal

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9209027/

