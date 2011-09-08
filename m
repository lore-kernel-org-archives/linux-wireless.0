Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54410 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1IHCXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 22:23:50 -0400
Received: by yxp4 with SMTP id 4so69937yxp.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 19:23:50 -0700 (PDT)
Message-ID: <4E682732.1040700@lwfinger.net> (sfid-20110908_042354_733347_21E43305)
Date: Wed, 07 Sep 2011 21:23:46 -0500
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

With kernel 3.0.4:

06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB 
Wireless LAN Controller [10ec:8172] (rev 10)

TCP_MAERTS TX Test:  29.57 33.17 37.99 38.61 37.38 35.34 37.42 14.04 36.08 34.95
TCP_MAERTS RX Test:  30.52 39.50 37.88 30.90 38.60 31.86 47.55 32.86 41.98 41.46
Results: TX: max 38.61, min 14.04. Mean 33.45(6.95)
          RX: max 47.55, min 30.52. Mean 37.31(5.36)


TCP_STREAM TX Test:  32.11 33.20 39.19 32.24 43.94 15.74 27.74 32.75 32.85 33.12
TCP_STREAM RX Test:  35.45 34.24 35.68 34.28 35.23 31.15 30.75 36.01 35.07 35.08
Results: TX: max 43.94, min 15.74. Mean 32.29(6.93)
          RX: max 36.01, min 30.75. Mean 34.29(1.75)

TCP_SENDFILE TX Test:  26.69 30.01 29.32 29.21 29.27 29.87 30.06 29.69 29.25 20.21
TCP_SENDFILE RX Test:  33.72 29.56 36.87 32.65 34.46 33.71 37.67 38.28 36.20 30.50
Results: TX: max 30.06, min 20.21. Mean 28.36(2.87)
          RX: max 38.28, min 29.56. Mean 34.36(2.79)

finger@larrylap:~> iwconfig wlan0

wlan0     IEEE 802.11bgn  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=135 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Power Management:off
           Link Quality=70/70  Signal level=-35 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0


With kernel wireless-testing 3.1-rc4:

TCP_MAERTS TX Test:  23.34 48.86 52.67 44.96 50.42112.86 41.24 46.60 50.81 45.24
TCP_MAERTS RX Test:  67.77 75.84 35.60 57.84 55.06 61.65 55.46 59.58 59.65 61.81
Results: TX: max 112.86, min 23.34. Mean 51.70(21.86)
          RX: max 75.84, min 35.60. Mean 59.03(9.76)

TCP_STREAM TX Test:  61.92 61.14 57.27 62.02 58.43 61.41 61.34 62.39 61.45 59.49
TCP_STREAM RX Test:  23.95 39.50 32.49 53.00 44.30 43.82 48.37 45.50 50.54 50.27
Results: TX: max 62.39, min 57.27. Mean 60.69(1.62)
          RX: max 53.00, min 23.95. Mean 43.17(8.56)

TCP_SENDFILE TX Test:  62.51 58.05 58.21 51.26 58.60 57.32 58.36 59.02 51.30 54.72
TCP_SENDFILE RX Test:  45.35 39.31 34.46 31.14 28.40 35.71 40.78 44.67 39.14 36.66
Results: TX: max 62.51, min 51.26. Mean 56.94(3.35)
          RX: max 45.35, min 28.40. Mean 37.56(5.16)
finger@larrylap:~> iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wlan8     IEEE 802.11bgn  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=135 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Power Management:off
           Link Quality=70/70  Signal level=-35 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

It turns out the performance is quite a bit higher with 3.1-rc4 (actually 3.2 
wireless) than it is with 3.0.4.

If possible, could you please try the latest compat-wireless, either as a 
package or as downloaded source? In the meantine, I will bisect between the 
current wireless-testing and 3.0, and test the 3.1-rc4 aminline kernel.

Larry
