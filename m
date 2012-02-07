Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab2BGIB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 03:01:29 -0500
Date: Tue, 7 Feb 2012 09:01:23 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/4] iwlwifi: dump stack when fail to gain access to the
 device
Message-ID: <20120207080122.GA2246@redhat.com> (sfid-20120207_090132_572365_07B7FB81)
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
 <1328544496.14547.10.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328544496.14547.10.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2012 at 08:08:16AM -0800, wwguy wrote:
> On Mon, 2012-02-06 at 17:09 +0100, Stanislaw Gruszka wrote:
> > Print dump stack when the device is not responding. This should give
> > some more clue about the reason of failure. Also change the message we
> > print, since "MAC in deep sleep" is kinda confusing.
> > 
> > On the way add unlikely(), as fail to gain NIC access is hmm ...
> > unlikely.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-io.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
> > index 83fdff3..ce6d9c1 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-io.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-io.c
> > @@ -120,10 +120,10 @@ int iwl_grab_nic_access_silent(struct iwl_bus *bus)
> >  int iwl_grab_nic_access(struct iwl_bus *bus)
> >  {
> >  	int ret = iwl_grab_nic_access_silent(bus);
> > -	if (ret) {
> > +	if (unlikely(ret)) {
> >  		u32 val = iwl_read32(bus, CSR_GP_CNTRL);
> > -		IWL_ERR(bus,
> > -			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
> > +		WARN_ONCE(1, "Timeout waiting for ucode processor access "
> > +			     "(CSR_GP_CNTRL 0x%08x)\n", val);
> >  	}
> >  
> I agree the message and check make sense, but not sure what new clue we
> got by doing this?

Calltrace with very first grab nic access failure.

Stanislaw
