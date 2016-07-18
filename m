Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32951 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbcGRXYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 19:24:51 -0400
Received: by mail-pf0-f193.google.com with SMTP id i6so121699pfe.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 16:24:51 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: brcm80211-dev-list.pdl@broadcom.com
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
	hante.meuleman@broadcom.com,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 0/4] brcm80211: Misc coverity fixes
Date: Mon, 18 Jul 2016 16:24:33 -0700
Message-Id: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com> (sfid-20160719_012454_772030_B320CCB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patch series addresses several coverity issues, they all seemed relevant
to me.

There is also a ton of warnings in Coverity caused by brcmf_fil_iovar_int_get()
and friends because of the initial access:

__le32 data_le = cpu_to_le32(*data) which can utilize unitialized memory. I am
not sure if we actually care about any kind of initial, value, but if we don't,
then the fix should be fairly obvious.

Thanks!


Florian Fainelli (4):
  brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain
  brcmsmac: Free packet if dma_mapping_error() fails in dma_rxfill
  brcmsmac: Fix invalid memcpy() size in brcms_c_d11hdrs_mac80211
  brcmsmac: Initialize power in brcms_c_stf_ss_algo_channel_get()

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 +++-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c    | 4 +++-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c   | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c    | 2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.7.4

