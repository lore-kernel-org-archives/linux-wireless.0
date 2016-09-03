Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58115 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754030AbcICRCW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 13:02:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/1] brcmfmac: fix pmksa->bssid usage
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160823093717.1065-1-nicolas.iooss_linux@m4x.org>
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Message-Id: <20160903170222.1399E62180@smtp.codeaurora.org> (sfid-20160903_190242_818068_629D2BEF)
Date: Sat,  3 Sep 2016 17:02:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicolas Iooss <nicolas.iooss_linux@m4x.org> wrote:
> The struct cfg80211_pmksa defines its bssid field as:
> 
>     const u8 *bssid;
> 
> contrary to struct brcmf_pmksa, which uses:
> 
>     u8 bssid[ETH_ALEN];
> 
> Therefore in brcmf_cfg80211_del_pmksa(), &pmksa->bssid takes the address
> of this field (of type u8**), not the one of its content (which would be
> u8*).  Remove the & operator to make brcmf_dbg("%pM") and memcmp()
> behave as expected.
> 
> This bug have been found using a custom static checker (which checks the
> usage of %p... attributes at build time).  It has been introduced in
> commit 6c404f34f2bd ("brcmfmac: Cleanup pmksa cache handling code"),
> which replaced pmksa->bssid by &pmksa->bssid while refactoring the code,
> without modifying struct cfg80211_pmksa definition.
> 
> Replace &pmk[i].bssid with pmk[i].bssid too to make the code clearer,
> this change does not affect the semantic.
> 
> Fixes: 6c404f34f2bd ("brcmfmac: Cleanup pmksa cache handling code")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Thanks, 1 patch applied to wireless-drivers-next.git:

7703773ef1d8 brcmfmac: fix pmksa->bssid usage

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9295351/
