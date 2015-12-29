Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33925 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbbL2Ur7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 15:47:59 -0500
Received: by mail-lf0-f42.google.com with SMTP id y184so217450336lfc.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Dec 2015 12:47:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450100394-17414-4-git-send-email-arend@broadcom.com>
References: <1450100394-17414-1-git-send-email-arend@broadcom.com> <1450100394-17414-4-git-send-email-arend@broadcom.com>
From: Mathy Vanhoef <vanhoefm@gmail.com>
Date: Tue, 29 Dec 2015 21:47:38 +0100
Message-ID: <CAFXAJYwoQRVi_10L5475g1NU5+Abfvv==R6U4P2_rdb=yCPOcw@mail.gmail.com> (sfid-20151229_214807_615033_60682026)
Subject: Re: [PATCH 3/7] brcmfmac: Add support for scheduled scan mac randomization
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2015 at 2:39 PM, Arend van Spriel <arend@broadcom.com> wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> Scheduled scan be requested to use mac randomization. This patch
> checks the flags and enables the randomization if desired.

The driver also needs to advertise support for this using the
NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR flag, if the firmware
supports it. This can be done in brcmf_setup_wiphy. Otherwise
tools like wpa_supplicant won't use randomization.

Kr,
Mathy
