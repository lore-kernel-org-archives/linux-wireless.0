Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:7140 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaCJR3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 13:29:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: [PATCH 5/6] ath6kl: remove a warning on a macro
References: <20140309065606.10793.67068.stgit@x230>
	<20140309065735.10793.45835.stgit@x230>
	<87iornn8xx.fsf@kamboji.qca.qualcomm.com>
	<1394349609.6972.39.camel@joe-AO722>
Date: Mon, 10 Mar 2014 19:29:41 +0200
In-Reply-To: <1394349609.6972.39.camel@joe-AO722> (Joe Perches's message of
	"Sat, 8 Mar 2014 23:20:09 -0800")
Message-ID: <87y50iklmi.fsf@kamboji.qca.qualcomm.com> (sfid-20140310_183000_026812_FD8494A7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Sun, 2014-03-09 at 09:10 +0200, Kalle Valo wrote:
>
>> I would need help with this checkpatch warning:
>
> No idea what the warning is.

Hmm, maybe I'll just disable the warning in my check script.

>> > --- a/drivers/net/wireless/ath/ath6kl/debug.c
>> > +++ b/drivers/net/wireless/ath/ath6kl/debug.c
>> > @@ -798,12 +798,10 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
>> >  		return -ENOMEM;
>> >  
>> >  #define EPSTAT(name)							\
>> > -	do {								\
>> > -		len = print_endpoint_stat(target, buf, buf_len, len,	\
>> > -					  offsetof(struct htc_endpoint_stats, \
>> > -						   name),		\
>> > -					  #name);			\
>> > -	} while (0)
>> > +	(len = print_endpoint_stat(target, buf, buf_len, len,		\
>> > +				   offsetof(struct htc_endpoint_stats,	\
>> > +					    name),			\
>> > +				   #name))
>> 
>> I wasn't quite able to figure out what is the preferred style here. I
>> don't see how the () style is any better, but checkpatch didn't complain
>> at least.
>
> No idea what the preferred style is, but
> I'd probably change the #define to
>
> #define EPSTAT(name)							\
> 	print_endpoint_stat(target, buf, buf_len, len,			\
> 			    offsetof(struct htc_endpoint_stats, name),	\
> 			    #name)
>
> and the uses to
>
> 	len = EPSTAT(whatever);

The problem with this is that using of len as an argument is hidden but
storing the result is visible. Maybe it's better that I just disable the
warning for me and not worry about this.

-- 
Kalle Valo
