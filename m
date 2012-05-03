Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2ECS5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 14:57:10 -0400
Message-ID: <1336071426.5167.6.camel@jlt3.sipsolutions.net> (sfid-20120503_205714_436901_9690A636)
Subject: Re: [RFC c-w 2/4] compat-wireless: also copy include/generated/
 from compat
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Date: Thu, 03 May 2012 20:57:06 +0200
In-Reply-To: <1335463674-13003-5-git-send-email-hauke@hauke-m.de> (sfid-20120426_200823_435891_885FB2C4)
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
	 <1335463674-13003-5-git-send-email-hauke@hauke-m.de>
	 (sfid-20120426_200823_435891_885FB2C4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-26 at 20:07 +0200, Hauke Mehrtens wrote:
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  scripts/admin-update.sh |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
> index fd1fa87..7147ff1 100755
> --- a/scripts/admin-update.sh
> +++ b/scripts/admin-update.sh
> @@ -283,6 +283,7 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
>  	include/trace \
>  	include/pcmcia \
>  	include/crypto \
> +	include/generated \

Are you sure we want this? It seems to me that most generated things
like asm-offsets etc. need to be taken from the *target* kernel.

johannes

