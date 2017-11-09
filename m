Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:48233 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753451AbdKIL6X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 06:58:23 -0500
Received: by mail-wr0-f195.google.com with SMTP id 15so5359672wrb.5
        for <linux-wireless@vger.kernel.org>; Thu, 09 Nov 2017 03:58:22 -0800 (PST)
Subject: Re: [PATCH] rt2x00usb: mark device removed when get ENOENT usb error
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
References: <20171109105917.GA3206@redhat.com>
From: Richard Genoud <richard.genoud@gmail.com>
Message-ID: <13ad0557-870c-0e16-9663-374470598415@gmail.com> (sfid-20171109_125826_796943_6BFEB58A)
Date: Thu, 9 Nov 2017 12:58:10 +0100
MIME-Version: 1.0
In-Reply-To: <20171109105917.GA3206@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2017 11:59, Stanislaw Gruszka wrote:
> ENOENT usb error mean "specified interface or endpoint does not exist or
> is not enabled". Mark device not present when we encounter this error
> similar like we do with ENODEV error.
> 
> Otherwise we can have infinite loop in rt2x00usb_work_rxdone(), because
> we remove and put again RX entries to the queue infinitely.
> 
> We can have similar situation when submit urb will fail all the time
> with other error, so we need consider to limit number of entries
> processed by rxdone work. But for now, since the patch fixes
> reproducible soft lockup issue on single processor systems
> and taken ENOENT error meaning, let apply this fix.
> 
> Patch adds additional ENOENT check not only in rx kick routine, but
> also on other places where we check for ENODEV error.
> 
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
> Debugged-by: Richard Genoud <richard.genoud@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Tested-by: Richard Genoud <richard.genoud@gmail.com>
(on 4.14-rc8)

This is working like a charm now !

Thanks !!

Richard.

> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> index e2f4f5778267..086aad22743d 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> @@ -57,7 +57,7 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
>  		if (status >= 0)
>  			return 0;
>  
> -		if (status == -ENODEV) {
> +		if (status == -ENODEV || status == -ENOENT) {
>  			/* Device has disappeared. */
>  			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
>  			break;
> @@ -321,7 +321,7 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
>  
>  	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
>  	if (status) {
> -		if (status == -ENODEV)
> +		if (status == -ENODEV || status == -ENOENT)
>  			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
>  		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
>  		rt2x00lib_dmadone(entry);
> @@ -410,7 +410,7 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
>  
>  	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
>  	if (status) {
> -		if (status == -ENODEV)
> +		if (status == -ENODEV || status == -ENOENT)
>  			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
>  		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
>  		rt2x00lib_dmadone(entry);
> 
