Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759466Ab0BZXJJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 18:09:09 -0500
Subject: Re: [PATCH resend] airo: return from set_wep_key() when key length
 is zero
From: Dan Williams <dcbw@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100226141027.GA10280@dhcp-lab-161.englab.brq.redhat.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com>
	 <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com>
	 <20100208205358.GA3852@tuxdriver.com>
	 <20100226141027.GA10280@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 15:09:29 -0800
Message-ID: <1267225769.14995.10.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-26 at 15:10 +0100, Stanislaw Gruszka wrote:
> Even if keylen == 0 is a bug and should not really happen, better avoid
> possibility of passing bad value to firmware.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

I actually told John to just apply your first patch via IRC, but perhaps
he hasn't done that yet.  I cannot reproduce the issue that Chris
encountered with my PCMCIA 350 using 5.60 firmware, and I bricked my
card loading 5.40 firmware (same as Chris) onto it.

I couldn't find any failures your original patch on my 5.60 device, my
objections were simply code flow and semantics.  So I'll ack the
original patch.

Dan


> ---
>  drivers/net/wireless/airo.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index 2a9f029..01bffc2 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -5254,7 +5254,8 @@ static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
>  	WepKeyRid wkr;
>  	int rc;
>  
> -	WARN_ON(keylen == 0);
> +	if (WARN_ON(keylen == 0))
> +		return -1;
>  
>  	memset(&wkr, 0, sizeof(wkr));
>  	wkr.len = cpu_to_le16(sizeof(wkr));


