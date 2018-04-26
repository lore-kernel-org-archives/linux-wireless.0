Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41690 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753007AbeDZHq3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 03:46:29 -0400
Message-ID: <c3cc162f1980fa56838a78e2b171e8165afc6321.camel@coelho.fi> (sfid-20180426_094633_325983_9862077C)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Rajat Jain <rajatja@google.com>
Date: Thu, 26 Apr 2018 10:46:25 +0300
In-Reply-To: <87efj3af5t.fsf@kamboji.qca.qualcomm.com>
References: <20180422082745.9743-1-luca@coelho.fi>
         <20180422082745.9743-10-luca@coelho.fi> <87h8o1os5b.fsf@codeaurora.org>
         <a768684127fb8e5f3c62bb62ec80e52950314787.camel@coelho.fi>
         <87efj3af5t.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 09/12] iwlwifi: pcie: remove non-responsive device
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-04-25 at 11:01 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > On Tue, 2018-04-24 at 12:44 +0300, Kalle Valo wrote:
> > > Luca Coelho <luca@coelho.fi> writes:
> > > 
> > > > From: Luca Coelho <luciano.coelho@intel.com>
> > > > 
> > > > If we fail to to grab NIC access because the device is not
> > > > responding
> > > > (i.e. CSR_GP_CNTRL returns 0xFFFFFFFF), remove the device from
> > > > the
> > > > PCI
> > > > bus, to avoid any further damage, and to let the user space
> > > > rescan.
> > > > 
> > > > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > > > Signed-off-by: Rajat Jain <rajatja@google.com>
> > > 
> > > The commit log doesn't mention anything about the module
> > > parameter
> > > nor
> > > about the kobject uevent.
> > 
> > Good point.  The uevent and the module parameter were added in
> > later
> > patches and I squashed them all into this one, but forgot to update
> > the
> > commit message.  I'll fix it.
> 
> Good, thanks.
> 
> > > > +static void iwl_trans_pcie_removal_wk(struct work_struct *wk)
> > > > +{
> > > > +	struct iwl_trans_pcie_removal *removal =
> > > > +		container_of(wk, struct
> > > > iwl_trans_pcie_removal,
> > > > work);
> > > > +	struct pci_dev *pdev = removal->pdev;
> > > > +	char *prop[] = {"EVENT=INACCESSIBLE", NULL};
> > > > +
> > > > +	dev_err(&pdev->dev, "Device gone - attempting
> > > > removal\n");
> > > > +	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE,
> > > > prop);
> > > > +	pci_lock_rescan_remove();
> > > > +	pci_dev_put(pdev);
> > > > +	pci_stop_and_remove_bus_device(pdev);
> > > > +	pci_unlock_rescan_remove();
> > > > +
> > > > +	kfree(removal);
> > > > +	module_put(THIS_MODULE);
> > > > +}
> > > 
> > > So is the uevent some standard thing or what? At least grepping
> > > INACCESSIBLE for didn't tell me anything.
> > 
> > No, this is not standard.  We didn't find any appropriate standard
> > message for this case, so we created a new one.  Also, we didn't
> > want
> > to interfere with components that may react to standard messages.
> > 
> > This is disabled by default and the idea is to change this in the
> > future to allow the driver to remove and rescan the device
> > automatically.  So we will have 3 options in the module parameter:
> > do
> > nothing; auto-rescan or; send uevent.
> 
> Ok, I assume you will explain this in the commit log.

Yes, I'll improve the commit message.


> In my opinion the driver should not be sending custom events like
> this
> and instead pci_stop_and_remove_bus_device() should do it, but maybe
> that's just me?

pci_stop_and_remove_bus_device() will already trigger some events, like
"REMOVED" or something like that.  But the semantics is a little bit
different.  If the device was removed, you don't usually want to rescan
the bus, because the device will not be there anymore.  In our case,
the device *is* there, but got stuck and we want to rescan to get it
back.

--
Cheers,
Luca.
