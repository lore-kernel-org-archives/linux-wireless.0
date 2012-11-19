Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2KSOxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:53:16 -0500
Message-ID: <1353336826.18299.20.camel@jlt4.sipsolutions.net> (sfid-20121119_155318_840800_57F2A369)
Subject: Re: [PATCH] mac80211: make remain_on_channel() op pass vif param
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 19 Nov 2012 15:53:46 +0100
In-Reply-To: <CAB3XZEcnew_7uJaWcMYF2Fv2ORKSUfPRGY0t-yrr1LKmwfWKYQ@mail.gmail.com> (sfid-20121119_155219_470602_06BF2B27)
References: <1353239862-11313-1-git-send-email-eliad@wizery.com>
	 <1353336285.18299.14.camel@jlt4.sipsolutions.net>
	 <CAB3XZEcnew_7uJaWcMYF2Fv2ORKSUfPRGY0t-yrr1LKmwfWKYQ@mail.gmail.com>
	 (sfid-20121119_155219_470602_06BF2B27)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 16:52 +0200, Eliad Peller wrote:
> On Mon, Nov 19, 2012 at 4:44 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2012-11-18 at 13:57 +0200, Eliad Peller wrote:
> >> Drivers (e.g. wl12xx) might need to know the vif
> >> to roc on (mainly in order to configure the
> >> rx filters correctly).
> >>
> >> Add the vif to the op params, and update the current
> >> users (iwlwifi) to use the new api.
> >
> > Hmm, ok, but I think then the ROC merge logic may have to be changed?
> >
> yeah, i guess you're right.
> 
> @@ -2247,7 +2247,8 @@ static int ieee80211_start_roc_work(struct
> ieee80211_local *local,
> 
>   out_check_combine:
>         list_for_each_entry(tmp, &local->roc_list, list) {
> -               if (tmp->chan != channel || tmp->chan_type != channel_type)
> +               if (tmp->chan != channel || tmp->chan_type != channel_type ||
> +                   tmp->sdata != sdata)
>                         continue;
> 
> should something like this be enough?

Yes, that seems right. I wasn't entirely sure the sdata pointer is
there, so I didn't go into specifics :)

johannes

