Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41475 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbZBCQlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 11:41:20 -0500
Subject: Re: [PATCH] wireless: pos[4] tested twice, 2nd should be pos[5]
From: Dan Williams <dcbw@redhat.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: johannes@sipsolutions.net, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <49886DBD.9030302@gmail.com>
References: <49886DBD.9030302@gmail.com>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 11:39:32 -0500
Message-Id: <1233679172.11344.59.camel@localhost.localdomain> (sfid-20090203_174138_809034_4AC7832D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-03 at 17:15 +0100, Roel Kluin wrote:
> Is this what it should be? please review.
> ----------------->8----------------------8<------------------
> 
> pos[4] can't be both 0x43 and 0x04, 2nd should be pos[5]
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
> index 57f6c12..00a57ed 100644
> --- a/drivers/net/wireless/libertas/scan.c
> +++ b/drivers/net/wireless/libertas/scan.c
> @@ -692,7 +692,7 @@ static int lbs_process_bss(struct bss_descriptor *bss,
>  					    bss->wpa_ie_len);
>  			} else if (pos[1] >= MARVELL_MESH_IE_LENGTH &&
>  				   pos[2] == 0x00 && pos[3] == 0x50 &&
> -				   pos[4] == 0x43 && pos[4] == 0x04) {
> +				   pos[4] == 0x43 && pos[5] == 0x04) {
>  				lbs_deb_scan("got mesh IE\n");
>  				bss->mesh = 1;
>  			} else {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

