Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:64699 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZA1B0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 20:26:48 -0500
Received: by gxk14 with SMTP id 14so5883375gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 17:26:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c4d76b3b0901271610g7868913egc22de8f6577caee7@mail.gmail.com>
References: <c4d76b3b0901261942v23a84b65jab3cf59215c45307@mail.gmail.com>
	 <c4d76b3b0901261944r13baf3d7o4a06f0372c88f087@mail.gmail.com>
	 <c4d76b3b0901271610g7868913egc22de8f6577caee7@mail.gmail.com>
Date: Tue, 27 Jan 2009 20:26:46 -0500
Message-ID: <c4d76b3b0901271726v7c74e5bfpeb3bdb02e68c271d@mail.gmail.com> (sfid-20090128_022652_986352_F34D843A)
Subject: Re: p54usb and 2.13.24.0 Firmware fail to probe 1st generation
	(ISL3886 + net2280)
From: Jason Andryuk <jandryuk@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increasing the timeout to 9000 still results in -ETIMEDOUT.  Could the
firmware just be incompatible with the device?

Jason

On Tue, Jan 27, 2009 at 7:10 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
> With the below patch, -ETIMEDOUT is returned from usb_interrupt_msg in
> addition to alen != sizeof(__le32)
>
> [   53.876103] usb 4-2: new high speed USB device using ehci_hcd and address 2
> [   54.008792] usb 4-2: configuration #1 chosen from 1 choice
> [   54.131230] usb 4-2: firmware: requesting isl3886usb
> [   54.148759] phy1: p54 detected a LM86 firmware
> [   54.148765] p54: rx_mtu reduced from 3240 to 2392
> [   54.148770] phy1: FW rev 2.13.24.0 - Softmac protocol 5.9
> [   54.148775] phy1: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> [   56.316196] usb 4-2: (p54usb) err=-110, alen=0, size=4
> [   56.316311] p54usb: probe of 4-2:1.0 failed with error -110
> [   56.316356] usbcore: registered new interface driver p54usb
>
> diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb
> index 9539ddc..3e26085 100644
> --- a/drivers/net/wireless/p54/p54usb.c
> +++ b/drivers/net/wireless/p54/p54usb.c
> @@ -652,6 +652,7 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw
>
>        err = p54_parse_firmware(dev, fw_entry);
>        if (err) {
> +               dev_err(&priv->udev->dev, "(p54usb) cannot parse firmware\n");
>                kfree(buf);
>                release_firmware(fw_entry);
>                return err;
> @@ -858,8 +859,11 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw
>        err = usb_interrupt_msg(priv->udev,
>                                usb_rcvbulkpipe(priv->udev, P54U_PIPE_INT),
>                                buf, sizeof(__le32), &alen, 1000);
> -       if (err || alen != sizeof(__le32))
> +       if (err || alen != sizeof(__le32)) {
> +               dev_err(&priv->udev->dev, "(p54usb) err=%d, alen=%d, size=%d\n",
> +                       err, alen, sizeof(__le32));
>                goto fail;
> +       }
>
>        P54U_READ(NET2280_DEV_U32, &devreg->int_ident);
>        P54U_WRITE(NET2280_DEV_U32, &devreg->int_ack, reg);
>
