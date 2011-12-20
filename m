Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63041 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1LTWRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 17:17:07 -0500
Date: Tue, 20 Dec 2011 14:16:57 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Gabor Juhos <juhosg@openwrt.org>
CC: <mcgrof@infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 15/15] initvals: add script for regenerating ath9k header
 files
Message-ID: <20111220221657.GF15071@tux> (sfid-20111220_231711_814312_F7FFD0E8)
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
 <1324329900-3923-16-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1324329900-3923-16-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2011 at 10:25:00PM +0100, Gabor Juhos wrote:
> The script helps to regenerate initval header files for ath9k.
> 
> screenshot:
> $ ./gen_ath9k_headers.sh ar5008
> ar5008 => ar5008_initvals.h
> 
> $ ./gen_ath9k_headers.sh
> ar5008 => ar5008_initvals.h
> ar9001 => ar9001_initvals.h
> ar9002 => ar9002_initvals.h
> ar9003-2p2 => ar9003_2p2_initvals.h
> ar9330-1p1 => ar9330_1p1_initvals.h
> ar9330-1p2 => ar9330_1p2_initvals.h
> ar9485 => ar9485_initvals.h
> ar9580-1p0 => ar9580_1p0_initvals.h
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  gen_ath9k_headers.sh |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
>  create mode 100755 gen_ath9k_headers.sh
> 
> diff --git a/gen_ath9k_headers.sh b/gen_ath9k_headers.sh
> new file mode 100755
> index 0000000..fb7c313
> --- /dev/null
> +++ b/gen_ath9k_headers.sh
> @@ -0,0 +1,36 @@
> +#!/bin/sh
> +
> +gen_ath9k_header()
> +{
> +	local family="$1"
> +	local ath9k_hdr
> +
> +	case $family in
> +	ar5008 |\
> +	ar9001 |\
> +	ar9002 |\
> +	ar9003-2p2|\
> +	ar9330-1p1|\
> +	ar9330-1p2|\
> +	ar9485|\
> +	ar9580-1p0)
> +		ath9k_hdr="$(echo $family | tr '-' '_')_initvals.h"
> +		;;
> +	*)
> +		echo "unknown family: '$family'" 1>&2
> +		return 1
> +		;;
> +	esac
> +	

The above line had a trailing tab, apart from that, everything looks
great, thanks so much! Applied and pushed!

  Luis
