Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43498 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752891AbdCGNc5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 08:32:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH RFC] brcmfmac: shutdown interfaces on PSM's watchdog fire
References: <20170224172423.10980-1-zajec5@gmail.com>
Date: Tue, 07 Mar 2017 15:32:44 +0200
In-Reply-To: <20170224172423.10980-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Fri, 24 Feb 2017 18:24:23 +0100")
Message-ID: <87h9356wlf.fsf@purkki.adurom.net> (sfid-20170307_143308_369128_8522F81D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> When PSM's watchdog fires hardware / firmware is not operational. It
> seems there isn't a way to restart firmware & reapply all settings so
> instead shut all interfaces down. This is at least some signal for the
> user things went wrong and allows reacting to it.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> This patch is RFC as I'm wondering if there is any other way to handle
> such errors. I couldn't find anything except for that
> cfg80211_shutdown_all_interfaces.
>
> Unfortunately hostapd doesn't seem to react to this except for sth like:
> Fri Feb 24 13:41:07 2017 daemon.notice hostapd: wlan0: INTERFACE-DISABLED
>
> Shall we introduce some nl80211 even for such cases maybe?
>
> Or maybe I'm totally wrong and there is some simple way for a driver to
> request reconfiguration of all interfaces?

Did you notice this on your email:

To:     unlisted-recipients:; (no To-header on input)

--=20
Kalle Valo
