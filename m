Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:38380 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZENVS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 17:18:56 -0400
Date: Thu, 14 May 2009 22:50:20 +0200
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Simulate medium behavior
Message-ID: <20090514205020.GC3225@newton.monom.org>
References: <20090422092159.GA24586@toronto053.server4you.de> <1240393088.21756.3.camel@johannes.local> <20090422113556.GB24586@toronto053.server4you.de> <20090507184007.GA6684@newton.monom.org> <1241722972.7590.34.camel@johannes.local> <20090514184547.GA3225@newton.monom.org> <1242328369.5799.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242328369.5799.9.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 09:12:49PM +0200, Johannes Berg wrote:
> On Thu, 2009-05-14 at 20:45 +0200, Daniel Wagner wrote:
> 
> Looks good to me, couple of comments below.
> 
> > +static int hwsim_fops_group_read(void *dat, u64 *val)
> > +{
> > +	struct mac80211_hwsim_data *data = dat;
> > +	*val = data->group;
> > +	return 0;
> > +}
> > +
> > +static int hwsim_fops_group_write(void *dat, u64 val)
> > +{
> > +	struct mac80211_hwsim_data *data = dat;
> > +	data->group = val;
> > +	return 0;
> > +}
> > +
> > +DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
> > +			hwsim_fops_group_read, hwsim_fops_group_write,
> > +			"%llu\n");
> 
> I think %llx would work better for this? At least I can do bitops better
> in hex :)

Yeah, I have to improve my copy&paste-foo :)

> 
> >  		data->debugfs_ps = debugfs_create_file("ps", 0666,
> >  						       data->debugfs, data,
> >  						       &hwsim_fops_ps);
> > +		data->debugfs_group = debugfs_create_file("group", 0666,
> > +							data->debugfs, data,
> > +							&hwsim_fops_group);
> 
> Good thing this is a test module only... debugfs files with user access
> permissions are a security risk. (a user can open the file and leave the
> fd open, if root then rmmods future reads/writes to the fd by the user
> crash the kernel)

There isn't much we can do about that, right? 

> Anyway looks good, please submit properly with [PATCH] etc :)

Done. 

Thanks for reviewing!

cheers,
daniel
