Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36592 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932565AbdHWUwn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 16:52:43 -0400
Received: by mail-io0-f175.google.com with SMTP id p141so4512720iop.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Aug 2017 13:52:43 -0700 (PDT)
Date: Wed, 23 Aug 2017 15:52:40 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Update regulatory rules for Singapore
 (SG)
Message-ID: <20170823205240.ycyrszsvjugtosdi@ubuntu-xps13> (sfid-20170823_225247_141933_03E2608B)
References: <20170807081950.13327-1-sven.eckelmann@openmesh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170807081950.13327-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 07, 2017 at 10:19:50AM +0200, Sven Eckelmann wrote:
> 2.4GHz and the lower 5GHz band can now be use with up to 23dBm. But the DFS
> channels in general require TPC to be usable. Only 5150 - 5250 has an
> exception which allows the use of it without TPC when reducing the power to
> 20 dBm.
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>

Thanks for the patch, and apologies for the slow response. One comment
below.

> ---
> Please check this twice because this is my first attempt in converting an
> official regulatory document to an wireless-regdb entry.
> 
>  db.txt | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/db.txt b/db.txt
> index 0bc068e..df30f37 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -1078,12 +1078,17 @@ country SE: DFS-ETSI
>  	# 60 GHz band channels 1-4, ref: Etsi En 302 567
>  	(57000 - 66000 @ 2160), (40)
>  
> +# Source
> +# https://www.imda.gov.sg/~/media/imda/files/regulation%20licensing%20and%20consultations/ict%20standards/telecommunication%20standards/radio-comms/imdatssrd.pdf?la=en
> +# page 12-14
> +# The EIRP for 5250 – 5350 can be increased by 3dB if TPC is implemented.
>  country SG: DFS-FCC
> -	(2402 - 2482 @ 40), (20)
> -	(5170 - 5250 @ 80), (17), AUTO-BW
> -	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
> -	(5490 - 5730 @ 160), (24), DFS
> -	(5735 - 5835 @ 80), (30)
> +	(2400 - 2483.5 @ 40), (23)
> +	(5150 - 5250 @ 80), (23), AUTO-BW
> +	(5250 - 5350 @ 80), (20), DFS, AUTO-BW
> +	# 5470 - 5725 is only allowed when TPC is implemented
> +	# (5470 - 5725 @ 160), (30), DFS

I'm not sure that the lack of a specific provision for operating without
TPC in this range means that it cannot be used. As I understand it, TPC
would only result in a reduction in EIRP of 3 dB, so as long as we use
a power limit of half of the maximum allowed we will be safe.

If this is incorrect I'd appreciate it if someone more knowledgable on
the topic could chime in.

Thanks,
Seth
