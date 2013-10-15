Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:37316 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3JOTHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 15:07:09 -0400
Received: by mail-lb0-f173.google.com with SMTP id o14so7193740lbi.18
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 12:07:08 -0700 (PDT)
Message-ID: <525D921C.2030709@cogentembedded.com> (sfid-20131015_210741_911733_2F3AF04C)
Date: Tue, 15 Oct 2013 23:06:04 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Kefeng Wang <wangkefeng.wang@huawei.com>
CC: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Francois Romieu <romieu@fr.zoreil.com>,
	Ben Hutchings <bhutchings@solarflare.com>,
	Chas Williams <chas@cmf.nrl.navy.mil>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Samuel Ortiz <samuel@sortiz.org>,
	Paul Mackerras <paulus@samba.org>,
	Oliver Neukum <oneukum@suse.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	David Vrabel <david.vrabel@citrix.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Michael S. Tsirkin" <mst@redhat.com>, netfilter@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	guohanjun@huawei.com
Subject: Re: [PATCH 14/18] net: usb: use wrapper functions of net_ratelimit()
 to simplify code
References: <1381837514-50660-1-git-send-email-wangkefeng.wang@huawei.com> <1381837514-50660-15-git-send-email-wangkefeng.wang@huawei.com>
In-Reply-To: <1381837514-50660-15-git-send-email-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 10/15/2013 03:45 PM, Kefeng Wang wrote:

> net_ratelimited_function() is called to simplify code.

> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   drivers/net/usb/usbnet.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index bf94e10..edf81de 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -450,8 +450,8 @@ void usbnet_defer_kevent (struct usbnet *dev, int work)
>   {
>   	set_bit (work, &dev->flags);
>   	if (!schedule_work (&dev->kevent)) {
> -		if (net_ratelimit())
> -			netdev_err(dev->net, "kevent %d may have been dropped\n", work);
> +		net_ratelimited_function(netdev_err, dev->net,
> +			"kevent %d may have been dropped\n", work);

    The continuation line should start under 'netdev_err'. Same about the 
other patches where you didn't change the indentation of the continuation 
lines though you should have.

WBR, Sergei

