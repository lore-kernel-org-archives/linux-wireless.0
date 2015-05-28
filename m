Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12508 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbE1BHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 21:07:48 -0400
From: "Li, Yanbo" <yanbol@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "dreamfly281@gmail.com" <dreamfly281@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [PATCH] ath10k: Debugfs entry to enable/disable BTC feature
Date: Thu, 28 May 2015 01:07:46 +0000
Message-ID: <f33b4183a8054a21ad04075e8fb5eb94@nasanexm02e.na.qualcomm.com> (sfid-20150528_030753_619997_1973D776)
References: <1430514659-11743-1-git-send-email-yanbol@qca.qualcomm.com>
 <871ti218me.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871ti218me.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Valo, Kalle
> Sent: Wednesday, May 27, 2015 5:57 AM
> To: Li, Yanbo
> Cc: dreamfly281@gmail.com; linux-wireless@vger.kernel.org;
> michal.kazior@tieto.com; ath10k@lists.infradead.org
> Subject: Re: [PATCH] ath10k: Debugfs entry to enable/disable BTC feature
> 
> Yanbo Li <yanbol@qca.qualcomm.com> writes:
> 
> > As some radio have no connection with BT modules, enable the BTC
> > feature will has some side effect if the radio's GPIO connect with any
> > other HW modules. Add the control switcher "btc_feature" at debugfs
> > and set the feature as disable by default to avoid such case.
> >
> > To enable this feature, execute:
> > echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
> > To disable:
> > echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
> 
> I suspect "BTC" does not really tell much for most of the people and
> acronyms should be always spelled out at least once.
> 
> > Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.h
> > b/drivers/net/wireless/ath/ath10k/core.h
> > index 8444adf42195..6852e7fc5d5f 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.h
> > +++ b/drivers/net/wireless/ath/ath10k/core.h
> > @@ -720,6 +720,8 @@ struct ath10k {
> >  		u32 fw_cold_reset_counter;
> >  	} stats;
> >
> > +	bool btc_feature;
> 
> Could we use ar->dev_flags instead?

This dev_flags currently used to mark some status, like the cradh, CAC running, 
The BTcoex feature is more likely a HW feature,  there are seems different set. 

Maybe a separately hw_feature_flag is needed as there are some other HW feature 
That we want to enable/disable from user space. 
> 
> > +static ssize_t ath10k_write_btc_feature(struct file *file,
> > +					const char __user *ubuf,
> > +					size_t count, loff_t *ppos)
> > +{
> > +	struct ath10k *ar = file->private_data;
> > +	char buf[32];
> > +	size_t buf_size;
> > +	bool val;
> > +
> > +	buf_size = min(count, (sizeof(buf) - 1));
> > +	if (copy_from_user(buf, ubuf, buf_size))
> > +		return -EFAULT;
> > +
> > +	buf[buf_size] = '\0';
> > +	if (strtobool(buf, &val) != 0) {
> > +		ath10k_warn(ar, "Wrong BTC feature setting\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	mutex_lock(&ar->conf_mutex);
> > +	ar->btc_feature = val;
> > +	queue_work(ar->workqueue, &ar->restart_work);
> > +	mutex_unlock(&ar->conf_mutex);
> 
> Shouldn't we test ATH10K_STATE_ON first?

The restart process will judge by itself whether the device is on or not, and print below warning in that case:

[797424.496190] ath10k_pci 0000:05:00.0: cannot restart a device that hasn't been started

> 
> >  int ath10k_debug_create(struct ath10k *ar)  {
> >  	ar->debug.fw_crash_data = vzalloc(sizeof(*ar-
> >debug.fw_crash_data));
> > @@ -2195,6 +2243,8 @@ int ath10k_debug_register(struct ath10k *ar)
> >  	debugfs_create_file("quiet_period", S_IRUGO | S_IWUSR,
> >  			    ar->debug.debugfs_phy, ar, &fops_quiet_period);
> >
> > +	debugfs_create_file("btc_feature", S_IRUGO | S_IWUSR,
> > +			    ar->debug.debugfs_phy, ar,
> > &fops_btc_feature);
> 
> At least some of the other drivers use term btcoex for this, I think we should
> be consistent and use the same.
> 
> I can do the changes and send v2 for this.

Thanks and agree, I will send the 2v as there are some other tiny change at my side.

BR /Yanbo
