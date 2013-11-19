Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63753 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3KSEMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 23:12:47 -0500
Received: by mail-bk0-f42.google.com with SMTP id w11so749892bkz.15
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 20:12:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABGE7dur4pM4vLz_iLx7u-g5ohKhXkwKAOmjJ86PE62mYwGPJw@mail.gmail.com>
References: <CABGE7dsDtL0ZPAmOTW=G=hMdA-6r=yT0DtQx_-H6Yi6cGa6Udw@mail.gmail.com>
 <CABGE7dur4pM4vLz_iLx7u-g5ohKhXkwKAOmjJ86PE62mYwGPJw@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 18 Nov 2013 20:12:26 -0800
Message-ID: <CAG6hwVOOvKfZcv-J70EMeHM3pmx-ieeAF2-6UtbrmoN3xC=SLw@mail.gmail.com> (sfid-20131119_051251_651861_983055E8)
Subject: Re: NL80211_CMD_NEW_STATION result: -105 (No buffer space available)
To: Gustavo Azambuja <gazambuja+hostapd@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gustavo,

On Mon, Nov 18, 2013 at 6:20 PM, Gustavo Azambuja
<gazambuja+hostapd@gmail.com> wrote:
> Hi, I recently installed in my raspberry pi Raspbian with hostapd 1.0, I
> want to make my own Hotspot, but follow all tutorials, I can only get up to
> 6 stations connected at the same time.
>
> The next error apper with the #7 client try to connect:
> *NL80211_CMD_NEW_STATION result: -105 (No buffer space available)*
>
> How I can resize this and make more clients can connect to my device?
>
> Im using TL-WN722N dongle.

That devices contains an AR9271, which uses the ath9k_htc driver. The
number of stations you can maintain is limited by the device RAM.
Luckily the AR9271 firmware is now GPL [1] so you can hack on this
yourself I'm not quite sure what the upper limit is, but we've raised
it to 16 without seeing any obvious breakage.

Try modifying ATH9K_HTC_MAX_STA in the ath9k_htc driver and
ATH_NODE_MAX [2] in the firmware.

[1] https://github.com/qca/open-ath9k-htc-firmware
[2] https://github.com/qca/open-ath9k-htc-firmware/blob/master/target_firmware/wlan/include/wlan_hdr.h#L99

--
Thomas
