Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35342 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754029AbcKUOQb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 09:16:31 -0500
Received: by mail-wm0-f52.google.com with SMTP id a197so149415699wmd.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 06:16:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161121140423.24367-1-benjamin@sipsolutions.net>
References: <20161121140423.24367-1-benjamin@sipsolutions.net>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 21 Nov 2016 15:16:29 +0100
Message-ID: <CA+BoTQkucZn7prTns-GB0435+UnVx-0Q4H2AuV-mYLNNYLMZ9w@mail.gmail.com> (sfid-20161121_151644_146872_0BF510B0)
Subject: Re: [PATCH] ath9k: Prevent radar detection and spectral scan to be
 used concurrently
To: Benjamin Berg <benjamin@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 November 2016 at 15:04, Benjamin Berg <benjamin@sipsolutions.net> wro=
te:
> In the case that a spectral scan is enabled the PHY errors sent by the
> hardware as part of the scanning might trigger the radar detection and
> channels might be marked as 'unusable' incorrectly. This patch fixes
> the issue by preventing the spectral scan to be enabled if DFS is used
> and only analysing the PHY errors for DFS if radar detection is enabled.

According to the comment in ath_cmn_process_fft() this doesn't seem to
be necessary for all chips:

 515         /* AR9280 and before report via ATH9K_PHYERR_RADAR,
AR93xx and newer
 516          * via ATH9K_PHYERR_SPECTRAL. Haven't seen
ATH9K_PHYERR_FALSE_RADAR_EXT
 517          * yet, but this is supposed to be possible as well.
 518          */
 519         if (rs->rs_phyerr !=3D ATH9K_PHYERR_RADAR &&
 520             rs->rs_phyerr !=3D ATH9K_PHYERR_FALSE_RADAR_EXT &&
 521             rs->rs_phyerr !=3D ATH9K_PHYERR_SPECTRAL)
 522                 return 0;


Micha=C5=82
