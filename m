Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33714 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbcERA60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 20:58:26 -0400
Received: by mail-oi0-f67.google.com with SMTP id t140so6747199oie.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 17:58:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463525295-10818-2-git-send-email-dlenski@gmail.com>
References: <1463525295-10818-1-git-send-email-dlenski@gmail.com> <1463525295-10818-2-git-send-email-dlenski@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 May 2016 10:58:06 +1000
Message-ID: <CAGRGNgVV2vrKpn9Xodg77Du_iuZ2t7cYzMUABT3rOV2QMr-Wqw@mail.gmail.com> (sfid-20160518_025830_198870_16A4A7DE)
Subject: Re: [PATCH] Make firmware startup polling timeout configurable, and
 increase default
To: Dan Lenski <dlenski@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jes Sorensen <jes.sorensen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Add a "rtl8xxxu:" prefix to the patch title. This makes it easier to
determine which patch is for which driver when only the titles are
listed.

On Wed, May 18, 2016 at 8:48 AM, Dan Lenski <dlenski@gmail.com> wrote:
> This patch:
>
> - increases the default value for the maximum number of polling loops to
>   wait for the rtl8xxxu MCU to start after the firmware is loaded (from
>   1000 to 5000)
> - makes this a configurable module parameter

Split this into two patches, one to make it configurable and one to
increase the default.

> With RTL8723AU chipset, I frequently encounter "Firmware failed to start"
> errors from rtl8xxxu after a cold boot.
>
> It appears that other chipsets supported by the driver have the same
> problem. Here are a couple of relevant bug reports:
> - http://ubuntuforums.org/showthread.php?t=2321756
> - https://www.mail-archive.com/ubuntu-bugs-nLRlyDuq1AZFpShjVBNYrg <at> public.gmane.org/msg4942468.html
>
> This issue seems to occur because RTL8XXXU_FIRMWARE_POLL_MAX (1000) is
> too short, and the MCU fails to start up as quickly as expected.
>
> With a longer value (5000), the driver starts up consistently and
> successfully after cold-boot.

No signed-off-by.

> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 +++++++----
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 +-
>  2 files changed, 8 insertions(+), 5 deletions(-)

Other than those things, the actual changes look fine to me.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
