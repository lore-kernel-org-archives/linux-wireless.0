Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3572 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYHQScd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 14:32:33 -0400
Date: Sun, 17 Aug 2008 14:16:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rfkill: use strict_strtoul
Message-ID: <20080817181617.GA30679@tuxdriver.com> (sfid-20080817_203243_575851_EA98A372)
References: <1217699786-20672-1-git-send-email-hmh@hmh.eng.br> <1217699786-20672-3-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217699786-20672-3-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 02, 2008 at 02:56:26PM -0300, Henrique de Moraes Holschuh wrote:
> Switch sysfs parsing to something that actually works properly.

> @@ -402,7 +410,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  	if (error)
>  		return error;
>  
> -	if (rfkill->user_claim != claim) {
> +	if (!!rfkill->user_claim != !!claim) {
>  		if (!claim) {
>  			mutex_lock(&rfkill->mutex);
>  			rfkill_toggle_radio(rfkill,

This looks a bit funny.  Is the '!!' in front of 'rfkill->user_claim'
really necessary?  Especially since...

> @@ -410,7 +418,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  					    0);
>  			mutex_unlock(&rfkill->mutex);
>  		}
> -		rfkill->user_claim = claim;
> +		rfkill->user_claim = !!claim;
>  	}
>  
>  	mutex_unlock(&rfkill_mutex);

You seem to be doing the only assignment to 'rfkill->user_claim',
using a '!!' to condition the input?

John
-- 
John W. Linville
linville@tuxdriver.com
