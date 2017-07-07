Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35854 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdGGKUi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 06:20:38 -0400
Date: Fri, 7 Jul 2017 13:19:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "security@kernel.org" <security@kernel.org>
Subject: Re: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
Message-ID: <20170707101939.3mgdgc4pvjg6dyyx@mwanda> (sfid-20170707_122042_213442_4DC1C028)
References: <88f27bfd328f4ccdb0d6b7ff7e710819@MWHPR06MB3230.namprd06.prod.outlook.com>
 <d2c78377-5608-b6c3-07d8-17dfc56a5c7e@broadcom.com>
 <CA+55aFxGacqVMDN0pETkd9Ho554wR8ACvTZhxK6p6M6CtUc_DA@mail.gmail.com>
 <20170707084640.cv3igibbhhmgsmta@mwanda>
 <a2496a2e-9258-7cc9-3c04-87886f0029cd@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a2496a2e-9258-7cc9-3c04-87886f0029cd@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Speaking of underflows:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
  4913          if (ieee80211_is_probe_resp(mgmt->frame_control)) {
  4914                  /* Right now the only reason to get a probe response */
  4915                  /* is for p2p listen response or for p2p GO from     */
  4916                  /* wpa_supplicant. Unfortunately the probe is send   */
  4917                  /* on primary ndev, while dongle wants it on the p2p */
  4918                  /* vif. Since this is only reason for a probe        */
  4919                  /* response to be sent, the vif is taken from cfg.   */
  4920                  /* If ever desired to send proberesp for non p2p     */
  4921                  /* response then data should be checked for          */
  4922                  /* "DIRECT-". Note in future supplicant will take    */
  4923                  /* dedicated p2p wdev to do this and then this 'hack'*/
  4924                  /* is not needed anymore.                            */
  4925                  ie_offset =  DOT11_MGMT_HDR_LEN +
  4926                               DOT11_BCN_PRB_FIXED_LEN;
  4927                  ie_len = len - ie_offset;
                                 ^^^^^^^^^^^^^^^
This can underflow.  It's harmless, but it's annoying for me as a static
checker person because this is the line where I'd like to print a
warning but everyone will complain it's a "false positive".

  4928                  if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif)
  4929                          vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
  4930                  err = brcmf_vif_set_mgmt_ie(vif,
  4931                                              BRCMF_VNDR_IE_PRBRSP_FLAG,
  4932                                              &buf[ie_offset],
  4933                                              ie_len);
  4934                  cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
  4935                                          GFP_KERNEL);

regards,
dan carpenter
