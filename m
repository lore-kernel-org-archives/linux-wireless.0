Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35807 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbcCKPXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 10:23:17 -0500
Received: by mail-ig0-f174.google.com with SMTP id vf5so12794718igb.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2016 07:23:17 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Mar 2016 16:23:16 +0100
Message-ID: <CAOf5uwkT=Z2V3JadZeFKKU6m1sTozcC+ObEPzwR_qPuzv6X7Xw@mail.gmail.com> (sfid-20160311_162340_679467_5539ABAC)
Subject: Probelm on (brcmfmac: use pre-allocated scatter-gather table for txglomming)
From: Michael Trimarchi <michael@amarulasolutions.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I have a kernel panic on the brcmf_sdiod_sgtable_alloc just because
the function is called before brcmf_sdio_probe.

I think that
 nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE,
                      sdiodev->bus_if->drvr->settings->sdiod_txglomsz);

drvr is null. Can you explain how it can work or do you have already a
fix for this?

Michael
