Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:42348 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbeEKJVN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 05:21:13 -0400
MIME-Version: 1.0
In-Reply-To: <20180511091715.1989-1-zajec5@gmail.com>
References: <20180511091715.1989-1-zajec5@gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 11 May 2018 11:21:11 +0200
Message-ID: <CACna6ry-91oR1u697NRymLsN28fnnHDp9OQrdiVwA7A3KTV1fg@mail.gmail.com> (sfid-20180511_112139_024624_D245E879)
Subject: Re: [PATCH V2 1/2] Revert "ssb: Prevent build of PCI host features in module"
To: Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
        Larry Finger <larry.finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 May 2018 at 11:17, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> This reverts commit 882164a4a928bcaa53280940436ca476e6b1db8e.
>
> Above commit added "SSB =3D y" dependency to the wrong symbol
> SSB_DRIVER_PCICORE_POSSIBLE and prevented SSB_DRIVER_PCICORE from being
> selected when needed. PCI core driver for core running in clienthost
> mode is important for bus initialization. It's perfectly valid scenario
> to have ssb built as module and use it with buses on PCI cards.
>
> This fixes regression that affected all *module* users with PCI cards.
>
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D1572349
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>

As these patches fix regression/build error, I believe both should get
into 4.17.
