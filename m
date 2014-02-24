Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58714 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaBXILh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 03:11:37 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Joe Perches <joe@perches.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Eyal Shapira" <eyal@wizery.com>,
	"Shapira, EyalX" <eyalx.shapira@intel.com>
Subject: RE: [PATCH 13/17] iwlwifi: mvm: add Rx frames statistics via debugfs
Date: Mon, 24 Feb 2014 08:11:32 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D71064@HASMSX103.ger.corp.intel.com> (sfid-20140224_091144_809998_79C79D0D)
References: <530A51A4.6000007@gmail.com>
	 <1393185428-8524-13-git-send-email-egrumbach@gmail.com>
 <1393186232.11020.6.camel@joe-AO722>
In-Reply-To: <1393186232.11020.6.camel@joe-AO722>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

> >
> > Collect statistics regarding rates and aggregations in Rx frames and
> > export the data via debugfs.
> []
> > diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
> > b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
> []
> > +static ssize_t iwl_dbgfs_frame_stats_read(struct iwl_mvm *mvm,
> > +					  char __user *user_buf, size_t count,
> > +					  loff_t *ppos,
> > +					  struct iwl_mvm_frame_stats *stats)
> {
> > +	char *buff;
> > +	int pos = 0, idx, i;
> 
> I think this would be shorter code using pos as a char *
> 
> > +	int ret;
> > +	size_t bufsz = 1024;
> 
> I'd prefer #define or static const though the compiler should do the same
> thing.
> 
> > +	buff = kmalloc(bufsz, GFP_KERNEL);
> > +	if (!buff)
> > +		return -ENOMEM;
> > +
> > +	spin_lock_bh(&mvm->drv_stats_lock);
> 
> 	pos = buff;
> 	endpos = pos + bufsz;
> 
> > +	pos += scnprintf(buff + pos, bufsz - pos,
> > +			 "Legacy/HT/VHT\t:\t%d/%d/%d\n",
> > +			 stats->legacy_frames,
> > +			 stats->ht_frames,
> > +			 stats->vht_frames);
> 
> 	pos += scnprintf(pos, endpos - pos, etc...
> 
> etc...
> 

I prefer not to reset my trees at that stage - it'll be addressed in a new commit of top of this.

