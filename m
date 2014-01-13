Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:64581 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaAMMlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 07:41:51 -0500
Received: by mail-we0-f170.google.com with SMTP id u57so6378418wes.15
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 04:41:50 -0800 (PST)
Date: Mon, 13 Jan 2014 13:41:10 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Bondar, Alexander" <alexander.bondar@intel.com>
Subject: Re: [PATCH 08/36] iwlwifi: mvm: Change power management dependency
 on multi MAC
Message-ID: <20140113124049.GA5796@magnum.frso.rivierawaves.com> (sfid-20140113_134155_115414_6D8A4154)
References: <52B0B72A.5070704@gmail.com>
 <1387313079-28123-8-git-send-email-egrumbach@gmail.com>
 <20140113111357.GA4611@magnum.frso.rivierawaves.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C4A5@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D3C4A5@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 13, 2014 at 11:15:53AM +0000, Grumbach, Emmanuel wrote:
> > >
> > > FW still does not support power management on multiple MAC interfaces.
> > > Currently the driver enforce this limitation by disabling PM if second
> > > interface is added. Change this behavior to allow PM on a single
> > > interface even if other interfaces exist but not bound to any specific PHY.
> > > PM will be enabled if only one single interface is bound.
> > >
> > > Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
> > > Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> > > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > 
> > Hi,
> > 
> > This broke monitor mode:
> > (unsetting .power_update_binding does not hang)
> > 
> > modprobe iwlmvm
> > iw dev wlan0 set type monitor
> > iw dev wlan0 set freq 5180 40 5190  # hangs
> > 
> > Can you reproduce it easily or do you need me to post further dbg info ?
> > 
> 
> We have an open bug on this internally - thanks for reporting.

OK, BTW I have errors like
- "Microcode SW error detected." upon monitor up
- "iwlwifi 0000:02:00.0: FW error in SYNC CMD TXPATH_FLUSH" sometimes
after the subsequent ieee80211_restart_hw
- "WARNING: ... iwlwifi/mvm/binding.c:201 iwl_mvm_binding_remove_vif"
  when removing a monitor iface

You must have seen those too. I will avoid this tree with iwlwifi then.

 
Karl
