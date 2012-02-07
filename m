Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2BGIFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 03:05:55 -0500
Date: Tue, 7 Feb 2012 09:05:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/4] iwlwifi: always check if got h/w access before write
Message-ID: <20120207080552.GB2246@redhat.com> (sfid-20120207_090558_947833_16F53A11)
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
 <1328544564-8696-2-git-send-email-sgruszka@redhat.com>
 <1328544791.14547.12.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328544791.14547.12.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2012 at 08:13:11AM -0800, wwguy wrote:
> On Mon, 2012-02-06 at 17:09 +0100, Stanislaw Gruszka wrote:
> > @@ -117,16 +117,17 @@ int iwl_grab_nic_access_silent(struct iwl_bus *bus)
> >  	return 0;
> >  }
> >  
> > -int iwl_grab_nic_access(struct iwl_bus *bus)
> > +bool iwl_grab_nic_access(struct iwl_bus *bus)
> >  {
> >  	int ret = iwl_grab_nic_access_silent(bus);
> >  	if (unlikely(ret)) {
> >  		u32 val = iwl_read32(bus, CSR_GP_CNTRL);
> >  		WARN_ONCE(1, "Timeout waiting for ucode processor access "
> >  			     "(CSR_GP_CNTRL 0x%08x)\n", val);
> > +		return false;
> >  	}
> >  
> > -	return ret;
> > +	return true;
> >  }
> >  u32 iwl_read_direct32(struct iwl_bus *bus, u32 reg);
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > index 965d047..218071a 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > @@ -443,7 +443,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
> >  	if (iwlagn_hw_valid_rtc_data_addr(base)) {
> >  		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
> >  		ret = iwl_grab_nic_access_silent(bus(priv));
> > -		if (ret == 0) {
> > +		if (likely(ret == 0)) {
> 
> you change the return to bool, right, but "ret" is "int"

I only changed iwl_grab_nic_access(),
iwl_grab_nic_access_silent() still returns int.

Stanislaw 
