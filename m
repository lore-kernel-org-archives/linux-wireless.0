Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49116 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaJBNF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 09:05:27 -0400
Date: Thu, 2 Oct 2014 18:36:56 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/4] ath10k: Add support to configure pktlog filter
Message-ID: <20141002130654.GA12709@qca.qualcomm.com> (sfid-20141002_150532_752676_CA895251)
References: <1412251934-7011-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1412251934-7011-2-git-send-email-rmanohar@qti.qualcomm.com>
 <CA+BoTQ=QEnDhW_Kb-dCO--67LAFNL37g4JSDuET84FFPLHpz8w@mail.gmail.com>
 <20141002125324.GA11177@qca.qualcomm.com>
 <CA+BoTQk-w9D=0urUTfaF6RrSYEkXAqUT+DAJZKq0bfTVFK18xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+BoTQk-w9D=0urUTfaF6RrSYEkXAqUT+DAJZKq0bfTVFK18xA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 02, 2014 at 02:58:43PM +0200, Michal Kazior wrote:
> On 2 October 2014 14:53, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> > On Thu, Oct 02, 2014 at 02:37:13PM +0200, Michal Kazior wrote:
> >> On 2 October 2014 14:12, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> >> > Add support to configure packet log filters (tx, rx, rate control)
> >> > via debugfs. To disable htt pktlog events set the filters to 0.
> >> [...]
> >> > +static ssize_t ath10k_write_pktlog_filter(struct file *file,
> >> > +                                         const char __user *ubuf,
> >> > +                                         size_t count, loff_t *ppos)
> >> > +{
> >> > +       struct ath10k *ar = file->private_data;
> >> > +       u32 filter;
> >> > +       int ret;
> >> > +
> >> > +       if (kstrtouint_from_user(ubuf, count, 0, &filter))
> >> > +               return -EINVAL;
> >> > +
> >> > +       mutex_lock(&ar->conf_mutex);
> >> > +       if (filter && (filter != ar->debug.pktlog_filter))
> >> > +               ret = ath10k_wmi_pdev_pktlog_enable(ar, filter);
> >> > +       else
> >> > +               ret = ath10k_wmi_pdev_pktlog_disable(ar);
> >>
> >> You're not checking if ar->state is ON.
> >>
> > How about updating pktlog_filter alone and not sending WMI command when
> > state != ON. So that in the next drv_start pktlog will be either be
> > disabled or enabled based on filter value at debug_start.
> 
> Sounds good to me.
> 
> 
> >> Even if I assume the above doesn't crash the driver/system this has
> >> strange semantics. On one hand the driver has to be after drv_start
> >> (e.g. at least one interface must be up) before it's possible to set
> >> it but on the other hand pktlog_filter is retained across
> >> drv_stop/start. I'd expect it to be possible to set the pktlog_filter
> >> regardless of driver state but maybe that's just me.
> >>
> > So pktlog should be disabed at ath10k_debug_stop. isn't it?
> 
> Actually my bad. You set ar->debug.pktlog_filter regardless of wmi
> command result which is fine.
> 
Thanks for your quick feedback.

-Rajkumar
