Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:57709 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZAMWqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 17:46:23 -0500
Received: by ewy10 with SMTP id 10so328434ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 14:46:20 -0800 (PST)
To: Rami Rosen <ramirose@gmail.com>
Subject: Re: [PATCH] rt2x00: fix a wrong parameter for __test_and_clear_bit() in  rt2x00rfkill_free().
Date: Tue, 13 Jan 2009 23:46:17 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
References: <eb3ff54b0901131400x64a4812fje2ee233c37546c1e@mail.gmail.com>
In-Reply-To: <eb3ff54b0901131400x64a4812fje2ee233c37546c1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901132346.18092.IvDoorn@gmail.com> (sfid-20090113_234627_818433_23EA7CD6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 January 2009, Rami Rosen wrote:
> When running modprobe rt73usb, and then rmmod rt73usb, and then
> iwconfig, the wlan0 device does not disappear. When repeating this
> process again, we get a kernel Oops errors and "BUG: unable to handle
> kernel paging request..." message in the kernel log.
> 
> The reason for this is that there is an error in rt2x00rfkill_free(),
> which is called in the process of removing the device
> (rt2x00lib_remove_dev() in rt2x00dev.c).
> rt2x00rfkill_free() clears the RFKILL_STATE_ALLOCATED bit , which is
> bit number 1 () in rt2x00dev->flags instead of in
> rt2x00dev->rfkill_state. As a result, when checking the
> DEVICE_STATE_REGISTERED_HW bit (bit number 1 in rt2x00dev->flags) in
> rt2x00lib_remove_hw() it is **unset**, and we wrongly **don't** call
> ieee80211_unregister_hw().
> 
> This patch corrects this: the parameter for __test_and_clear_bit() in
> rt2x00rfkill_free() should be &rt2x00dev->rfkill_state and not
> &rt2x00dev->flags.
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> (wireless-testing).
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> index 0b089ec..735a22d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> @@ -118,7 +118,7 @@ void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
> 
>  void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
>  {
> -	if (!__test_and_clear_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->flags))
> +	if (!__test_and_clear_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
>  		return;
> 
>  	input_free_polled_device(rt2x00dev->rfkill_poll_dev);
> 


