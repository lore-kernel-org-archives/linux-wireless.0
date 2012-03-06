Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1945 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030660Ab2CFN1x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 08:27:53 -0500
Message-ID: <4F5610C2.3030101@broadcom.com> (sfid-20120306_142802_259067_FD44F0B5)
Date: Tue, 6 Mar 2012 14:27:30 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"m@bues.ch" <m@bues.ch>,
	"ralf@linux-mips.org" <ralf@linux-mips.org>
Subject: Re: [PATCH v2 07/11] bcma: add support for sprom not found on
 the device
References: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
 <1330386974-4056-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1330386974-4056-8-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2012 12:56 AM, Hauke Mehrtens wrote:
>   	if (!bus->drv_cc.core)
>   		return -EOPNOTSUPP;
>
> -	if (!(bus->drv_cc.capabilities&  BCMA_CC_CAP_SPROM))
> -		return -ENOENT;
> -
> -	if (bus->drv_cc.core->id.rev>= 32) {
> -		sromctrl = bcma_read32(bus->drv_cc.core, BCMA_CC_SROM_CONTROL);
> -		if (!(sromctrl&  BCMA_CC_SROM_CONTROL_PRESENT))
> -			return -ENOENT;
> +	if (!bcma_is_sprom_available(bus)) {
> +		/*
> +		 * Maybe there is no SPROM on the device?
> +		 * Now we ask the arch code if there is some sprom
> +		 * available for this device in some other storage.
> +		 */
> +		err = bcma_fill_sprom_with_fallback(bus,&bus->sprom);
> +		if (err) {
> +			pr_warn("Using fallback SPROM failed (err %d)\n", err);

Hi Hauke,

I just noticed in this patch that the code continues when sprom fallback 
fails. Does that make sense? I have corrected it in my OTP patch. So if 
you agree or disagree you can comment on that patch.

> +		} else {
> +			pr_debug("Using SPROM revision %d provided by"
> +				 " platform.\n", bus->sprom.revision);
> +			return 0;
> +		}
>   	}
>
>   	sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),

Gr. AvS

