Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57844 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0ALXvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 18:51:31 -0500
MIME-Version: 1.0
In-Reply-To: <4B4CE9A0.3020902@pardus.org.tr>
References: <4B4CE9A0.3020902@pardus.org.tr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 12 Jan 2010 15:51:11 -0800
Message-ID: <43e72e891001121551n2caadccfy67db57ea0e3e97b0@mail.gmail.com>
Subject: Re: CONFIG_BT_CMTP is not checked in compat-wireless
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 12, 2010 at 1:29 PM, Ozan Çağlayan <ozan@pardus.org.tr> wrote:
> Hi,
>
> CONFIG_BT_CMTP depends on BT && BT_L2CAP && ISDN_CAPI but in config.mk there isn't an explicit check for
> those conditions. On a ISDN_CAPI disabled kernel this causes unresolved symbols as cmtp.ko is built
>
> Something like below fixes the problem (at least for CMTP case) by not compiling net/bluetooth/cmtp:
>
> # CONFIG_BT_CMTP depends on ISDN_CAPI
> ifneq ($(CONFIG_BT_CMTP),)
> CONFIG_BT_CMTP=m
> endif

I applied this change, thanks for the report.

  Luis
