Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37538 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755464AbdCGLFu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 06:05:50 -0500
Received: by mail-wm0-f53.google.com with SMTP id n11so1542391wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 03:05:35 -0800 (PST)
Subject: Re: [PATCH v2 4/4] brcmfmac: Handle status == BRCMF_E_STATUS_ABORT in
 cfg80211_escan_handler
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170227214539.16422-1-hdegoede@redhat.com>
 <20170227214539.16422-4-hdegoede@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0618adea-03d2-9991-0ccf-1e985f274fe7@broadcom.com> (sfid-20170307_120625_640002_AD5707CD)
Date: Tue, 7 Mar 2017 11:06:07 +0100
MIME-Version: 1.0
In-Reply-To: <20170227214539.16422-4-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-2-2017 22:45, Hans de Goede wrote:
> If a scan gets aborted BRCMF_SCAN_STATUS_BUSY gets cleared in
> cfg->scan_status and when we receive an abort event from the firmware
> the BRCMF_SCAN_STATUS_BUSY check in the cfg80211_escan_handler will
> trigger resulting in multiple errors getting logged.
> 
> Check for a status of BRCMF_E_STATUS_ABORT and in this case simply
> cleanly exit the cfg80211_escan_handler. This also avoids a
> BRCMF_E_STATUS_ABORT event arriving after a new scan has been started
> causing the new scan to complete prematurely without any data.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +++
>  1 file changed, 3 insertions(+)
