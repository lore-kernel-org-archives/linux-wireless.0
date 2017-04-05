Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:19480 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753484AbdDEIW2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 04:22:28 -0400
Date: Wed, 5 Apr 2017 10:22:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: linux-wireless@vger.kernel.org,
        Michael Thalmeier <michael.thalmeier@hale.at>
Subject: Re: [PATCH] NFC: pn533: use constant off-stack buffer for sending
 acks
Message-ID: <20170405082222.GE2136@zurbaran.ger.intel.com> (sfid-20170405_102708_169648_F1F303E1)
References: <fff9efce3143554d81335e7bff3ae33ef2b34147.1491282239.git.mirq-linux@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <fff9efce3143554d81335e7bff3ae33ef2b34147.1491282239.git.mirq-linux@rere.qmqm.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michał,

On Tue, Apr 04, 2017 at 07:09:10AM +0200, Michał Mirosław wrote:
> This fixes following WARNing:
> 
> usb 3-2.4.1: NFC: Exchanging data failed (error 0x13)
> llcp: nfc_llcp_recv: err -5
> llcp: nfc_llcp_symm_timer: SYMM timeout
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 26397 at .../drivers/usb/core/hcd.c:1584 usb_hcd_map_urb_for_dma+0x370/0x550
> transfer buffer not dma capable
> [...]
> Workqueue: events nfc_llcp_timeout_work [nfc]
> Call Trace:
>  ? dump_stack+0x46/0x5a
>  ? __warn+0xb9/0xe0
>  ? warn_slowpath_fmt+0x5a/0x80
>  ? usb_hcd_map_urb_for_dma+0x370/0x550
>  ? usb_hcd_submit_urb+0x2fb/0xa60
>  ? dequeue_entity+0x3f2/0xc30
>  ? pn533_usb_send_ack+0x5d/0x80 [pn533_usb]
>  ? pn533_usb_abort_cmd+0x13/0x20 [pn533_usb]
>  ? pn533_dep_link_down+0x32/0x70 [pn533]
>  ? nfc_dep_link_down+0x87/0xd0 [nfc]
> [...]
> usb 3-2.4.1: NFC: Exchanging data failed (error 0x13)
> llcp: nfc_llcp_recv: err -5
> llcp: nfc_llcp_symm_timer: SYMM timeout
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> ---
> 
> Patch against stable linux-4.10.8.
Could you please rebase against nfc-next ?


> diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
> index 1dc89248e58e..35f410797fe4 100644
> --- a/drivers/nfc/pn533/i2c.c
> +++ b/drivers/nfc/pn533/i2c.c
> @@ -49,10 +49,11 @@ struct pn533_i2c_phy {
>  
>  static int pn533_i2c_send_ack(struct pn533 *dev, gfp_t flags)
>  {
> -	struct pn533_i2c_phy *phy = dev->phy;
> -	struct i2c_client *client = phy->i2c_dev;
> -	u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
> +	static const u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
>  	/* spec 6.2.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
> +
> +	struct pn533_i2c_phy *phy = dev->phy;
> +	struct i2c_client *client = phy->i2c_dev;
Can we please not move those 2 declarations to make the patch less
verbose ?


> diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
> index 33ed78be2750..09e1db8e8dc3 100644
> --- a/drivers/nfc/pn533/usb.c
> +++ b/drivers/nfc/pn533/usb.c
> @@ -147,12 +147,13 @@ static int pn533_submit_urb_for_ack(struct pn533_usb_phy *phy, gfp_t flags)
>  
>  static int pn533_usb_send_ack(struct pn533 *dev, gfp_t flags)
>  {
> -	struct pn533_usb_phy *phy = dev->phy;
> -	u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
> +	static const u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
>  	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
> +
> +	struct pn533_usb_phy *phy = dev->phy;
Ditto.

Cheers,
Samuel.
