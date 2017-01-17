Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdAQL7t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 06:59:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/9] rt2800usb: remove watchdog
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1483707918-31480-2-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-2-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Message-Id: <20170117115910.48E14605A3@smtp.codeaurora.org> (sfid-20170117_125954_380930_88FA979A)
Date: Tue, 17 Jan 2017 11:59:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On rt2800usb, if we do not get TX status from HW, we assume frames were
> posted and after entry->last_action timeout, we forcibly provide TX
> status to mac80211. So it's not possible to detect hardware TX hung
> based on the timeout. Additionally TXRQ_PCNT tells on number of frames
> in the Packet Buffer (buffer between bus interface and chip MAC
> subsystem), which can be non zero on normal conditions. To check HW hung
> we will need provide some different mechanism, for now remove watchdog
> as current implementation is wrong and not useful.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

8 patches applied to wireless-drivers-next.git, thanks.

480b468625da rt2800usb: remove watchdog
cfe82fbd8423 rt2800: increase TX timeout
15ec51b25e05 rt2x00: save conf settings before reset tuner
01d97ef4b25f rt2800: change default retry settings
e4019e7f9530 rt2800: tune TX_RTS_CFG config
170122169676 rt2800usb: mark tx failure on timeout
51583248187c rt2x00: do not flush empty queue
66ecec02e851 rt2800: set max_psdu to 3 on usb devices

-- 
https://patchwork.kernel.org/patch/9500917/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
