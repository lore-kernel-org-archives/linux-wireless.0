Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36644 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbbFIS65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 14:58:57 -0400
Received: by oihb142 with SMTP id b142so17547470oih.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 11:58:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wpzeiac7.fsf@kamboji.qca.qualcomm.com>
References: <1430514659-11743-1-git-send-email-yanbol@qca.qualcomm.com>
	<871ti218me.fsf@kamboji.qca.qualcomm.com>
	<f33b4183a8054a21ad04075e8fb5eb94@nasanexm02e.na.qualcomm.com>
	<87wpzeiac7.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 9 Jun 2015 11:58:55 -0700
Message-ID: <CAFuUQkiBaTdSjGpKKT4qnJJBtLnG43YLu9GJp_XtLZAYEKhhsg@mail.gmail.com> (sfid-20150609_205904_363987_B3DF9421)
Subject: Re: [PATCH] ath10k: Debugfs entry to enable/disable BTC feature
From: YanBo <dreamfly281@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "Li, Yanbo" <yanbol@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 8, 2015 at 6:44 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> "Li, Yanbo" <yanbol@qca.qualcomm.com> writes:
>
>>> -----Original Message-----
>>> From: Valo, Kalle
>>> Sent: Wednesday, May 27, 2015 5:57 AM
>>> To: Li, Yanbo
>>> Cc: dreamfly281@gmail.com; linux-wireless@vger.kernel.org;
>>> michal.kazior@tieto.com; ath10k@lists.infradead.org
>>> Subject: Re: [PATCH] ath10k: Debugfs entry to enable/disable BTC feature
>>>
>>> Yanbo Li <yanbol@qca.qualcomm.com> writes:
>>>
>>> > As some radio have no connection with BT modules, enable the BTC
>>> > feature will has some side effect if the radio's GPIO connect with any
>>> > other HW modules. Add the control switcher "btc_feature" at debugfs
>>> > and set the feature as disable by default to avoid such case.
>>> >
>>> > To enable this feature, execute:
>>> > echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
>>> > To disable:
>>> > echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
>>>
>>> I suspect "BTC" does not really tell much for most of the people and
>>> acronyms should be always spelled out at least once.
>>>
>>> > Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
>>> >
>>> > diff --git a/drivers/net/wireless/ath/ath10k/core.h
>>> > b/drivers/net/wireless/ath/ath10k/core.h
>>> > index 8444adf42195..6852e7fc5d5f 100644
>>> > --- a/drivers/net/wireless/ath/ath10k/core.h
>>> > +++ b/drivers/net/wireless/ath/ath10k/core.h
>>> > @@ -720,6 +720,8 @@ struct ath10k {
>>> >            u32 fw_cold_reset_counter;
>>> >    } stats;
>>> >
>>> > +  bool btc_feature;
>>>
>>> Could we use ar->dev_flags instead?
>>
>> This dev_flags currently used to mark some status, like the cradh, CAC running,
>> The BTcoex feature is more likely a HW feature,  there are seems different set.
>>
>> Maybe a separately hw_feature_flag is needed as there are some other HW feature
>> That we want to enable/disable from user space.
>
> I think we don't need a separate bitmap, we can use dev_flags just fine
> for this.
>
>>> > +static ssize_t ath10k_write_btc_feature(struct file *file,
>>> > +                                  const char __user *ubuf,
>>> > +                                  size_t count, loff_t *ppos)
>>> > +{
>>> > +  struct ath10k *ar = file->private_data;
>>> > +  char buf[32];
>>> > +  size_t buf_size;
>>> > +  bool val;
>>> > +
>>> > +  buf_size = min(count, (sizeof(buf) - 1));
>>> > +  if (copy_from_user(buf, ubuf, buf_size))
>>> > +          return -EFAULT;
>>> > +
>>> > +  buf[buf_size] = '\0';
>>> > +  if (strtobool(buf, &val) != 0) {
>>> > +          ath10k_warn(ar, "Wrong BTC feature setting\n");
>>> > +          return -EINVAL;
>>> > +  }
>>> > +
>>> > +  mutex_lock(&ar->conf_mutex);
>>> > +  ar->btc_feature = val;
>>> > +  queue_work(ar->workqueue, &ar->restart_work);
>>> > +  mutex_unlock(&ar->conf_mutex);
>>>
>>> Shouldn't we test ATH10K_STATE_ON first?
>>
>> The restart process will judge by itself whether the device is on or not, and print below warning in that case:
>>
>> [797424.496190] ath10k_pci 0000:05:00.0: cannot restart a device that
>> hasn't been started
>
> That's just buggy, ath10k should not print anything if a setting is
> changed while interface is down. It's much better we have the check for
> ATH10K_STATE_ON here.
>
Agree, will send v3 include these changes.
BR /Yanbo
