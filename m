Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33968 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaDYBpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 21:45:17 -0400
Date: Thu, 24 Apr 2014 21:37:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
Message-ID: <20140425013756.GA3410@tuxdriver.com> (sfid-20140425_034614_624982_767B7962)
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
 <1397760423-11455-2-git-send-email-bzhao@marvell.com>
 <87a9bb5c2c.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87a9bb5c2c.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 24, 2014 at 12:08:59PM +0300, Kalle Valo wrote:
> Bing Zhao <bzhao@marvell.com> writes:
> 
> > From: Amitkumar Karwar <akarwar@marvell.com>
> >
> > Firmware dump feature is added for PCIe based chipsets.
> > Separate file will be created at /var/log/fw_dump_*
> > for each memory segment.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> 
> Sorry for commenting so late, I was on holidays and then got lagged
> behind with email.
> 
> > +			memset(filename, 0, sizeof(filename));
> > +			memcpy(filename, name_prefix, strlen(name_prefix));
> > +			strcat(filename, entry->mem_name);
> > +			do_gettimeofday(&t);
> > +			entry->file_mem = filp_open(filename, O_CREAT | O_RDWR,
> > +						    0644);
> > +			if (IS_ERR(entry->file_mem)) {
> > +				dev_info(adapter->dev,
> > +					 "Create %s file failed at %s, opening another dir /tmp\n",
> > +					 entry->mem_name, filename);
> > +				memset(filename, 0, sizeof(filename));
> > +				sprintf(filename, "%s%s", "/tmp/fw_dump_",
> > +					entry->mem_name);
> > +				entry->file_mem =
> > +					filp_open(filename,
> > +						  O_CREAT | O_RDWR, 0644);
> > +			}
> > +			if (!IS_ERR(entry->file_mem)) {
> > +				dev_info(adapter->dev,
> > +					 "Start to save the output : %u.%06u, please wait...\n",
> > +					 (u32)t.tv_sec, (u32)t.tv_usec);
> 
> Like I said in my previous email, IMHO a wireless driver should not save
> any files to the filesystem. For example, I don't see any other uses of
> filp_open() in drivers/net. Ugly hacks like this belong to staging
> drivers, not to proper upstream drivers.

I'm sorry for letting this slip through.  I must have had too much rum or something...

I'm reverting this patch in wireless-next -- drivers should not be
making filesystem calls like that.  Even if you can argue for doing
so somehow, where the file would go would be a policy decision that
should not be encoded in the driver.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
