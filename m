Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:45734 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752574AbaCJUDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 16:03:33 -0400
Message-ID: <1394481810.21085.3.camel@joe-AO722> (sfid-20140310_210342_303093_32B87D4E)
Subject: Re: [PATCH 5/6] ath6kl: remove a warning on a macro
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Date: Mon, 10 Mar 2014 13:03:30 -0700
In-Reply-To: <87y50iklmi.fsf@kamboji.qca.qualcomm.com>
References: <20140309065606.10793.67068.stgit@x230>
	 <20140309065735.10793.45835.stgit@x230>
	 <87iornn8xx.fsf@kamboji.qca.qualcomm.com>
	 <1394349609.6972.39.camel@joe-AO722>
	 <87y50iklmi.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-10 at 19:29 +0200, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> > On Sun, 2014-03-09 at 09:10 +0200, Kalle Valo wrote:
> >> I would need help with this checkpatch warning:
> > No idea what the warning is.
> 
> Hmm, maybe I'll just disable the warning in my check script.
> 
> >> > --- a/drivers/net/wireless/ath/ath6kl/debug.c
> >> > +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> >> > @@ -798,12 +798,10 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
> >> >  		return -ENOMEM;
> >> >  
> >> >  #define EPSTAT(name)							\
> >> > -	do {								\
> >> > -		len = print_endpoint_stat(target, buf, buf_len, len,	\
> >> > -					  offsetof(struct htc_endpoint_stats, \
> >> > -						   name),		\
> >> > -					  #name);			\
> >> > -	} while (0)
> >> > +	(len = print_endpoint_stat(target, buf, buf_len, len,		\
> >> > +				   offsetof(struct htc_endpoint_stats,	\
> >> > +					    name),			\
> >> > +				   #name))
> >> 
> >> I wasn't quite able to figure out what is the preferred style here. I
> >> don't see how the () style is any better, but checkpatch didn't complain
> >> at least.
> >
> > No idea what the preferred style is, but
> > I'd probably change the #define to
> >
> > #define EPSTAT(name)							\
> > 	print_endpoint_stat(target, buf, buf_len, len,			\
> > 			    offsetof(struct htc_endpoint_stats, name),	\
> > 			    #name)
> >
> > and the uses to
> >
> > 	len = EPSTAT(whatever);
> 
> The problem with this is that using of len as an argument is hidden but
> storing the result is visible. Maybe it's better that I just disable the
> warning for me and not worry about this.

Hey, it's your code, do what you think sensible.

But, I don't think that's the right thing to do.

It _is_ a single line macro and doesn't need
a do {} while (0) wrapper.  It also doesn't
need extra parentheses either.

If you don't like the macro, you could always
expand it in-place or change the macro to avoid
passing len and only using the return value as
a +=.


