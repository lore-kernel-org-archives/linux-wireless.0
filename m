Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48599 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1LKEUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 23:20:34 -0500
Received: by iaeh11 with SMTP id h11so1131009iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 20:20:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323550849-16651-1-git-send-email-nbd@openwrt.org>
References: <1323550849-16651-1-git-send-email-nbd@openwrt.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 11 Dec 2011 15:20:01 +1100
Message-ID: <CAGRGNgWVG9gEfwRTcF7V-jzfwVQ3RSoYMHmTSp-SKpsbWo7k6w@mail.gmail.com> (sfid-20111211_052043_926256_0AE0B608)
Subject: Re: [PATCH] ath9k_hw: make bluetooth coexistence support optional at
 compile time
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix,

On Sun, Dec 11, 2011 at 08:00, Felix Fietkau <nbd@openwrt.org> wrote:
> Many systems (e.g. embedded systems) do not have wifi modules connected to
> bluetooth modules, so bluetooth coexistence is irrelevant there. With the
> addition of MCI support, ath9k picked up quite a bit of extra code that
> can be compiled out this way.
>
> This patch redefines ATH9K_HW_CAP_MCI and adds an inline wrapper for
> querying the bluetooth coexistence scheme, allowing the compiler to
> eliminate code that uses it, with only very little use of #ifdef.
>
> On MIPS this reduces the total size for the modules by about 20k.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> index 8599822..4905af9 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> @@ -85,6 +85,9 @@ void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done)
>  {
>        u32 payload[4] = { 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00};
>
> +       if (!ATH9K_HW_CAP_MCI)
> +               return;
> +

IMHO, the checks for ATH9K_HW_CAP_MCI don't make it obvious that
they're checking whether coexistence is enabled, and are more about
whether *part* of it is enabled - which could cause confusion if
another scheme is ever added, or it gets a not-insignificant re-write.
Surely it wouldn't be too bad to do some #defining around this code
and in the headers etc. so that the coexistence only functions aren't
even looked at by the compiler if isn't enabled? IMHO putting the
btcoex code in #ifdef blocks is better documentation as it's saying
"these are the btcoex functions, and they're only used if this config
variable is enabled" not "this random function can be skipped if some
hardware feature is disabled".

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
