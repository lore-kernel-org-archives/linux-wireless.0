Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35339 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbZHCTqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:46:00 -0400
Date: Mon, 3 Aug 2009 15:40:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Martin Ettl <ettl.martin@gmx.de>
Subject: Re: [PATCH] iwlwifi: avoid memory leak in iwl_dbgfs_nvm_read
Message-ID: <20090803194002.GC11441@tuxdriver.com>
References: <1249325388-6496-1-git-send-email-linville@tuxdriver.com> <1249326492.30019.4277.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1249326492.30019.4277.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 03, 2009 at 12:08:12PM -0700, reinette chatre wrote:
> On Mon, 2009-08-03 at 11:49 -0700, John W. Linville wrote:
> > Reported-by: Martin Ettl <ettl.martin@gmx.de>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-debugfs.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
> > index 11e08c0..6525e41 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
> > @@ -318,7 +318,8 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
> >  	ptr = priv->eeprom;
> >  	if (!ptr) {
> >  		IWL_ERR(priv, "Invalid EEPROM/OTP memory\n");
> > -		return -ENOMEM;
> > +		ret = -ENOMEM;
> > +		goto out;
> >  	}
> >  	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s\n",
> >  			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
> > @@ -333,6 +334,8 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
> >  	}
> >  
> >  	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
> > +
> > +out:
> >  	kfree(buf);
> >  	return ret;
> >  }
> 
> There was another patch also that was acked by Zhu Yi. See
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/37032

Yes, I see that now -- perhaps Martin will take-up Julia's habit of
posting patches himself... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
