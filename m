Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51670 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0LGHiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 02:38:25 -0500
Received: by qyk12 with SMTP id 12so15496370qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 23:38:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CFD1620.5070708@hs-owl.de>
References: <4CFD1620.5070708@hs-owl.de>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Tue, 7 Dec 2010 17:38:10 +1000
Message-ID: <AANLkTimRmWibiy9QhfZGkeP0u58e2bYdrd1xXn-3igGX@mail.gmail.com>
Subject: Re: How to get medium (carrier-sense) information from Atheros chipsets?
To: "Stefan Schwalowsky (inIT)" <stefan.schwalowsky@hs-owl.de>
Cc: linux-wireless@vger.kernel.org,
	ath5k-devel list <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have a look at the ANI file in
/sys/kernel/debug/ieee80211/phyx/ath5k/ani

You will need to enable debugfs & debug entries for ath5k in your kernel config.

Alternatively, you can look at the patches Bruno Randolf added:
[PATCH 2/2] ath5k: Add channel time to survey data

Cheers,

--
Jonathan Guerin



On Tue, Dec 7, 2010 at 2:58 AM, Stefan Schwalowsky (inIT)
<stefan.schwalowsky@hs-owl.de> wrote:
> Hello,
> I'm working on a research project dealing with real-time capabilities of
> WLAN. Currently I'm analyzing the ATH5K driver and trying to find a way to
> get information about the medium state (carrier-sense state) . I want to
> check whether the medium is currently occupied by other stations or not. Is
> there a way to get the carrier sense information from the hardware through a
> status-register or so? (Currently we have a AR5413 Chip, but any other would
> also be OK)  The only information i found was about the profile count
> registers, which doesn't really meet our requirements.
>
> I greatly appreciate your help
>
> Kind regards
> Stefan Schwalowsky
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
