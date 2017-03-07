Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34844 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755266AbdCGOjz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 09:39:55 -0500
Received: by mail-ot0-f193.google.com with SMTP id a12so431616ota.2
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 06:38:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87h9356wlf.fsf@purkki.adurom.net>
References: <20170224172423.10980-1-zajec5@gmail.com> <87h9356wlf.fsf@purkki.adurom.net>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 7 Mar 2017 15:38:23 +0100
Message-ID: <CACna6ryvu-6j0s3VNbi2jAba=dsM3ERCfcUd34w=oC6VN_U4yQ@mail.gmail.com> (sfid-20170307_153959_742809_FE08EDD3)
Subject: Re: [PATCH RFC] brcmfmac: shutdown interfaces on PSM's watchdog fire
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 March 2017 at 14:32, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:
>
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> When PSM's watchdog fires hardware / firmware is not operational. It
>> seems there isn't a way to restart firmware & reapply all settings so
>> instead shut all interfaces down. This is at least some signal for the
>> user things went wrong and allows reacting to it.
>>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>> This patch is RFC as I'm wondering if there is any other way to handle
>> such errors. I couldn't find anything except for that
>> cfg80211_shutdown_all_interfaces.
>>
>> Unfortunately hostapd doesn't seem to react to this except for sth like:
>> Fri Feb 24 13:41:07 2017 daemon.notice hostapd: wlan0: INTERFACE-DISABLE=
D
>>
>> Shall we introduce some nl80211 even for such cases maybe?
>>
>> Or maybe I'm totally wrong and there is some simple way for a driver to
>> request reconfiguration of all interfaces?
>
> Did you notice this on your email:
>
> To:     unlisted-recipients:; (no To-header on input)

I guess I should have put linux-wireless in To. Normally I put you,
but since it's RFC, I left it empty and it went like this.

Anyway I believe it still reached linux-wireless. So any comments on this? =
:)

--=20
Rafa=C5=82
