Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2806 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab2FFLXe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 07:23:34 -0400
Message-ID: <4FCF3DA7.1080508@broadcom.com> (sfid-20120606_132337_921695_73C2B299)
Date: Wed, 6 Jun 2012 13:23:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 16/18] brcmsmac: do not call brcms_c_chipmatch() for
 non PCI
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-17-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-17-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> brcms_c_chipmatch() just works for PCIe devices and returns false for
> non PCIe devices. This stops brcms_ops_stop() from calling it when the
> devices is not a PCIe device.

Although this is true you may want to consider what this function
provides. The intent is to have a more accurate filter to determine
support the device by the driver, ie. more accurate than what is in the
driver device table.

So in brcms_c_chipmatch() we may want a host-type independent filtering
and validate bcma_device_id, bcma_chipinfo, and possibly bcma_boardinfo.

> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   22 +++++++++++++-------
>  1 file changed, 14 insertions(+), 8 deletions(-)

