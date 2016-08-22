Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33200 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbcHVIko (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 04:40:44 -0400
Received: by mail-wm0-f43.google.com with SMTP id d196so19699286wmd.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2016 01:40:43 -0700 (PDT)
Message-ID: <1471855240.16921.6.camel@open-mesh.com> (sfid-20160822_104102_050195_81B324AB)
Subject: Re: ath9k: Fix beacon configuration assertion failure
From: Benjamin Berg <benjamin.berg@open-mesh.com>
To: Kalle Valo <kvalo@codeaurora.org>, Adi Ratiu <adi@adirat.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k-devel@lists.ath9k.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 22 Aug 2016 10:40:40 +0200
In-Reply-To: <87fuq1yt1x.fsf@kamboji.qca.qualcomm.com>
References: <fb48526fcf8f4b6db25c20b727c4a3d5@euamsexm01a.eu.qualcomm.com>
         <87fuq1yt1x.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fr, 2016-08-19 at 13:03 +0300, Kalle Valo wrote:
> Actually, I see two patches which might be related but not identical:
> 
> ath9k: fix client mode beacon configuration
> https://patchwork.kernel.org/patch/9247699/
> 
> ath9k: Fix beacon configuration assertion failure
> https://patchwork.kernel.org/patch/9281191/
> 
> Felix (CCed) & Benjamin: please take a look and advice which one I
> should take.

Yes, both patches are designed to fix the same issue in my patch.

Felix solution looks entirely correct to me, the second solution seems
slightly wrong because it prevents the call to ath9k_beacon_config from
happening instead of ensuring the correct parameter value.
ath9k_beacon_config needs to be called even if iter_data.beacons is
false as it disables the interrupts.

Benjamin
