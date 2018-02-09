Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbeBIHQk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 02:16:40 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Kai Heng Feng <kai.heng.feng@canonical.com>
Cc: Felix Fietkau <nbd@nbd.name>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: turn on btcoex_enable as default
References: <20180208052801.15670-1-kai.heng.feng@canonical.com>
        <56d650e6-d26f-087c-4e86-2e5d4e859414@nbd.name>
        <A5972CE9-8325-404A-A63D-ED29E44FB67B@canonical.com>
Date: Fri, 09 Feb 2018 09:16:35 +0200
In-Reply-To: <A5972CE9-8325-404A-A63D-ED29E44FB67B@canonical.com> (Kai Heng
        Feng's message of "Fri, 9 Feb 2018 12:21:36 +0800")
Message-ID: <87k1vmeip8.fsf@kamboji.qca.qualcomm.com> (sfid-20180209_081659_380175_72F23144)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kai Heng Feng <kai.heng.feng@canonical.com> writes:

> Hi Felix,
>
>> On Feb 8, 2018, at 7:02 PM, Felix Fietkau <nbd@nbd.name> wrote:
>>
>> On 2018-02-08 06:28, Kai-Heng Feng wrote:
>>> Without btcoex_enable, WiFi activies make both WiFi and Bluetooth
>>> unstable if there's a bluetooth connection.
>>>
>>> Enable this option when bt_ant_diversity is disabled.
>>>
>>> BugLink: https://bugs.launchpad.net/bugs/1746164
>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> I think this might cause regressions on devices that don't have
>> bluetooth. This probably either needs more EEPROM checks, or something
>> to selectively enable it only on affected platforms.
>
> I think it=E2=80=99s better not to use dmi_match. This issue should affect
> more ath9k. And bluetooth peripherals are more than ever now, so it
> would be great to use BT out of the box.

Sure, but we have to make sure that we don't create regressions on
existing systems. For example, did you test this with any system which
don't support btcoex? (just asking, haven't tested this myself)

--=20
Kalle Valo
