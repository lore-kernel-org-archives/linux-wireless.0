Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:43419 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeHWWvj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 18:51:39 -0400
Received: by mail-oi0-f66.google.com with SMTP id b15-v6so11217161oib.10
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2018 12:20:31 -0700 (PDT)
Subject: Re: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
To: prabhu <d.praabhu@gmail.com>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org
References: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <0605251e-9a16-ef45-86d2-60c905351cc5@lwfinger.net> (sfid-20180823_212035_328748_3F6E3DB5)
Date: Thu, 23 Aug 2018 14:20:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------E88DA50CB14092C0E73268C7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------E88DA50CB14092C0E73268C7
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/23/2018 12:30 PM, prabhu wrote:
> Hi,
> 
> BCM 4312 wifi card stopped working from kernel version 4.18
> After boot up it tries to reconnect for few times and after that it
> disconnected completely.
> 
> Here is the snippet from dmesg:
> [ 70.826051] [drm:radeon_cs_parser_relocs [radeon]] *ERROR* gem object
> lookup failed 0xd
> [ 70.826090] [drm:radeon_cs_ioctl [radeon]] *ERROR* Failed to parse
> relocation -2!
> [ 238.066341] b43-phy0: Controller RESET (Out of order TX) ...
> [ 238.306116] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
> [ 245.443095] b43-phy0: Controller restarted
> [ 285.552662] wlan0: deauthenticated from 98:de:d0:4b:e6:f6 (Reason:
> 6=CLASS2_FRAME_FROM_NONAUTH_STA)
> [ 285.639719] wlan0: authenticate with 98:de:d0:4b:e6:f6
> [ 285.656291] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
> [ 285.658957] wlan0: authenticated
> [ 285.662386] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
> [ 285.665581] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
> status=0 aid=2)
> [ 285.666396] wlan0: associated
> [ 309.348063] b43-phy0: Controller RESET (Out of order TX) ...
> [ 309.592485] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
> [ 316.742829] b43-phy0: Controller restarted
> [ 329.268570] perf: interrupt took too long (2513 > 2500), lowering
> kernel.perf_event_max_sample_rate to 79500
> [ 400.542426] wlan0: deauthenticated from 98:de:d0:4b:e6:f6 (Reason:
> 6=CLASS2_FRAME_FROM_NONAUTH_STA)
> [ 400.636523] wlan0: authenticate with 98:de:d0:4b:e6:f6
> [ 400.652666] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
> [ 400.655070] wlan0: authenticated
> [ 400.655447] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
> [ 400.658583] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
> status=0 aid=2)
> [ 400.659276] wlan0: associated
> [ 412.256359] perf: interrupt took too long (3246 > 3141), lowering
> kernel.perf_event_max_sample_rate to 61500
> [ 555.832079] b43-phy0: Controller RESET (Out of order TX) ...
> [ 556.082050] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
> [ 563.172269] b43-phy0: Controller restarted
> [ 619.628212] perf: interrupt took too long (4066 > 4057), lowering
> kernel.perf_event_max_sample_rate to 48900
> [ 766.268349] wlan0: deauthenticated from 98:de:d0:4b:e6:f6 (Reason:
> 6=CLASS2_FRAME_FROM_NONAUTH_STA)
> [ 766.317708] wlan0: authenticate with 98:de:d0:4b:e6:f6
> [ 766.338515] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
> [ 766.345731] wlan0: authenticated
> [ 766.347959] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
> [ 766.352674] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
> status=0 aid=2)
> [ 766.353351] wlan0: associated
> [ 801.234010] perf: interrupt took too long (5097 > 5082), lowering
> kernel.perf_event_max_sample_rate to 39000
> [ 1780.122837] perf: interrupt took too long (6979 > 6371), lowering
> kernel.perf_event_max_sample_rate to 28500
> [ 2347.465072] b43-phy0: Controller RESET (Out of order TX) ...
> [ 2347.705572] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
> [ 2354.735641] b43-phy0: Controller restarted
> [ 2388.784785] wlan0: deauthenticated from 98:de:d0:4b:e6:f6 (Reason:
> 6=CLASS2_FRAME_FROM_NONAUTH_STA)
> [ 2388.901388] wlan0: authenticate with 98:de:d0:4b:e6:f6
> [ 2388.918575] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
> [ 2388.920893] wlan0: authenticated
> [ 2388.921243] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
> [ 2388.924310] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
> status=0 aid=2)
> [ 2388.925336] wlan0: associated
> [ 2973.297286] b43-phy0: Controller RESET (Out of order TX) ...
> [ 2973.532792] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
> [ 2980.496495] b43-phy0: Controller restarted
> [ 5306.648339] wlan0: deauthenticating from 98:de:d0:4b:e6:f6 by local
> choice (Reason: 3=DEAUTH_LEAVING)
> [ 5306.909377] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
> [ 5313.899248] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 5320.225907] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
> [ 5327.189103] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 5328.567334] wlan0: authenticate with 98:de:d0:4b:e6:f6
> [ 5328.599382] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
> [ 5328.601751] wlan0: authenticated
> [ 5328.602238] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
> [ 5328.605468] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
> status=0 aid=2)
> [ 5328.606369] wlan0: associated
> [ 5328.615757] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [ 5348.732714] b43-phy0: Controller RESET (Out of order TX) ...
> 
> The following commits introduce this regression in 4.18
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=66cffd6daab76caebab26eb803b92182414fc182
> 
> I verified that in two ways:
> 1. Downgrade the kernel to 4.17.14 - Fixes the Issue
> 2. Revert that commit in 4.18.4 - Fixes the Issue

