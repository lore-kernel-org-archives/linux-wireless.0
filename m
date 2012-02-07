Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4417 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2BGPls (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 10:41:48 -0500
Subject: Re: [RFC 1/4] iwlwifi: dump stack when fail to gain access to the
 device
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20120207080122.GA2246@redhat.com>
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
	 <1328544496.14547.10.camel@wwguy-ubuntu> <20120207080122.GA2246@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 06:21:12 -0800
Message-ID: <1328624472.7290.51.camel@wwguy-huron> (sfid-20120207_164151_051956_0277046D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-07 at 09:01 +0100, Stanislaw Gruszka wrote:
> On Mon, Feb 06, 2012 at 08:08:16AM -0800, wwguy wrote:
> > On Mon, 2012-02-06 at 17:09 +0100, Stanislaw Gruszka wrote:
> > > Print dump stack when the device is not responding. This should give
> > > some more clue about the reason of failure. Also change the message we
> > > print, since "MAC in deep sleep" is kinda confusing.
> > > 
> > > On the way add unlikely(), as fail to gain NIC access is hmm ...
> > > unlikely.
> > > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > ---
> > >  drivers/net/wireless/iwlwifi/iwl-io.c |    6 +++---
> > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
> > > index 83fdff3..ce6d9c1 100644
> > > --- a/drivers/net/wireless/iwlwifi/iwl-io.c
> > > +++ b/drivers/net/wireless/iwlwifi/iwl-io.c
> > > @@ -120,10 +120,10 @@ int iwl_grab_nic_access_silent(struct iwl_bus *bus)
> > >  int iwl_grab_nic_access(struct iwl_bus *bus)
> > >  {
> > >  	int ret = iwl_grab_nic_access_silent(bus);
> > > -	if (ret) {
> > > +	if (unlikely(ret)) {
> > >  		u32 val = iwl_read32(bus, CSR_GP_CNTRL);
> > > -		IWL_ERR(bus,
> > > -			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
> > > +		WARN_ONCE(1, "Timeout waiting for ucode processor access "
> > > +			     "(CSR_GP_CNTRL 0x%08x)\n", val);
> > >  	}
> > >  
> > I agree the message and check make sense, but not sure what new clue we
> > got by doing this?
> 
> Calltrace with very first grab nic access failure.
> 
Good point, we have this "PCI bus disappear" problem on all of our
devices and very difficult to debug.

btw, do you have any system can reproduce this problem? we have nothing.

Thanks
Wey


