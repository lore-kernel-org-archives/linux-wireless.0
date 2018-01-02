Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45015 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbeABTXs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 14:23:48 -0500
Date: Tue, 2 Jan 2018 20:23:45 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/6] wl1251: Fix MAC address for Nokia N900
Message-ID: <20180102192345.dnywuv4sapltrfrl@pali> (sfid-20180102_202405_695372_4BCEFC87)
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 November 2017 00:38:22 Pali Rohár wrote:
> This patch series fix processing MAC address for wl1251 chip found in Nokia N900.
> 
> Changes since v1:
> * Added Acked-by for Pavel Machek
> * Fixed grammar
> * Magic numbers for NVS offsets are replaced by defines
> * Check for validity of mac address NVS data is moved into function
> * Changed order of patches as Pavel requested
> 
> Pali Rohár (6):
>   wl1251: Update wl->nvs_len after wl->nvs is valid
>   wl1251: Generate random MAC address only if driver does not have
>     valid
>   wl1251: Parse and use MAC address from supplied NVS data
>   wl1251: Set generated MAC address back to NVS data
>   firmware: Add request_firmware_prefer_user() function
>   wl1251: Use request_firmware_prefer_user() for loading NVS
>     calibration data
> 
>  drivers/base/firmware_class.c          |   45 +++++++++++++-
>  drivers/net/wireless/ti/wl1251/Kconfig |    1 +
>  drivers/net/wireless/ti/wl1251/main.c  |  104 ++++++++++++++++++++++++++------
>  include/linux/firmware.h               |    9 +++
>  4 files changed, 138 insertions(+), 21 deletions(-)

Hi! Are there any comments for first 4 patches? If not, could they be
accepted and merged?

-- 
Pali Rohár
pali.rohar@gmail.com
