Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56898 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab1CHO5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 09:57:10 -0500
Received: by wya21 with SMTP id 21so47460wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 06:57:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110308211855.AF33.9AD4E5EB@silex.jp>
References: <20110308211855.AF33.9AD4E5EB@silex.jp>
Date: Tue, 8 Mar 2011 20:27:07 +0530
Message-ID: <AANLkTi=pZs3QSABoPeG8Z0Z7COzLQDG-uO36uWeMkOnx@mail.gmail.com>
Subject: Re: AR9271 doesn't work on 12ch and 13ch
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Takashi Kawamoto <tkawamoto@silex.jp>
Cc: linux-wireless@vger.kernel.org, Yoshitaka Imura <imura@silex.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 8, 2011 at 6:09 PM, Takashi Kawamoto <tkawamoto@silex.jp> wrote:
> Dear All,
>
> AR9271 cannot connect to an AP which operates on 12ch and 13ch.
> As long as I see the EEPROM content of my module, 0x8188 (CTRL_JAPAN1)
> seems to be configured to the region domain code area.
>
> [EEPROM dump]
> -------------------------------------------------------
> 78  1 99 B4  F E0  2  0 88 81 2A  0 5C 33 8E 65
> 74 C1  1  1  0  0  0  0  0  0  0 7F  8  0  8  0
>  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
>  0  0  0  0  0  0  0  0  0  0  0  0  0 2C 20  0
> E2  0  D  0  2  E 1C BA  C  1  0  0  6 55  5  1
>  E  E FF  0  0 2C  0  0  5  4  6 B0  0 60  0  0
>  0  1  0  0  0 80  0  0  0  0  0  0  0  0  0  0
>  0  0  0  0  0  0  0  0 70 8E AC  B 22 2A 3D 53
> 4B 54 5E 6A 74  5 10 17 2F 6E 2C 3B 55 83 B0  D
> 24 2A 3E 52 4C 54 60 6B 71  7 11 17 36 71 30 40
> 5F 93 AF  E 13 2A 3E 51 4B 53 5F 6B 6E  7  A 18
> 38 70 2C 44 62 9A AC 70 22 22 22 22 B8 22 22 22
> 22 FF  0  0  0  0 70 22 22 20 1E 89 22 22 20 1E
> AC 22 22 20 1E 70 22 22 22 22 22 22 20 1E 89 22
> 22 22 22 22 22 20 1E AC 22 22 22 22 22 22 20 1E
> 70 1E 1E 1E 1E 1E 1E 1E 1C 89 1E 1E 1E 1E 1E 1E
> 1E 1C AC 1E 1E 1E 1E 1E 1E 1E 1C 11 12 15 17 41
> 42 45 47 31 32 35 37 70 22 75 62 A2 22  0  0 70
> 22 75 62 A2 21  0  0 70 1A 75 62 A2 1E  0  0 7A
> 12 7F 5C 93 5C 98 16 70 3C 75 7C AC 3C B8 3C 70
> 3C 75 7C AC 3C  0  0 70 3C 75 7C AC 3C  0  0 7A
> 3C 7F 7C 93 7C A2 3C 70 22 75 62 AC 22  0  0 70
> 22 75 62 AC 22  0  0 70 22 75 62 AC 22  0  0 7A
> 1E 7F 5E 93 5E A2 1E  0
> -------------------------------------------------------
>
> The version of compat-wireless I use is 2011-01-30.
>
> I investigated the issue further, and found that priv->hw->wiphy->bands
> includes from 1ch to 14ch (ath9k_set_hw_capab() in htc_drv_init.c), but
> wdev->wiphy->bands includes from 1ch to 11ch (cfg80211_wext_giwrange()
> in wext-compat.c). I still don't know why and when 12ch, 13ch and 14ch
> are removed from the channel list.
>
> Anyone has any idea?

Please post the kernel log /dmesg with CONFIG_CFG80211_REG_DEBUG=y
enabled in config.mk of your compat wireless. This might also be
helpful.

>
>
>
> Best Regards,
> Takashi Kawamoto
>
> ==================================================
>  Takashi Kawamoto (E-Mail : tkawamoto@silex.jp)
>  silex technology,Inc.
>  Software Engineering Division
>  Phone:+81-774-98-3877 FAX:+81-774-98-3678
> ==================================================
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
