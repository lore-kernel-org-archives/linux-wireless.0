Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36102 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbcGSJUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 05:20:49 -0400
Received: by mail-lf0-f46.google.com with SMTP id g62so8335369lfe.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 02:20:48 -0700 (PDT)
Subject: Re: [PATCH 0/4] brcm80211: Misc coverity fixes
To: Florian Fainelli <f.fainelli@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, hante.meuleman@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <bdbaa850-4ec4-9faf-dbae-e2a6dcc54e7c@broadcom.com> (sfid-20160719_112109_132275_342D1176)
Date: Tue, 19 Jul 2016 11:20:45 +0200
MIME-Version: 1.0
In-Reply-To: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Bob

On 19-7-2016 1:24, Florian Fainelli wrote:
> Hi,
> 
> This patch series addresses several coverity issues, they all seemed relevant
> to me.

Hi Florian,

Been a while so nice to see coverity fixes popping up. Actually
something that I have on my todo list to add our brcm80211 to coverity
within Broadcom. So being curious as to whether this comes from a public
coverity server like scan.coverity.com. Maybe bit redundant to setup
internally if there is a good coverity analysis publicly available.

> There is also a ton of warnings in Coverity caused by brcmf_fil_iovar_int_get()
> and friends because of the initial access:
> 
> __le32 data_le = cpu_to_le32(*data) which can utilize unitialized memory. I am
> not sure if we actually care about any kind of initial, value, but if we don't,
> then the fix should be fairly obvious.

If we are talking only about "get" variant than we mostly don't care.
Some getters support filter variables to be passed towards firmware. I
have not looked at the analysis to give any judgement here.

Regards,
Arend

> Thanks!
> 
> 
> Florian Fainelli (4):
>   brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain
>   brcmsmac: Free packet if dma_mapping_error() fails in dma_rxfill
>   brcmsmac: Fix invalid memcpy() size in brcms_c_d11hdrs_mac80211
>   brcmsmac: Initialize power in brcms_c_stf_ss_algo_channel_get()
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 +++-
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c    | 4 +++-
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c   | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c    | 2 +-
>  4 files changed, 8 insertions(+), 4 deletions(-)
> 
