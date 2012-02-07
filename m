Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14793 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab2BGP2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 10:28:14 -0500
Subject: Re: [RFC 2/4] iwlwifi: always check if got h/w access before write
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20120207080552.GB2246@redhat.com>
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
	 <1328544564-8696-2-git-send-email-sgruszka@redhat.com>
	 <1328544791.14547.12.camel@wwguy-ubuntu> <20120207080552.GB2246@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 06:20:01 -0800
Message-ID: <1328624401.7290.49.camel@wwguy-huron> (sfid-20120207_162821_412150_1CA1F3BD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-07 at 09:05 +0100, Stanislaw Gruszka wrote:
> On Mon, Feb 06, 2012 at 08:13:11AM -0800, wwguy wrote:
> > On Mon, 2012-02-06 at 17:09 +0100, Stanislaw Gruszka wrote:
> > > @@ -117,16 +117,17 @@ int iwl_grab_nic_access_silent(struct iwl_bus *bus)
> > >  	return 0;
> > >  }
> > >  
> > > -int iwl_grab_nic_access(struct iwl_bus *bus)
> > > +bool iwl_grab_nic_access(struct iwl_bus *bus)
> > >  {
> > >  	int ret = iwl_grab_nic_access_silent(bus);
> > >  	if (unlikely(ret)) {
> > >  		u32 val = iwl_read32(bus, CSR_GP_CNTRL);
> > >  		WARN_ONCE(1, "Timeout waiting for ucode processor access "
> > >  			     "(CSR_GP_CNTRL 0x%08x)\n", val);
> > > +		return false;
> > >  	}
> > >  
> > > -	return ret;
> > > +	return true;
> > >  }
> > >  u32 iwl_read_direct32(struct iwl_bus *bus, u32 reg);
> > > diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > > index 965d047..218071a 100644
> > > --- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > > +++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > > @@ -443,7 +443,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
> > >  	if (iwlagn_hw_valid_rtc_data_addr(base)) {
> > >  		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
> > >  		ret = iwl_grab_nic_access_silent(bus(priv));
> > > -		if (ret == 0) {
> > > +		if (likely(ret == 0)) {
> > 
> > you change the return to bool, right, but "ret" is "int"
> 
> I only changed iwl_grab_nic_access(),
> iwl_grab_nic_access_silent() still returns int.
> 
you are correct, I miss that

Wey


