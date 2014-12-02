Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36185 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbaLBLSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 06:18:08 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so16564043wgg.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 03:18:07 -0800 (PST)
Message-ID: <547D9FE5.1010006@gmail.com> (sfid-20141202_121812_950656_1A08E9FE)
Date: Tue, 02 Dec 2014 12:17:57 +0100
From: Richard Genoud <richard.genoud@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 4/4] Revert "rt2x00: Endless loop on hub port power down"
References: <1417012156-26197-1-git-send-email-sgruszka@redhat.com> <1417012156-26197-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1417012156-26197-4-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/11/2014 15:29, Stanislaw Gruszka wrote:
> This reverts commit 2ad69ac5976191e9bb7dc4044204a504653ad1bb. It
> causes wireless device disappear when we get -EPROTO error form USB
> request. I encounter such situation occasionally when resume form
> suspend with RT3070 adapter:
> 
> [  289.619985] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x0404 with error -71
> [  289.639368] ieee80211 phy0: rt2800_wait_bbp_ready: Error - BBP register access failed, aborting
> [  289.639374] ieee80211 phy0: rt2800usb_set_device_state: Error - Device failed to enter state 4 (-5)
> 
> Without the patch, except printing error, device works just fine after
> resume.
> 
> Currently after timeouts and REGISTER_BUSY_COUNT tuning, we should
> not have any "endless loop", though we can wait quite long when driver
> is trying to communicate with the device through non functioning USB
> connection. Generally the problem that commit 2ad69ac597619 solves
> is kinda artificial.
> 
> Cc: Richard Genoud <richard.genoud@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00usb.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index c2346f8..892270d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -64,12 +64,6 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
>  		}
>  	} while (time_before(jiffies, expire));
>  
> -	/* If the port is powered down, we get a -EPROTO error, and this
> -	 * leads to a endless loop. So just say that the device is gone.
> -	 */
> -	if (status == -EPROTO)
> -		clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
> -
>  	rt2x00_err(rt2x00dev,
>  		   "Vendor Request 0x%02x failed for offset 0x%04x with error %d\n",
>  		   request, offset, status);
> 
It tested this serie but unfortunately, reverting this still caused an infinite loop.
(cf https://lkml.org/lkml/2014/4/3/492 to reproduce)

[  642.007812] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.023437] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.031250] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.046875] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.054687] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.062500] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.078125] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.085937] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.101562] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.117187] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.125000] ieee80211 phy0: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 4 in queue 0
[  642.132812] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.250000] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x1700 with error -71
[  642.359375] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0438 with error -71
[  642.468750] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0438 with error -71
[  642.476562] ieee80211 phy0: rt2800usb_watchdog: Warning - TX HW queue 1 timed out, invoke forced kick
[  642.585937] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x0408 with error -71
[  642.695312] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x0408 with error -71
[  642.718750] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.734375] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.742187] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.757812] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.765625] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.773437] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.789062] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.796875] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.812500] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  642.820312] ieee80211 phy0: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 5 in queue 0
[  642.835937] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[...]
So it seems the "forced kick" is not done 

With patches 1-3 applied but not this one, I've got:
[  154.015625] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.031250] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.039062] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.054687] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.062500] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.070312] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.085937] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.093750] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.109375] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.117187] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 8 in queue 0
[  154.132812] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
[  154.242187] ieee80211 phy1: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0438 with error -71
[  154.250000] ieee80211 phy1: rt2800usb_watchdog: Warning - TX HW queue 0 timed out, invoke forced kick
[  154.765625] cfg80211: Calling CRDA to update world regulatory domain
[  155.710937] wlan0: authenticate with 00:17:9a:84:fb:94
[  155.718750] wlan0: send auth to 00:17:9a:84:fb:94 (try 1/3)
[  155.726562] wlan0: send auth to 00:17:9a:84:fb:94 (try 2/3)
[  155.734375] wlan0: send auth to 00:17:9a:84:fb:94 (try 3/3)
[  155.742187] wlan0: authentication with 00:17:9a:84:fb:94 timed out
Here, the forced kick is done.

Richard


