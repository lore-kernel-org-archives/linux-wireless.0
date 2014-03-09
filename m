Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:59520 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750761AbaCIHUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 03:20:12 -0400
Message-ID: <1394349609.6972.39.camel@joe-AO722> (sfid-20140309_082029_447748_3D4496B2)
Subject: Re: [PATCH 5/6] ath6kl: remove a warning on a macro
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Date: Sat, 08 Mar 2014 23:20:09 -0800
In-Reply-To: <87iornn8xx.fsf@kamboji.qca.qualcomm.com>
References: <20140309065606.10793.67068.stgit@x230>
	 <20140309065735.10793.45835.stgit@x230>
	 <87iornn8xx.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-09 at 09:10 +0200, Kalle Valo wrote:
> Hi Joe,

Hi Kalle.

> I would need help with this checkpatch warning:

No idea what the warning is.

> > --- a/drivers/net/wireless/ath/ath6kl/debug.c
> > +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> > @@ -798,12 +798,10 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
> >  		return -ENOMEM;
> >  
> >  #define EPSTAT(name)							\
> > -	do {								\
> > -		len = print_endpoint_stat(target, buf, buf_len, len,	\
> > -					  offsetof(struct htc_endpoint_stats, \
> > -						   name),		\
> > -					  #name);			\
> > -	} while (0)
> > +	(len = print_endpoint_stat(target, buf, buf_len, len,		\
> > +				   offsetof(struct htc_endpoint_stats,	\
> > +					    name),			\
> > +				   #name))
> 
> I wasn't quite able to figure out what is the preferred style here. I
> don't see how the () style is any better, but checkpatch didn't complain
> at least.

No idea what the preferred style is, but
I'd probably change the #define to

#define EPSTAT(name)							\
	print_endpoint_stat(target, buf, buf_len, len,			\
			    offsetof(struct htc_endpoint_stats, name),	\
			    #name)

and the uses to

	len = EPSTAT(whatever);


