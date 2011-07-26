Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38080 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1GZP57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 11:57:59 -0400
Received: by iyb12 with SMTP id 12so671264iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 08:57:58 -0700 (PDT)
Message-ID: <4E2EE403.5090207@lwfinger.net> (sfid-20110726_175802_714882_697928D0)
Date: Tue, 26 Jul 2011 10:57:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] b43legacy: report core number
References: <20110726153648.24611.49190.stgit@mj.roinet.com>
In-Reply-To: <20110726153648.24611.49190.stgit@mj.roinet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2011 10:36 AM, Pavel Roskin wrote:
> Signed-off-by: Pavel Roskin<proski@gnu.org>
> ---
>   0 files changed, 0 insertions(+), 0 deletions(-)

Very informative diffstat! :)

>
> diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
> index ffa4671..224991a 100644
> --- a/drivers/net/wireless/b43legacy/main.c
> +++ b/drivers/net/wireless/b43legacy/main.c
> @@ -3785,7 +3785,8 @@ static int b43legacy_wireless_init(struct ssb_device *dev)
>   	INIT_WORK(&wl->beacon_update_trigger, b43legacy_beacon_update_trigger_work);
>
>   	ssb_set_devtypedata(dev, wl);
> -	b43legacyinfo(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
> +	b43legacyinfo(wl, "Broadcom %04X WLAN found (core revision %u)\n",
> +		      dev->bus->chip_id, dev->id.revision);
>   	err = 0;
>   out:
>   	return err;

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

