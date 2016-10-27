Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48958 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935162AbcJ0PGW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 11:06:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [19/28] brcmfmac: avoid maybe-uninitialized warning in
 brcmf_cfg80211_start_ap
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161017221355.1861551-7-arnd@arndb.de>
References: <20161017221355.1861551-7-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
Message-Id: <20161027150523.B600361656@smtp.codeaurora.org> (sfid-20161027_170751_111111_93B8E6CE)
Date: Thu, 27 Oct 2016 15:05:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:
> A bugfix added a sanity check around the assignment and use of the
> 'is_11d' variable, which looks correct to me, but as the function is
> rather complex already, this confuses the compiler to the point where
> it can no longer figure out if the variable is always initialized
> correctly:
> 
> brcm80211/brcmfmac/cfg80211.c: In function ‘brcmf_cfg80211_start_ap’:
> brcm80211/brcmfmac/cfg80211.c:4586:10: error: ‘is_11d’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> This adds an initialization for the newly introduced case in which
> the variable should not really be used, in order to make the warning
> go away.
> 
> Fixes: b3589dfe0212 ("brcmfmac: ignore 11d configuration errors")
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers.git, thanks.

d3532ea6ce4e brcmfmac: avoid maybe-uninitialized warning in brcmf_cfg80211_start_ap

-- 
https://patchwork.kernel.org/patch/9380763/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