Prabhu,

Thanks for your diagnosis of the problem.

Unfortunately, I was not able to reproduce your problem with my BCM4312 using 
kernel 4.18. The only difference  I could see is that I am using firmware 
version 784.2 rather than 666.2, which you are using. I do not think there was 
any difference for LP cores, thus I doubt that the differing versions makes any 
difference, but I would like you to see if you can update the firmware. If your 
distro does not support newer firmware, let me know and I can send you a couple 
of files needed to do an update.

If updating the firmware does not help, then please try the attached patch for 
mainline 4.18. It uses the controller reset from the offending patch, but limits 
the resets to once every 40 out-of-order reports.

Larry


--------------E88DA50CB14092C0E73268C7
Content-Type: text/x-patch;
 name="trial_fix_for_b43.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="trial_fix_for_b43.patch"

diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index 6b0e1ec346cb..8291965518ae 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -1484,7 +1484,7 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 	int slot, firstused;
 	bool frame_succeed;
 	int skip;
-	static u8 err_out1;
+	static u8 err_out1, err_out2;
 
 	ring = parse_cookie(dev, status->cookie, &slot);
 	if (unlikely(!ring))
@@ -1519,12 +1519,16 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 		} else {
 			/* More than a single header/data pair were missed.
 			 * Report this error, and reset the controller to
-			 * revive operation.
+			 * revive operation. Do this only every 40 such errors.
 			 */
-			b43dbg(dev->wl,
-			       "Out of order TX status report on DMA ring %d. Expected %d, but got %d\n",
-			       ring->index, firstused, slot);
-			b43_controller_restart(dev, "Out of order TX");
+			if (!err_out2) {
+				b43dbg(dev->wl,
+				       "Out of order TX status report on DMA ring %d. Expected %d, but got %d\n",
+				       ring->index, firstused, slot);
+			}
+			if (!(err_out2 % 40))
+				b43_controller_restart(dev, "Out of order TX");
+			err_out2 += 1;
 			return;
 		}
 	}
diff --git a/drivers/staging/rtl8192e/rtllib_module.c b/drivers/staging/rtl8192e/rtllib_module.c
index cdf4c9060c51..834896be0022 100644
--- a/drivers/staging/rtl8192e/rtllib_module.c
+++ b/drivers/staging/rtl8192e/rtllib_module.c
@@ -95,6 +95,7 @@ struct net_device *alloc_rtllib(int sizeof_priv)
 		pr_err("Unable to allocate net_device.\n");
 		return NULL;
 	}
+	strcpy(dev->name, "wlan%d");
 	ieee = (struct rtllib_device *)netdev_priv_rsl(dev);
 	memset(ieee, 0, sizeof(struct rtllib_device)+sizeof_priv);
 	ieee->dev = dev;

--------------E88DA50CB14092C0E73268C7--
