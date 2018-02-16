Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:44482 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753680AbeBPHgr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 02:36:47 -0500
Received: by mail-oi0-f66.google.com with SMTP id b3so1671075oib.11
        for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2018 23:36:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5A858127.1030904@broadcom.com>
References: <CAD8Lp47D5sGCpxSiFYQviu0a62W4aj-5Sgs6sjE7E2cZWwsUwg@mail.gmail.com>
 <5A82B4F8.2090209@broadcom.com> <CAD8Lp46ta_mQriB1eOJxnTmgoy5n5T9_AyNpVKuL2C4uuLrf3g@mail.gmail.com>
 <5A858127.1030904@broadcom.com>
From: Daniel Drake <drake@endlessm.com>
Date: Fri, 16 Feb 2018 10:36:45 +0300
Message-ID: <CAD8Lp45nhUwkjo4rCG9mYpvNe5U4V12cmh9ZPRuLyas8gYLiqw@mail.gmail.com> (sfid-20180216_083658_384675_A7BEDE4A)
Subject: Re: Make brcmfmac repeat authentication requests
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 15, 2018 at 3:46 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> Ok. Could you create a log with driver debugging enabled, ie. build driver CONFIG_BRCMDBG=y and load with module param 'debug=0x1416'. The problem is probably when the firmware is configured.

Logs from driver load at boot:
https://gist.github.com/dsd/7f9a7e8b0f8e20794aaed6298b2cb96a

Logs from interface up:
https://gist.github.com/dsd/13909ed821f7429e6be6a97ed91a61af

Logs from connection attempt:
https://gist.github.com/dsd/ae4a664c45e3d379d765231d96ae20d7

By the way, I noticed that the new parameter is called assoc_retry_max.
However here the problem is at the authentication stage. We do not
reach association.
Does assoc_retry_max also affect the authentication codepath, or is
there an equivalent parameter for retrying auth?

Thanks
Daniel
