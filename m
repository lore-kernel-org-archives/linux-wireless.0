Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58423 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbbJCGod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 02:44:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8821ae: Fix system lockups on boot
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1443804270-3830-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Message-Id: <20151003064432.1B0BD13FA34@smtp.codeaurora.org> (sfid-20151003_084457_760240_A9440813)
Date: Sat,  3 Oct 2015 06:44:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In commit 1277fa2ab2f9 ("rtlwifi: Remove the clear interrupt routine from all
> drivers"), the code that cleared all interrupt enable bits before setting them
> was removed for all PCI drivers. This fixed an issue that caused TX to be
> blocked for 3-5 seconds. On some RTL8821AE units, this change causes soft
> lockups to occur on boot. For that reason, the portion of the earlier commit
> that applied to rtl8821ae is reverted. Kernels 4.1 and newer are affected.
> 
> See http://marc.info/?l=linux-wireless&m=144373370103285&w=2 and
> https://bugzilla.opensuse.org/show_bug.cgi?id=944978 for two cases where
> this regression affected user systems. Note that this bug does not appear on
> any of the developer's setups. For those users whose systems are affected
> by the TX blockage, but do not lock up on boot, a module parameter is added
> to disable the interrupt clear
> 
> Fixes: 1277fa2ab2f9 ("rtlwifi: Remove the clear interrupt routine from all drivers")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [V4.1+]

Thanks, applied to wireless-drivers.git.

Kalle Valo
