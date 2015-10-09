Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbbJIOct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 10:32:49 -0400
Message-ID: <1444401167.20283.2.camel@redhat.com> (sfid-20151009_163326_119214_B4EDEFB8)
Subject: Re: [RFC PATCH 2/2] airo: fix scan after SIOCSIWAP (airo_set_wap)
From: Dan Williams <dcbw@redhat.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-wireless@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Date: Fri, 09 Oct 2015 09:32:47 -0500
In-Reply-To: <1444328044-13075-2-git-send-email-linux@rainbow-software.org>
References: <1444328044-13075-1-git-send-email-linux@rainbow-software.org>
	 <1444328044-13075-2-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-10-08 at 20:14 +0200, Ondrej Zary wrote:
> SIOCSIWAP (airo_set_wap) affects scan: only the AP specified by
> SIOCSIWAP is present in scan results.
> 
> This makes NetworkManager work for the first time but then unable to
> find any other APs.
> 
> Clear APList before starting scan and set it back after scan completes
> to work-around the problem.

Sounds plausible.  But does this cause any problems while the device is
associated and a scan is requested?  If not then it seems fine.

Dan

> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/net/wireless/airo.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index 4ef2f98..654a172 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -3037,6 +3037,11 @@ static void airo_process_scan_results (struct airo_info *ai) {
>  	}
>  
>  out:
> +	/* write APList back (we cleared it in airo_set_scan) */
> +	disable_MAC(ai, 0);
> +	writeAPListRid(ai, &ai->APList, 0);
> +	enable_MAC(ai, 0);
> +
>  	ai->scan_timeout = 0;
>  	clear_bit(JOB_SCAN_RESULTS, &ai->jobs);
>  	up(&ai->sem);
> @@ -7216,6 +7221,7 @@ static int airo_set_scan(struct net_device *dev,
>  	Cmd cmd;
>  	Resp rsp;
>  	int wake = 0;
> +	APListRid APList_rid_empty;
>  
>  	/* Note : you may have realised that, as this is a SET operation,
>  	 * this is privileged and therefore a normal user can't
> @@ -7233,6 +7239,13 @@ static int airo_set_scan(struct net_device *dev,
>  	if (ai->scan_timeout > 0)
>  		goto out;
>  
> +	/* Clear APList as it affects scan results */
> +	memset(&APList_rid_empty, 0, sizeof(APList_rid_empty));
> +	APList_rid_empty.len = cpu_to_le16(sizeof(APList_rid_empty));
> +	disable_MAC(ai, 0);
> +	writeAPListRid(ai, &APList_rid_empty, 0);
> +	enable_MAC(ai, 0);
> +
>  	/* Initiate a scan command */
>  	ai->scan_timeout = RUN_AT(3*HZ);
>  	memset(&cmd, 0, sizeof(cmd));


