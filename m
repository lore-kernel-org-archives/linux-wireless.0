Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3517 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab1FBOwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 10:52:31 -0400
Message-ID: <4DE7A3A0.30109@broadcom.com> (sfid-20110602_165236_511305_603C84AF)
Date: Thu, 2 Jun 2011 16:52:16 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] bcma: read SPROM and extract MAC from it
References: <1306973331-3959-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1306973331-3959-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02/2011 02:08 AM, Rafał Miłecki wrote:
> In case of BCMA cards SPROM is located in the ChipCommon core, it is
> not mapped as separated host window. So far we have met only SPROMs rev
> 8.
> SPROM layout seems to be the same as for SSB buses, so we decided to
> share SPROM struct and some defines.
> For now we extract MAC address only, this can be improved of course.
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>
> +/**************************************************
> + * Validation.
> + **************************************************/
> +
> +static inline u8 bcma_crc8(u8 crc, u8 data)
> +{

Somehow this crc8 looks quite familiar to me ;-) I send out a patch to 
John providing a crc8 as library module so you could consider using 
that. It will probably end up in wireless-testing before this patch (if 
accepted that is).

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


