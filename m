Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:46724 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaEAUUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 16:20:42 -0400
Received: by mail-ie0-f180.google.com with SMTP id as1so4099793iec.11
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2014 13:20:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53620550.3050001@broadcom.com>
References: <53620550.3050001@broadcom.com>
Date: Thu, 1 May 2014 22:20:41 +0200
Message-ID: <CAFED-jk71Sx2LSdbh5T2e9eGnDq6peZ1ip=nCwg56U2tBbt5xg@mail.gmail.com> (sfid-20140501_222045_824750_D46F3446)
Subject: Re: net/wireless/chan.c: prohibited_flags wrongly set
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-05-01 10:26 GMT+02:00 Arend van Spriel <arend@broadcom.com>:
> Hi Johannes,
>
> I was debugging issue with hostapd failing on setting channel when I came
> across this piece of code in chan.c:545:cfg80211_chandef_usable():
>
>         if (width > 20)
>                 prohibited_flags |= IEEE80211_CHAN_NO_OFDM;
>
>         /* 5 and 10 MHz are only defined for the OFDM PHY */
>         if (width < 20)
>                 prohibited_flags |= IEEE80211_CHAN_NO_OFDM;
>
> I suspect the first if statement to be wrong, but what should it be?
>
 width > 20 - HT40, VHT80 ... - 80211n/80211ac using OFDM - so NO_OFDM
seems to be prohibited.

BR
Janusz
