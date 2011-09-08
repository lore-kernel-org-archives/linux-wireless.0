Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59833 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771Ab1IHBwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 21:52:21 -0400
Received: by yie30 with SMTP id 30so247723yie.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 18:52:20 -0700 (PDT)
Message-ID: <4E681FD1.4020109@lwfinger.net> (sfid-20110908_035224_918391_CB6393B3)
Date: Wed, 07 Sep 2011 20:52:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
CC: linux-wireless@vger.kernel.org,
	'Chaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: RTL8192SE and 802.11n problem
References: <4E67CE3F.8090405@gmail.com> <4E67CEA3.7020709@gmail.com>
In-Reply-To: <4E67CEA3.7020709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2011 03:05 PM, Stefan Zwanenburg wrote:
>
>   * My NIC variant has the following ID: 10ec:8172. I suppose that means it's an
>     RTL8192SEvA2. I did not know this at the time of writing however.
>   * Kernel version: it's a vanilla kernel + gentoo patches (exact gentoo ebuild
>     version: 3.0.4).
>   * Driver: I'm using the one for the RTL8192SE that is currently in the kernel
>     tree, so no compat-wireless.
>   * Access point: 3Com 3CRWER300-73 with firmware version 1.12.06.
>
> Anyhow, I've tried the driver on Realtek's site both for the RTL8192se and
> RTL8192SEvA2 (after having to rename RX_FLAG_TSFT to RX_FLAG_MACTIME_MPDU, and
> adding an include to "linux/proc_fs.h", both to avoid compilation errors),
> neither of which allow me to connect over an 802.11n link. At this point, I'm
> unsure how to proceed. I've run a netperf test, which maxed out at 22Mbps, and
> my router reports my MAC address as being connected over an 11g link. Is there
> anything I can do to further prove that I have a problem?

Although I do not remember anything in the latest driver revisions that would 
affect rtl8192se, thus compat-wireless should not be necessary.

The unit I reported in my previous message was a 1x1 model. Tonight, I tested a 
2x2, which lspci reports as 06:00.0 Network controller [0280]: Realtek 
Semiconductor Co., Ltd. RTL8192SE Wireless LAN Controller [10ec:8174] (rev 10).

The netperf test results are:


TCP_MAERTS TX Test:  53.21 53.72 51.59 57.70 55.11 55.13 56.02 52.42 42.90 50.06
TCP_MAERTS RX Test:  57.64 62.44 68.77 61.47 47.29 58.74 63.13 61.91 59.00 63.42
Results: TX: max 57.70, min 42.90. Mean 52.79(3.92)
          RX: max 68.77, min 47.29. Mean 60.38(5.28)
 

TCP_STREAM TX Test:  73.25 79.46 70.42 66.47 79.26 64.91 68.11 71.63 70.36 65.44
TCP_STREAM RX Test:  46.67 40.17 50.84 49.79 37.89 50.89 43.79 47.76 46.89 49.01
Results: TX: max 79.46, min 64.91. Mean 70.93(4.93)
          RX: max 50.89, min 37.89. Mean 46.37(4.22)

TCP_SENDFILE TX Test:  61.73 74.61 59.25 53.56 51.50 68.91 57.43 62.41 53.91 51.94
TCP_SENDFILE RX Test:  38.76 42.08 47.27 51.58 47.70 51.86 52.09 45.84 44.25 39.48
Results: TX: max 74.61, min 51.50. Mean 59.52(7.23)
          RX: max 52.09, min 38.76. Mean 46.09(4.69)

finger@larrylap:~> iwconfig wlan0

wlan0     IEEE 802.11bgn  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=270 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Power Management:off
           Link Quality=70/70  Signal level=-35 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Next, I will test my other card, which is a 1x2 model with kernel 3.0.4. I have 
also Cc'd Chaoming Li at Realsil, the group that actually wrote the driver. 
Perhaps their lab has the same AP as yours.

Larry
