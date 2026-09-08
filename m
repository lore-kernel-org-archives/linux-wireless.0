Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDC05616D9
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 23:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788910046; cv=none; b=IbgiHfIypWUy55XmMojEruC6AtYwXj7YRkkRJFnAG4TGJBuQ5OMkUTTKts8Olk0l0X6ypgMLZLE/VJHqEoPidcsFE8HZorvgmH5FuwDMkP7T3VavWw8yUBMpBQi43vru5fbp7SSAwvATyOthwV4OhhZ4qeSsGRV2o1MfJxqdOcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788910046; c=relaxed/simple;
	bh=N6xPxeeDD1+rW9ItN073rKWG7M7+wyFQpyHLEyL9ASc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJfWiKKqVN/+v/U4QSC2l5T1SGf+NiWogDPtwfsbjxNUTptA6UqcfgTo7wL2wadkhrJg2eJTQRSvGxskoHOwZLQwqQDlqk1mXRM6O8UggXi4vqaNHGdORXBpf13/NIxXPwPuQs4rG/+xdZtuLcU7z/RWGUj9gzx5H+Fw8tNaxX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ND0ob4+F; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ND0ob4+F"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso3771254f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 16:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788910042; x=1789514842; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2+WkL9jaW8QXmVg/SDuO0JulHvRp7DUDib3Bqt8318Q=;
        b=ND0ob4+FliCiwN1BYLFBJGVbhA7j0ruzCEWe03+QXOvLtnsf6Wy3zYih5Agn4luac3
         LogQTik2pAublCyC2qogUFP05g3ivAvkF7/jBkdbYd/z4Un+XLAkyoj0WOnG1gPqdrZg
         7NeEXOnTy9VcwTmF5qyCxXz1PQA3qzOXxzhJC29Z3IpeUKMT/5RtPEBexWgID7TRkXHN
         oTTziw370Exg0dTd+td11TJ0MNoTLEWpltEBUqnB+IP4OKSmEeZkMS0H1Qie/82urqnq
         /bQ5vyWdstmT3MHwOYUXXdbp0kdcY9Sa3U7koREz6P7bVwRP5ZyTdHybXxYjym8lUv9D
         gVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788910042; x=1789514842;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2+WkL9jaW8QXmVg/SDuO0JulHvRp7DUDib3Bqt8318Q=;
        b=kixD29X53Al1ysXqWuCdIN9IWBzEWKr3+swSLMo7G248ydzF/sqep1/ojmtBB4OqkV
         b70jfRV+B5YYK1bWHf12rp0ZFPfshFPWRMufSlj+5Y/WU8Yy/mne2gR3SY78ca6ZE9Xy
         9nalsxvmgxA/SKdx2fgMEsgGFTeFishU/8iKE4yEQxrx1KsKnIMA1NKJRp3oMRSiYHft
         qQvY5G81rSzL9oc3KCkHPs4QufjUGEKCoqoTySbwr9qJqAIJTd6zUL6wIZFYmUGOcb9Y
         8A4ojEyaR17xagjJfGmRfZVwDDfrtFcWQx9OI+T1XskOhIlNNzIoP6DTRwvvaJwla4c1
         2drw==
X-Forwarded-Encrypted: i=1; AKwUvBzPjyf7sLykuaPrbslFXwreq3CqOynXApFeVJlQ58FCsA9JANVl6WJG2WeBhxKPsh6PompzP4fJr7pXAhRo+Q==@vger.kernel.org
X-Gm-Message-State: AFuF++kCfjnlu0JqYevKrb4Yd5FpVlMisszWchjO7DWUU83gKgzQouCN
	Zza50xpmWCTP0RfTFHec9yAHo2MC71hLcvxpAILp2oF4WS6aBs9+LRDdtIs7kA==
X-Gm-Gg: AYBFou3BzUBlJmp22WP7D1e05/uZ99iy8KKnvedLiRNjTHZwjMxfGp0OmJ2P8QJooEs
	vJclvTKgVjrVtdahIBX229/TrNINzqcuK6/zmzQ5yR/aROUMFfq8iCQB2cncYKVWQ00P6TFuvpH
	VqKQE1zgBRV3MvY0m0j6dUJbskwo+EK/LSqw/Eb55NqXPHYcbpygWWRtRz8lGjbdeKhiEeA0tOs
	mOYZnhzTqR9Pc041gc+NkED/QI5ruGJgqJocQyKWv7JquFeIkrbsiRgwA/+W94kTpExnzqePcAg
	qZ173/h3Pzwkb8DMaIQyqVjIkCTG7lMQ0qIXwVdPx9+z9h3oBWsNqohSEjasTJscWvpTJFofUXA
	0BxArLLFGA2RomEZs4C51ZE+9RKcw0SRev4iKygOtmy5JXAcxeRMmxP7jlljb7YFs9xjuL/T6eQ
	fHKZwIcjVqMOhDwfI43Q/rheH7ZUrEgCwSYOCU4vYEfm3uJ8P7PFGUEg9ONBE1UHQT3Sg=
