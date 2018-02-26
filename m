Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33177 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbeBZIps (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 03:45:48 -0500
Received: by mail-wr0-f196.google.com with SMTP id s5so20285261wra.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2018 00:45:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
References: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
From: Adrian Chadd <adrian@freebsd.org>
Date: Mon, 26 Feb 2018 00:45:45 -0800
Message-ID: <CAJ-Vmo=xxG_Jp=uC-Cx96R0YzO8O0tOVe2G6Nyx8ceWopiwvXQ@mail.gmail.com> (sfid-20180226_094552_389246_15FD134E)
Subject: Re: [PATCH] Revert "ath10k: send (re)assoc peer command when NSS changed"
To: Karthikeyan Periyasamy <periyasa@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi!

On 25 February 2018 at 22:16, Karthikeyan Periyasamy
<periyasa@codeaurora.org> wrote:
> This reverts commit 55884c045d31a29cf69db8332d1064a1b61dd159.
>
> When Ath10k is in AP mode and an unassociated STA sends a VHT action frame
> (Operating Mode Notification for the NSS change) periodically to AP this causes
> ath10k to call ath10k_station_assoc() which sends WMI_PEER_ASSOC_CMDID during
> NSS update. Over the time (with a certain client it can happen within 15 mins
> when there are over 500 of these VHT action frames) continuous calls of
> WMI_PEER_ASSOC_CMDID cause firmware to assert due to resource exhaust.
>
> To my knowledge setting WMI_PEER_NSS peer param itself enough to handle NSS
> updates and no need to call ath10k_station_assoc(). So revert the original
> commit from 2014 as it's unclear why the change was really needed.
> Now the firmware assert doesn't happen anymore.
>
> Issue observed in QCA9984 platform with firmware version:10.4-3.5.3-00053.
> This Change tested in QCA9984 with firmware version: 10.4-3.5.3-00053 and
> QCA988x platform with firmware version: 10.2.4-1.0-00036.

Did you test this on any of the other major firmware variants? I
wonder if it snuck in because of some firmware quirk in something way
before dakota/cascade and 10.4 were a thing.

Eg, Peregrine? Rome? Maybe even earlier Beeliner, just to double check?

Thanks,



-adrian
