Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:58554 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163639AbdEXLl7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 07:41:59 -0400
Date: Wed, 24 May 2017 07:33:43 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Franky Lin <franky.lin@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Subject: brcmfmac experiment for a specific use case - tx throughput
 maximization for slow CPU with glomming
Message-ID: <20170524073326.3a16481b@Vantage> (sfid-20170524_134401_217016_0FE29C90)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


I've crippled a Raspberry Pi 3 (1 core, 200 MHz) and observed that the
glomming feature has a definite impact on TX performance, but it looks
like at this CPU frequency, the work queue is solicited "too often"
by brcmf_sdio_trigger_dpc() and glomming is only doing 4 packets at
once, resulting in maybe a sub-optimal throughput.


I have a vague idea that deliberately delaying the transmissions so as
to wait for either a small timeout, or the glomming level has been
reached, would be something worth exploring.
But I haven't spent a long time looking at the driver.


I'm just soliciting your advice at this point, I'll do some experiments
also.


Best regards,

--=20
J=C3=A9r=C3=B4me
