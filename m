Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62997 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0JYMjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 08:39:16 -0400
Received: by iwn10 with SMTP id 10so773185iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 05:39:16 -0700 (PDT)
Message-ID: <4CC57A82.7030300@lwfinger.net>
Date: Mon, 25 Oct 2010 07:39:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: rfkill: use status register based on core revision
 not (PHY's)
References: <1287779045-20257-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1287779045-20257-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2010 03:24 PM, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This makes my N-PHY radio at least running (no scanning results so far). The
> same register is used by wl on this device.
> ---
>  drivers/net/wireless/b43/rfkill.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
> index 78016ae..d2734c9 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -28,7 +28,7 @@
>  /* Returns TRUE, if the radio is enabled in hardware. */
>  bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
>  {
> -	if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
> +	if (dev->dev->id.revision >= 3) {
>  		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
>  		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
>  			return 1;

Over the weekend, I was able to test this patch using all my b43 hardware. There
were no problems.

Despite having no problems, I still NACK the patch for the reason that b43 only
applies to devices with id.revision >= 5, thus the revised "if" will always be
true. The patch should be rewritten as only b43legacy needs to test the 802.11
core revision.

Larry
