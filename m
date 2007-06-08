Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9403 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964968AbXFHBSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 21:18:36 -0400
Subject: Re: [PATCH 3/3] mac80211: debugfs support for TSM and DLS
From: Zhu Yi <yi.zhu@intel.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070607223934.4726e8a7@griffin.suse.cz>
References: <20070606082239.GA28667@mail.intel.com>
	 <20070607223934.4726e8a7@griffin.suse.cz>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 09:17:55 +0800
Message-Id: <1181265476.3039.86.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-06-07 at 22:39 +0200, Jiri Benc wrote:
> A global variable? Common for all devices you have in your computer?
> That's broken.

OK, it can be fixed. But it is that broken if you treat it as a debug
helper and don't use it on mulitple interfaces simultaneously.

> > +
> > +#define DEBUGFS_QOS_FILE(name, f)					\
> > +static ssize_t qos_ ##name## _write(struct file *file,			\
> > +				    const char __user *userbuf,		\
> > +				    size_t count, loff_t *ppos)		\
> > +{									\
> > +	struct ieee80211_sub_if_data *sdata = file->private_data;	\
> > +									\
> > +	f(sdata->dev, &sdata->u.sta, &_tspec);				\
> > +									\
> > +	return count;							\
> > +}									\
> 
> Triggering an event just by writing anything to the debugfs file
> doesn't seem like a clean and intelligible way to configure things.
> 
> Also, are you aware this is just a _debug_ stuff? Given the fact that
> you're calling (for example) ieee80211_send_addts from debugfs handler
> only, it looks like you're misusing it as an user space API.

If you follow the thread, I will write a user space API with cfg80211.
This one for debugging only.

-yi 
