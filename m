Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47089 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798AbcDFKMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 06:12:17 -0400
Date: Wed, 6 Apr 2016 15:41:58 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	ath10k@lists.infradead.org, Yanbo Li <yanbol@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix return value for btcoex and peer stats
 debugfs
Message-ID: <20160406101137.GA27525@atheros-ThinkPad-T61> (sfid-20160406_121221_722562_7DA7BC52)
References: <1459870106-2694-1-git-send-email-mohammed@qca.qualcomm.com>
 <1459877336.6715.6.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1459877336.6715.6.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Joe,

On Tue, Apr 05, 2016 at 10:28:56AM -0700, Joe Perches wrote:
> On Tue, 2016-04-05 at 20:58 +0530, Mohammed Shafi Shajakhan wrote:
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > 
> > Return value is incorrect for btcoex and peer stats debugfs
> > 'write' entries if the user provides a value that matches with
> > the already available debugfs entry, this results in the debugfs
> > entry getting stuck and the operation has to be terminated manually.
> > Fix this by returning the appropriate return 'count' as we do it for
> > other debugfs entries like pktlog etc
> 
> Not your code, but some of the xor uses are odd at best.

[shafi] ok.

> 
> > diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> []
> > @@ -2122,7 +2122,7 @@ static ssize_t ath10k_write_btcoex(struct file *file,
> >  	struct ath10k *ar = file->private_data;
> >  	char buf[32];
> >  	size_t buf_size;
> > -	int ret = 0;
> > +	int ret;
> >  	bool val;
> >  
> >  	buf_size = min(count, (sizeof(buf) - 1));
> > @@ -2142,8 +2142,10 @@ static ssize_t ath10k_write_btcoex(struct file *file,
> >  		goto exit;
> >  	}
> >  
> > -	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val))
> > +	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val)) {
> 
> xor on an int and a bool.

[shafi] Should we change the 'val' to int, but this code seems to be working
test_bit seems to do this :
	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));

	do we see a problem, it should work right  (because they are bitwise
	'ANDING' with 1UL)

> 
> > @@ -2189,7 +2191,7 @@ static ssize_t ath10k_write_peer_stats(struct file *file,
> >  	struct ath10k *ar = file->private_data;
> >  	char buf[32];
> >  	size_t buf_size;
> > -	int ret = 0;
> > +	int ret;
> >  	bool val;
> >  
> >  	buf_size = min(count, (sizeof(buf) - 1));
> > @@ -2209,8 +2211,10 @@ static ssize_t ath10k_write_peer_stats(struct file *file,
> >  		goto exit;
> >  	}
> >  
> > -	if (!(test_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags) ^ val))
> > +	if (!(test_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags) ^ val)) {
> 
> here too

[shafi] same thing here ? is there a better code , kindly suggest

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
