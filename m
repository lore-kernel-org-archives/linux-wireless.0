Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50618 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbdLKM5f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 07:57:35 -0500
Message-ID: <1512997053.26976.77.camel@sipsolutions.net> (sfid-20171211_135738_720722_270269F2)
Subject: Re: [PATCH v2 1/5] mac80211_hwsim: wait for deferred radio deletion
 on mod unload
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Dec 2017 13:57:33 +0100
In-Reply-To: <d61a234d-6072-1714-0674-7981ef20b33a@uni-rostock.de>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
         <3a182eff-3f00-49bb-94ac-ec371ff1c26e@MAIL2.uni-rostock.de>
         <1512992771.26976.73.camel@sipsolutions.net>
         <d61a234d-6072-1714-0674-7981ef20b33a@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-12-11 at 13:54 +0100, Benjamin Beichler wrote:
> Am 11.12.2017 um 12:46 schrieb Johannes Berg:
> > 
> > > +	spin_lock_bh(&hwsim_delete_lock);
> > > +	while (!list_empty(&delete_radios)) {
> > > +		pr_debug("mac80211_hwsim: wait for deferred radio remove\n");
> > > +		spin_unlock_bh(&hwsim_delete_lock);
> > > +		flush_work(&list_entry(&delete_radios,
> > > +				       struct mac80211_hwsim_data, list)
> > > +			   ->destroy_work);
> > 
> > This can't possibly be right ... you're locking the list_empty which is
> > a trivial pointer comparison, but not the actual list_entry() ...
> 
> Maybe the first spin_lock is not needed, but since flush_work wait for
> the completion of the task, which at the end also deletes the item from
> the list, holding any spin_lock would be wrong.

But not holding it while taking things that are on the list also seems
wrong.

> > I'd also prefer you actually didn't leave the problem in part as you
> > describe - and a new workqueue probably isn't that much overhead and
> > should introduce *less* new code than this, so IMHO that's worth it.
> 
> I totally agree with you, but I don't know the actual policy for
> creating workqeues. I could also simply call flush_scheduled_work,
> because we may have enough time at module unload. Some modules also do
> it, but the description an some mailing threads mark it like
> evil/deprecated. Which solution do you prefer?

Let's go with a new workqueue.

johannes
