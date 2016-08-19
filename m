Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34858 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750889AbcHSPxy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 11:53:54 -0400
Received: by mail-oi0-f68.google.com with SMTP id e80so6462578oig.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2016 08:53:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1470894260-18128-1-git-send-email-wright.feng@cypress.com>
References: <1470894260-18128-1-git-send-email-wright.feng@cypress.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 19 Aug 2016 17:53:53 +0200
Message-ID: <CACna6rxLVkhzf0fea0ESbeBF4G-FK12JRBYNULosgVNRssyTiQ@mail.gmail.com> (sfid-20160819_175358_801732_87748252)
Subject: Re: [PATCH v2] brcmfmac: shut down AP and set IBSS mode only on
 primary interface
To: Wright Feng <wright.feng@cypress.com>
Cc: "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        chln@cypress.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 August 2016 at 07:44, Wright Feng <wright.feng@cypress.com> wrote:
> When stopping hostap on virtual interface, driver will set INFRA and AP
> mode that may affect the functionality on primary interface. For example,
> if we create and stop hostapd on virtual interface then association
> cannot work on primary interface because INFRA mode has been set to IBSS.
> Hence we shut down AP and set IBSS mode only on primary interface.

You also excluded from execution code setting BRCMF_C_SET_AP to 0.
Does it get a reset at some point? Maybe with a "bss" call? I'm
wondering if it's possible to use interface in managed mode if it was
used as AP once.

--=20
Rafa=C5=82
