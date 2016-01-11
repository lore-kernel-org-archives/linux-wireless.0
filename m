Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35191 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759094AbcAKLbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 06:31:53 -0500
Received: by mail-wm0-f48.google.com with SMTP id f206so207488268wmf.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2016 03:31:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADaZW1Gi0k2WjhCo+KZ=pijO2q7o9dE7fM8tTXMG8+LW=36acw@mail.gmail.com>
References: <CADaZW1Gi0k2WjhCo+KZ=pijO2q7o9dE7fM8tTXMG8+LW=36acw@mail.gmail.com>
Date: Mon, 11 Jan 2016 12:31:52 +0100
Message-ID: <CALhHN=rXuKN9YhEKo0-DVH24AcOsovCodMWMRRCX9+zRCpoO3Q@mail.gmail.com> (sfid-20160111_123157_159513_9DE4FFAC)
Subject: Re: WLAN drivers provided by Realtek do not work with backports
 (cfg80211 module not compatible)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Bartlomiej Grzeskowiak <bartlomiej.grzeskowiak@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 January 2016 at 12:02, Bartlomiej Grzeskowiak
<bartlomiej.grzeskowiak@gmail.com> wrote:
> We use 8192cu and 8811AU provided by Realtek. Our kernel is 3.10.
> We would like to add parallel support for ath10k_pci from backports.
>
> However after inserting compat.ko, cfg80211.ko and mac80211.ko from
> backports, 8192cu.ko and 8821au.ko terminate with following message:
> [  512.188364] 8192cu: Unknown symbol wiphy_new (err 0)
> [  512.188481] 8192cu: Unknown symbol cfg80211_send_disassoc (err 0)
> [  512.188554] 8192cu: Unknown symbol cfg80211_send_rx_assoc (err 0)
> [  512.188607] 8192cu: Unknown symbol cfg80211_inform_bss_frame (err 0)
>
Seems they were renamed/cleaned in patch:

cfg80211/mac80211: clean up cfg80211 SME APIs

so, newest cfg80211.ko don't have them.

Patch for 8192cu seems to be required - at least to use this new API.

BR
Janusz

> Those interfaces are exported when I load cfg80211.ko compiled from kernel 3.10.
> But I can not see them in cfg80211.ko provided by backports.
>
> Do you know this problem ?
> Is there any easy way to solve this issue ?
>
> BR
> Bartek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
