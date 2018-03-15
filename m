Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:42217 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbeCOG1K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 02:27:10 -0400
Received: by mail-oi0-f66.google.com with SMTP id c18so4787721oiy.9
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2018 23:27:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
References: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 15 Mar 2018 07:27:08 +0100
Message-ID: <CACna6ryiAqeW7Awr=o5yydBaTY=+TQmW0DvB6wFO+fQOwFJSgQ@mail.gmail.com> (sfid-20180315_072714_346663_478FBCF7)
Subject: Re: [PATCH] wireless: brcmfmac: cfg80211: Fix check for ISO3166 code
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>,"
        <brcm80211-dev-list@cypress.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 March 2018 at 20:02, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> The commit "regulatory: add NUL to request alpha2" increases the length of
> alpha2 to 3. This causes a regression on brcmfmac, because
> brcmf_cfg80211_reg_notifier() expect valid ISO3166 codes in the complete
> array. So fix this accordingly.
>
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>

It sounds like it's worth a:
Fixes: <sha> ("regulatory: add NUL to request alpha2")
