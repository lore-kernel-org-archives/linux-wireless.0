Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25475 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbdASM2p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 07:28:45 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: qca_merez <qca_merez@qca.qualcomm.com>
CC: qca_liord <qca_liord@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH v2 01/13] wil6210: add sysfs file for FTM calibration
Date: Thu, 19 Jan 2017 12:24:19 +0000
Message-ID: <871svzp79p.fsf@kamboji.qca.qualcomm.com> (sfid-20170119_132925_969692_AAC1A3EA)
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1484226365-10433-2-git-send-email-qca_merez@qca.qualcomm.com>
In-Reply-To: <1484226365-10433-2-git-send-email-qca_merez@qca.qualcomm.com>
        (Maya Erez's message of "Thu, 12 Jan 2017 15:05:53 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> From: Lior David <qca_liord@qca.qualcomm.com>
>
> In fine timing measurements, the calculation is affected by
> 2 parts: timing of packets over the air, which is platform
> independent, and platform-specific delays, which are dependent
> on things like antenna cable length and type.
> Add a sysfs file which allows to get/set these platform specific
> delays, separated into the TX and RX components.
> There are 2 key scenarios where the file can be used:
> 1. Calibration - start with some initial values (for example,
> the default values at startup), make measurements at a known
> distance, then iteratively change the values until the
> measurement results match the known distance.
> 2. Adjust the delays when platform starts up, based on known
> values.
>
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Can't this go via nl80211? sysfs is not really supposed to be used for
something like this.

--=20
Kalle Valo=
