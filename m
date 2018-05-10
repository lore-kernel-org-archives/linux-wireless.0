Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:35103 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756989AbeEJJLg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 05:11:36 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH v2 1/3] wireless-drivers: Dynamically allocate struct station_info
In-Reply-To: <20180510085052.oscm2ezf4k6p2kwf@bars>
References: <152590211357.13924.18408619969539206421.stgit@alrua-kau> <20180510085052.oscm2ezf4k6p2kwf@bars>
Date: Thu, 10 May 2018 11:11:41 +0200
Message-ID: <87in7vyiwi.fsf@toke.dk> (sfid-20180510_111142_002491_6CBA9CC9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Hello Toke and all,
>
>> Since the addition of the TXQ stats to cfg80211, the station_info struct
>> has grown to be quite large, which results in warnings when allocated on
>> the stack. Fix the affected places to do dynamic allocations instead.
>>=20
>> Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to users=
pace")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>> ---
>>  drivers/net/wireless/ath/ath6kl/main.c             |   14 ++++++----
>>  drivers/net/wireless/ath/wil6210/debugfs.c         |   22 ++++++++++---=
--
>>  drivers/net/wireless/ath/wil6210/wmi.c             |   19 ++++++++-----
>>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   18 ++++++++----
>>  drivers/net/wireless/marvell/mwifiex/uap_event.c   |   25 +++++++++++--=
----
>>  drivers/net/wireless/quantenna/qtnfmac/event.c     |   29 +++++++++++++=
-------
>>  6 files changed, 82 insertions(+), 45 deletions(-)
>
> Thanks for taking care of this. As for qtnfmac part, there are two
> more EINVALs returned during payload processing. So they should be
> modified as well to avoid memleaks. Here is a fixup on top of your
> patch:

Ah yes, so there is; guess I missed those. Thanks for noticing! I'll
fold in your changes and resend :)

-Toke
