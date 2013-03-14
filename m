Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f176.google.com ([209.85.160.176]:45491 "EHLO
	mail-gh0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3CNCh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 22:37:56 -0400
Received: by mail-gh0-f176.google.com with SMTP id f16so318601ghb.21
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 19:37:55 -0700 (PDT)
Message-ID: <51413800.6050300@lwfinger.net> (sfid-20130314_033807_899671_DAA6EB25)
Date: Wed, 13 Mar 2013 21:37:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: isedev@gmail.com
CC: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4312 / b43 DMA transmission sequence errors
References: <1695808.c7XUjJpf0R@wks001.ise.net> <51411838.6070402@lwfinger.net> <1476129.oNtxuF3Ght@wks001.ise.net>
In-Reply-To: <1476129.oNtxuF3Ght@wks001.ise.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2013 08:06 PM, ISE Development wrote:

Please do not drop the mailing lists from the Cc list. That should always be 
true, but very important here as there are other developers that should see and 
comment on this change.

> On Wednesday 13 Mar 2013 19:22:16 you wrote:
>> On 03/13/2013 05:31 PM, ISE Development wrote:
>>> Hi,
>>>
>>> The wireless connection keeps failing shortly after being established. Up to now, I've tracked it down to a DMA transmission sequence error in ring 3. Beyond that, I cannot say...
>>>
>>> Happy to provide further information and to test any potential fixes.
>>
>> Have you applied the patch that increases the number of RX ring slots? It is
>> commit ccae0e50c16a7f and was committed on Feb 17, 2013. That fixed a lot of
>> problems on the BCM4312. It seems that the firmware fails to check for overflow
>> of the RX ring and blindly corrupts things.
>>
>> Larry
>>
>>
>
> Hi,
>
> I am afraid so. The problem occurs with the latest code from linux-wireless (which includes the patch).
>
> The failures do not appear all that random, though. Some observations:
>
> 1. Failures (so far) only occur on two slots (138 and 208) on TX rings 1 and 3.
> 2. This can happen even without a preceeding 'invalid cookie' error.
> 3. There is _always_ an invalid cookie '0x0000' for ring 3 slot 138 when starting the driver and establishing the link.
> 4. After that, the invalid cookie has a different value every time.
> 5. The invalid cookie occurs far less frequently than the out of order error.
>
> This is an example of reported errors during a ~3.8Mb download at 640KB/s:
>
> [22803.075774] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 208, but got 210
> [22825.120354] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 208, but got 210
> [22826.752905] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 208, but got 210
> [22827.156976] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 138, but got 140
> [22827.302840] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 208, but got 210
> [22827.699721] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 138, but got 140
> [22827.855924] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 208, but got 210
> [22828.244330] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 138, but got 140
> [22828.385746] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 208, but got 210
> [22828.777014] b43-phy0 debug: TX-status contains invalid cookie: 0x2A0A
> [22828.781611] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 138, but got 140
> [22828.935206] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 208, but got 210
> [22829.330987] b43-phy0 debug: TX-status contains invalid cookie: 0xC90A
> [22829.334384] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 138, but got 140
> [22829.472203] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 208, but got 210
> [22829.856035] b43-phy0 debug: TX-status contains invalid cookie: 0x770C
> [22829.860472] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 138, but got 140
> [22830.416641] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 138, but got 140
>
> I've hacked the driver to 'skip' one header and data frame if receiving an interrupt for the first slot + 2. It's not pretty and I have literally no idea if it will causes other problems, but it has allowed me to keep the Wifi connection up for a little over 3 hours now (as compared to the 45 seconds previously). It does not appear to be corrupting the data stream (checked by download large signed binaries and verifying the signature) and as far as my limited knowledge can tell, it should not be causing a memory leak.
>
> The patch is listed below, for reference. However, I do not claim that it is valid, safe or even reasonsable. It does provide me with much needed relief though.
>
> The diff is against the current head of linville/wireless-testing.git (d41d9c7419e3ac9c81841f43bbd7639dd0a5819e).
>
> diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
> index 38bc5a7..a3f787b 100644
> --- a/drivers/net/wireless/b43/dma.c
> +++ b/drivers/net/wireless/b43/dma.c
> @@ -1489,6 +1489,7 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
>          struct b43_dmadesc_meta *meta;
>          int slot, firstused;
>          bool frame_succeed;
> +       int skip;
>
>          ring = parse_cookie(dev, status->cookie, &slot);
>          if (unlikely(!ring))
> @@ -1501,15 +1502,24 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
>          firstused = ring->current_slot - ring->used_slots + 1;
>          if (firstused < 0)
>                  firstused = ring->nr_slots + firstused;
> +
> +       skip = 0;
>          if (unlikely(slot != firstused)) {
>                  /* This possibly is a firmware bug and will result in
>                   * malfunction, memory leaks and/or stall of DMA functionality. */
>                  b43dbg(dev->wl, "Out of order TX status report on DMA ring %d. "
>                         "Expected %d, but got %d\n",
>                         ring->index, firstused, slot);
> -               return;
> +               if(slot == firstused + 2) {
> +                       slot = firstused;
> +                       skip = 2;
> +               } else {
> +                       return;
> +               }
>          }
>
> +    b43dbg(dev->wl, "DMA ring %d slot %d.\n", ring->index, slot);
> +
>          ops = ring->ops;
>          while (1) {
>                  B43_WARN_ON(slot < 0 || slot >= ring->nr_slots);
> @@ -1522,6 +1532,7 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
>                                 slot, firstused, ring->index);
>                          break;
>                  }
> +
>                  if (meta->skb) {
>                          struct b43_private_tx_info *priv_info =
>                                  b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
> @@ -1552,7 +1563,15 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
>                           * Call back to inform the ieee80211 subsystem about
>                           * the status of the transmission.
>                           */
> -                       frame_succeed = b43_fill_txstatus_report(dev, info, status);
> +                       if(!skip)
> +                       {
> +                               frame_succeed = b43_fill_txstatus_report(dev, info, status);
> +                       }
> +                       else
> +                       {
> +                               struct b43_txstatus fake = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
> +                               frame_succeed = b43_fill_txstatus_report(dev, info, &fake);
> +                       }
>   #ifdef CONFIG_B43_DEBUG
>                          if (frame_succeed)
>                                  ring->nr_succeed_tx_packets++;
> @@ -1580,12 +1599,14 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
>                  /* Everything unmapped and free'd. So it's not used anymore. */
>                  ring->used_slots--;
>
> -               if (meta->is_last_fragment) {
> +               if (meta->is_last_fragment && !skip) {
>                          /* This is the last scatter-gather
>                           * fragment of the frame. We are done. */
>                          break;
>                  }
>                  slot = next_slot(ring, slot);
> +               if(skip > 0)
> +                       --skip;
>          }
>          if (ring->stopped) {
>                  B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);

I am testing the patch on BCM4312 and other cards.

Larry