X-Received: by 2002:a05:6000:4b1b:b0:485:8c16:a35d with SMTP id ffacd0b85a97d-4858c16a720mr28882544f8f.53.1788910041804;
        Tue, 08 Sep 2026 16:27:21 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883a9234sm39201791f8f.14.2026.09.08.16.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 16:27:20 -0700 (PDT)
Message-ID: <92c0d2bf-afc9-46ce-9cd1-e8f5b11ed1c3@gmail.com>
Date: Wed, 9 Sep 2026 02:27:18 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next v2] wifi: rtw88: usb: Download the reserved page
 synchronously
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "i.mafifi17@gmail.com" <i.mafifi17@gmail.com>
References: <8efe15ee-bdea-428b-a636-3e801c22009f@gmail.com>
 <7debfdba54064dd18ce87e940939f26d@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <7debfdba54064dd18ce87e940939f26d@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/09/2026 06:39, Ping-Ke Shih wrote:
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>> From: Mohammed Afifi <i.mafifi17@gmail.com>
>>
>> In AP mode the reserved page (which contains the beacon) is downloaded
>> to the chip by rtw_fw_write_data_rsvd_page(). That function writes the
>> data via rtw_hci_write_data_rsvd_page() and then immediately polls the
>> hardware BCN_VALID bit to confirm the firmware accepted the beacon.
> 
> It looks like downloading reserved page uses usb_submit_urb() and
> read/write IO uses usb_control_msg(). Do they go via different USB pipes?
> 
> (I just want to know more USB)
> 

I think control messages have their own pipe. The reserved page and other
bulk transfers go through the bulk out pipes. (usb_submit_urb() can send
control messages too.)

