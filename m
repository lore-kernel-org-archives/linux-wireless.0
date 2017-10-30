Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18563 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdJ3Gyk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 02:54:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Lior David <liord@codeaurora.org>
CC: qca_merez <qca_merez@qca.qualcomm.com>,
        qca_liord <qca_liord@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 03/12] wil6210: refresh FW capabilities during interface
 up
Date: Mon, 30 Oct 2017 06:54:35 +0000
Message-ID: <87lgjt3z2t.fsf@kamboji.qca.qualcomm.com> (sfid-20171030_075444_405348_B6E8F4FE)
References: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1508937247-11890-4-git-send-email-qca_merez@qca.qualcomm.com>
        <87o9ors4ef.fsf@purkki.adurom.net>
        <17994ee8-0d84-2e67-c290-5f1a2f18e0a1@codeaurora.org>
In-Reply-To: <17994ee8-0d84-2e67-c290-5f1a2f18e0a1@codeaurora.org> (Lior
        David's message of "Sat, 28 Oct 2017 18:25:59 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lior David <liord@codeaurora.org> writes:

> On 10/28/2017 6:01 PM, Kalle Valo wrote:
>> Maya Erez <qca_merez@qca.qualcomm.com> writes:
>>=20
>>> From: Lior David <qca_liord@qca.qualcomm.com>
>>>
>>> FW capabilities are currently retrieved only during module
>>> initialization, but userspace can replace the firmware while
>>> interface is down, so refresh the FW capabilities when
>>> interface is up (after FW is loaded) to ensure driver
>>> functionality matches the loaded FW.
>>=20
>> I think usually the firmware is loaded only once during probe() and I
>> think it's quite special that you retrieve it during interface up. Being
>> able to change the firmware version runtime like that can lead to
>> problems eventually, for example cfg80211 might not allow changing
>> already registered configuration etc.
>>=20
> Yes you are right, it is not perfect.
> We shutdown our chip in interface down so the FW is lost, we have to load=
 it
> every interface up. We could request_firmware only once at insmod and sto=
re it
> so the same FW will be used every time but this is a big waste of memory =
(FW
> size is ~400KB and may be larger with future chips). We only touch one or=
 two
> very simple fields in struct wiphy that are not validated in wiphy_regist=
er. The
> behavior is not 100% proof but good enough, and we recommend to our users=
 to
> always rmmod/insmod when replacing FW (replacing FW at runtime is usually=
 not
> done in production systems, this is only for debugging).
> However, if we do not refresh the capabilities we will have larger proble=
ms -
> the driver can try to access features not supported by FW and cause FW/ho=
st crashes.

Yes, I agree that this patch does improve things and should be applied.
But I think in the long run you should consider changing this and do the
same as other drivers do (load the firmware only on probe()).

--=20
Kalle Valo=
