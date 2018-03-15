Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbeCOJNG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 05:13:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com
Subject: Re: [PATCH] wireless: brcmfmac: cfg80211: Fix check for ISO3166 code
References: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
        <CACna6ryiAqeW7Awr=o5yydBaTY=+TQmW0DvB6wFO+fQOwFJSgQ@mail.gmail.com>
        <9de41438-ab95-9fe5-e414-1790de888a84@i2se.com>
Date: Thu, 15 Mar 2018 11:13:00 +0200
In-Reply-To: <9de41438-ab95-9fe5-e414-1790de888a84@i2se.com> (Stefan Wahren's
        message of "Thu, 15 Mar 2018 08:57:18 +0100")
Message-ID: <87sh917lcz.fsf@kamboji.qca.qualcomm.com> (sfid-20180315_101311_911440_41F93263)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Wahren <stefan.wahren@i2se.com> writes:

> Am 15.03.2018 um 07:27 schrieb Rafa=C5=82 Mi=C5=82ecki:
>> On 14 March 2018 at 20:02, Stefan Wahren <stefan.wahren@i2se.com> wrote:
>>> The commit "regulatory: add NUL to request alpha2" increases the length=
 of
>>> alpha2 to 3. This causes a regression on brcmfmac, because
>>> brcmf_cfg80211_reg_notifier() expect valid ISO3166 codes in the complete
>>> array. So fix this accordingly.
>>>
>>> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
>> It sounds like it's worth a:
>> Fixes: <sha> ("regulatory: add NUL to request alpha2")
>
> I wasn't sure that i can take the hash from linux-next. I will add this.

Yeah, taking commit id from linux-next is not always safe. It depends on
the maintainer as some people never rebase and some do it quite often.
But in this case commit 657308f73e67 ("regulatory: add NUL to request
alpha2") is already in Linus' tree so the commit id won't change
anymore.

--=20
Kalle Valo