>>
>> On USB, rtw_usb_write_data_rsvd_page() ends up in rtw_usb_write_port(),
>> which submits the URB with usb_submit_urb() and returns as soon as the
>> transfer is queued. The completion callback only frees the skb. As a
>> result the BCN_VALID poll can run while the beacon is still in flight
>> on the bus, and the poll times out even though the download itself is
>> fine.
>>
>> This shows up as:
>>
>>   rtw_8822bu: error beacon valid
>>   rtw_8822bu: failed to download drv rsvd page
>>
>> The failure is intermittent because the poll retries sometimes cover
>> the transfer time. It occurs in bursts when something triggers repeated
>> beacon updates, such as stations associating and disassociating.
>>
>> Fix this by adding a synchronous bulk-out helper that waits for the URB
>> to complete, and using it for the reserved page download. Only the
>> reserved page / beacon path is made synchronous; the normal data TX
>> path is left untouched, so throughput is unaffected.
>>
>> The reserved page download runs in process context under rtwdev->mutex,
>> so sleeping there is safe.
>>
>> Closes: https://github.com/lwfinger/rtw88/issues/451
>> Signed-off-by: Mohammed Afifi <i.mafifi17@gmail.com>
>> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
>> ---
>> v2:
>>  - Fix compilation error in rtw_usb_write_data_rsvd_page().
>> ---
>>  drivers/net/wireless/realtek/rtw88/usb.c | 91 +++++++++++++++++++++++-
>>  1 file changed, 90 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
>> index c90802919473..d31297954f22 100644
>> --- a/drivers/net/wireless/realtek/rtw88/usb.c
>> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
>> @@ -394,6 +394,71 @@ static int rtw_usb_write_port(struct rtw_dev *rtwdev, u8 qsel, struct sk_buff *s
>>         return ret;
>>  }
>>
>> +struct rtw_usb_write_data_sync_cb {
>> +       struct completion done;
>> +       int status;
>> +};
>> +
>> +static void rtw_usb_write_port_sync_complete(struct urb *urb)
>> +{
>> +       struct rtw_usb_write_data_sync_cb *cb = urb->context;
>> +
>> +       cb->status = urb->status;
>> +       complete(&cb->done);
>> +}
>> +
>> +/* Synchronous bulk-out that returns only after the data has actually been
> 
> First line of comment block should be empty, but I'd remove this commet.
> (see below)
> 
>> + * transferred to the device. Required for the reserved-page / beacon
>> + * download: the caller polls the hardware BCN_VALID bit immediately after
>> + * this returns, so the bytes must be on the chip by then. The normal async
>> + * TX path races that poll, which shows up as intermittent
>> + * "error beacon valid" / "failed to download drv rsvd page" in AP mode,
>> + * more often on 5 GHz where the larger beacon takes longer to transfer.
>> + */
>> +static int rtw_usb_write_port_sync(struct rtw_dev *rtwdev, u8 qsel,
>> +                                  struct sk_buff *skb)
>> +{
>> +       struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
>> +       struct usb_device *usbd = rtwusb->udev;
>> +       struct rtw_usb_write_data_sync_cb cb;
>> +       int ep = qsel_to_ep(rtwusb, qsel);
>> +       unsigned int pipe;
>> +       struct urb *urb;
>> +       int ret;
>> +
>> +       if (ep < 0)
>> +               return ep;
>> +
>> +       urb = usb_alloc_urb(0, GFP_KERNEL);
>> +       if (!urb)
>> +               return -ENOMEM;
>> +
>> +       init_completion(&cb.done);
>> +       cb.status = -EINPROGRESS;
>> +
>> +       pipe = usb_sndbulkpipe(usbd, rtwusb->out_ep[ep]);
>> +       usb_fill_bulk_urb(urb, usbd, pipe, skb->data, skb->len,
>> +                         rtw_usb_write_port_sync_complete, &cb);
>> +       urb->transfer_flags |= URB_ZERO_PACKET;
>> +
>> +       ret = usb_submit_urb(urb, GFP_KERNEL);
>> +       if (ret)
>> +               goto out;
>> +
>> +       /* 5 s matches the vendor driver's bulk-out timeout */
>> +       if (!wait_for_completion_timeout(&cb.done, msecs_to_jiffies(5000))) {
>> +               usb_kill_urb(urb);
>> +               ret = -ETIMEDOUT;
>> +       } else {
>> +               ret = cb.status;
>> +       }
>> +
>> +out:
>> +       usb_free_urb(urb);
>> +
>> +       return ret;
>> +}
>> +
>>  static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list)
>>  {
>>         struct rtw_dev *rtwdev = rtwusb->rtwdev;
>> @@ -543,13 +608,37 @@ static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
>>  {
>>         const struct rtw_chip_info *chip = rtwdev->chip;
>>         struct rtw_tx_pkt_info pkt_info = {0};
>> +       struct sk_buff *skb;
>> +       int ret;
>>
>>         pkt_info.tx_pkt_size = size;
>>         pkt_info.qsel = TX_DESC_QSEL_BEACON;
>>         pkt_info.offset = chip->tx_pkt_desc_sz;
>>         pkt_info.ls = true;
>>
> 
> I feel you can remove comment above rtw_usb_write_port_sync(), and just have
> a simple comment here to describe using _sync version of
> rtw_usb_write_port_sync(), because callers check BCN_VALID immediately. 
> 
>> -       return rtw_usb_write_data(rtwdev, &pkt_info, buf);
>> +       skb = dev_alloc_skb(chip->tx_pkt_desc_sz + size);
>> +       if (!skb)
>> +               return -ENOMEM;
>> +
>> +       skb_reserve(skb, chip->tx_pkt_desc_sz);
>> +       skb_put_data(skb, buf, size);
>> +       skb_push(skb, chip->tx_pkt_desc_sz);
>> +       memset(skb->data, 0, chip->tx_pkt_desc_sz);
>> +       rtw_tx_fill_tx_desc(rtwdev, &pkt_info, skb);
>> +       rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, skb->data);
>> +
>> +       /* Download the beacon/reserved page synchronously so that the caller's
>> +        * subsequent BCN_VALID poll observes the completed transfer instead of
>> +        * racing the async TX path.
>> +        */
>> +       ret = rtw_usb_write_port_sync(rtwdev, pkt_info.qsel, skb);
>> +       if (ret)
>> +               rtw_err(rtwdev, "failed to download rsvd page over USB, ret=%d\n",
>> +                       ret);
>> +
>> +       dev_kfree_skb_any(skb);
>> +
>> +       return ret;
> 
> Can we move this chunk into a function like rtw_usb_write_data_sync()?
> Or is it possible to extend arguments of rtw_usb_write_data()? Because they
> do many similar things.
> 
> But I don't ask to extend rtw_usb_write_port(), because
> rtw_usb_write_port_sync() is quite different; at least no many driver-specific
> settings.
> 

Looking at this more closely, I think rtw_usb_write_port() can be used
directly, with just a few changes in rtw_usb_write_data() and
rtw_usb_write_port_complete(). No need to add rtw_usb_write_port_sync()
and rtw_usb_write_port_sync_complete(), or to duplicate all that code
in rtw_usb_write_data_rsvd_page().

>>  }
>>
>>  static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
>> --
>> 2.55.0
> 

