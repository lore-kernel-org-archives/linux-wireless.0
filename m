Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:44741 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753368AbeAIWBc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 17:01:32 -0500
Received: by mail-pg0-f49.google.com with SMTP id i5so8924022pgq.11
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jan 2018 14:01:32 -0800 (PST)
Date: Tue, 9 Jan 2018 14:01:29 -0800
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxm@marvell.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: Re: [PATCH] mwifiex: cancel pcie/sdio work in remove/shutdown
 handler
Message-ID: <20180109220128.GA148512@google.com> (sfid-20180109_230139_562497_C882F8A3)
References: <120235b5b7fb4b2286a32dcca2a3878a@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <120235b5b7fb4b2286a32dcca2a3878a@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Christopher

Hi Simon and Kalle,

On Tue, Jan 09, 2018 at 11:42:21AM +0000, Xinming Hu wrote:
> Hi,
> 
> > -----Original Message-----
> > From: Kalle Valo [mailto:kvalo@codeaurora.org]
> > Sent: 2018年1月9日 15:40
> > To: Brian Norris <briannorris@chromium.org>
> > Cc: Xinming Hu <huxm@marvell.com>; Linux Wireless
> > <linux-wireless@vger.kernel.org>; Dmitry Torokhov <dtor@google.com>;
> > rajatja@google.com; Zhiyuan Yang <yangzy@marvell.com>; Tim Song
> > <songtao@marvell.com>; Cathy Luo <cluo@marvell.com>; James Cao
> > <jcao@marvell.com>; Ganapathi Bhat <gbhat@marvell.com>; Ellie Reeves
> > <ellierevves@gmail.com>
> > Subject: [EXT] Re: [PATCH] mwifiex: cancel pcie/sdio work in remove/shutdown
> > handler
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > Brian Norris <briannorris@chromium.org> writes:
> > 
> > >> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > >> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > >> @@ -310,6 +310,8 @@ static void mwifiex_pcie_remove(struct pci_dev
> > *pdev)
> > >>  		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
> > >>  	}
> > >>
> > >> +	cancel_work_sync(&card->work);
> > >> +
> > >
> > > Just FYI, this "fix" is not a real fix. It will likely paper over some
> > > of your bugs (where, e.g., the FW shutdown command times out in the
> > > previous couple of lines), but this highlights the fact that there are
> > > other races that could trigger the same behavior. You're not fixing
> > > those.
> > >
> > > For example, what if somebody initiates a scan or other nl80211
> > > command between the above line and mwifiex_remove_card()? That
> > command
> > > could potentially time out too.
> > >
> 
> The hardware status have been reset before downloading the last
> command(FUNC SHUTDOWN), in this way, follow commands  download will be
> ignored and warned.

Hmm, I suppose that's true. So the race I'm talking about probably can't
happen usually. What about in manufacturing mode or !FIRMWARE_READY_PCIE
though? Those cases don't shut down the firmware. Can we still have
outstanding timeouts in those cases?

Anyway, I still think there's a problem though, and this patch is just
going to make things worse. See below.

> > > The proper fix would be to institute some kind of mutual exclusion
> > > (locking) between mwifiex_shutdown_sw() and mwifiex_remove_card(), so
> > > that they can't occur at the same time.
> > >
> 
> I am not sure whether there is any mutual exclusion protect between pcie_reset and pcie_remove in pcie core.
> But it looks a different race.
> We still need this fix, right?

Good point. Previously, there wasn't any such exclusion, and that's why
races like the above were even more likely. But as of 4.13, now there
*is* exclusion. See commit b014e96d1abb ("PCI: Protect
pci_error_handlers->reset_notify() usage with device_lock()"). That
incidentally means that you're creating a deadlock with this patch! [1]

If we start a timeout/reset sequence in mwifiex_init_shutdown_fw()
(called from remove()), then you'll eventually have pci_reset_function()
waiting on the device lock, but mwifiex_pcie_remove() will be holding
the device lock already, and now (with your patch), remove() will be
waiting on the worker thread to finish pci_reset_function()...deadlock!

I actually think that the above patch (adding device_lock()) resolves
most of the race but introduces a possible deadlock. I believe an easy
solution is just to switch to pci_try_reset_function() instead? That
will just abort a reset attempt if we're in the middle of removing the
device. Problem solved? Diff appended, but I'll send out a real version
if that looks right. Can you test your original problem with the above
commit from Christopher, as well as the appended diff?

> Regards,
> Simon
> > > Unfortunately, I only paid attention to this after Kalle already
> > > applied this patch. Personally, I'd prefer this patch not get applied,
> > > since it's a bad solution to an obvious problem, which instead leaves
> > > a subtle problem that perhaps no one will bother fixing.
> > 
> > I can revert it, that's not a problem. Can I use the text below as explanation for
> > the revert?
> > 
> > ----------------------------------------------------------------------
> > Brian Norris <briannorris@chromium.org> says:
> > 
> > Just FYI, this "fix" is not a real fix. It will likely paper over some of your bugs
> > (where, e.g., the FW shutdown command times out in the previous couple of
> > lines), but this highlights the fact that there are other races that could trigger
> > the same behavior. You're not fixing those.
> > 
> > For example, what if somebody initiates a scan or other nl80211 command
> > between the above line and mwifiex_remove_card()? That command could
> > potentially time out too.
> > 
> > The proper fix would be to institute some kind of mutual exclusion
> > (locking) between mwifiex_shutdown_sw() and mwifiex_remove_card(), so that
> > they can't occur at the same time.
> > 
> > ----------------------------------------------------------------------

Hi Kalle, thanks for the above. With the new information from above, I
think that there's a more accurate description, like the following:

---
Brian Norris <briannorris@chromium.org> says:

The "fix" in question might not actually fix all related problems,
and it also looks like it can cause a deadlock. Since commit
b014e96d1abb ("PCI: Protect pci_error_handlers->reset_notify() usage
with device_lock()"), the race in question is actually resolved (PCIe
reset cannot happen at the same time as remove()). Instead, this "fix"
just introduces a deadlock where mwifiex_pcie_card_reset_work() is
waiting on device_lock, which is held by PCIe device remove(), which is
waiting on...mwifiex_pcie_card_reset_work().

The proper thing to do is just to fix the deadlock. Patch for this will
come separately.
---

Brian

[1] Technically, the deadlock is already there, since
mwifiex_remove_card() eventually calls pcie.c's ->cleanup_if(), which
also calls cancel_work_sync(). But your patch doesn't help...

Untested diff:

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index cd314946452c..5da3d6ccf5f2 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2781,7 +2781,7 @@ static void mwifiex_pcie_card_reset_work(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 
-	pci_reset_function(card->dev);
+	pci_try_reset_function(card->dev);
 }
 
 static void mwifiex_pcie_work(struct work_struct *work)
