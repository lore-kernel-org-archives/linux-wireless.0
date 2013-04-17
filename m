Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736Ab3DQHMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 03:12:16 -0400
Message-ID: <1366182726.8217.0.camel@jlt4.sipsolutions.net> (sfid-20130417_091219_969999_01494A08)
Subject: Re: [PATCH 3/2] iwlwifi: remove unneeded goto from
 iwl_dbgfs_log_event_read
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jonas Gorski <jogo@openwrt.org>
Date: Wed, 17 Apr 2013 09:12:06 +0200
In-Reply-To: <CAGRGNgXuqkUmcOTfEKqrDDUxu8741QE-dWrb-tdvV9d28X+GzQ@mail.gmail.com> (sfid-20130417_091100_300450_555FC8AB)
References: <20130416133828.GA20024@redhat.com>
	 <20130416134053.GB20024@redhat.com> <20130417062350.GC1597@redhat.com>
	 <CAGRGNgXuqkUmcOTfEKqrDDUxu8741QE-dWrb-tdvV9d28X+GzQ@mail.gmail.com>
	 (sfid-20130417_091100_300450_555FC8AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-17 at 17:10 +1000, Julian Calaby wrote:
> Hi Stanislaw,
> 
> On Wed, Apr 17, 2013 at 4:23 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > Make code simpler a bit.
> >
> > Reported-by: Jonas Gorski <jogo@openwrt.org>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlwifi/dvm/debugfs.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
> > index 17f04de..d532948 100644
> > --- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
> > +++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
> > @@ -2241,10 +2241,8 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
> >         ssize_t ret;
> >
> >         ret = iwl_dump_nic_event_log(priv, true, &buf);
> > -       if (ret < 0)
> > -               goto err;
> > -       ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> > -err:
> > +       if (ret > 0)
> > +               ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> 
> That's not the same, what happens if ret == 0?

It's the same: nothing will be read regardless of whether you call the
function or not.

johannes

