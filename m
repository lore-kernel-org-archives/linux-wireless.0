Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:17838 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758068AbdLROgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 09:36:43 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: qca_merez <qca_merez@qca.qualcomm.com>,
        QCA_ailizaro <QCA_ailizaro@QCA.qualcomm.com>,
        qca_dlansky <qca_dlansky@qca.qualcomm.com>,
        QCA_hkadmany <QCA_hkadmany@QCA.qualcomm.com>,
        qca_liord <qca_liord@qca.qualcomm.com>,
        QCA_gidons <QCA_gidons@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wil6210: fix build warnings without CONFIG_PM
Date: Mon, 18 Dec 2017 14:36:37 +0000
Message-ID: <87zi6gje6j.fsf@kamboji.qca.qualcomm.com> (sfid-20171218_153727_455909_9EE20184)
References: <20171218134604.3087909-1-arnd@arndb.de>
In-Reply-To: <20171218134604.3087909-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 18 Dec 2017 14:45:51 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> The #ifdef checks are hard to get right, in this case some functions
> should have been left inside a CONFIG_PM_SLEEP check as seen by this
> message:
>
> drivers/net/wireless/ath/wil6210/pcie_bus.c:489:12: error: 'wil6210_pm_re=
sume' defined but not used [-Werror=3Dunused-function]
> drivers/net/wireless/ath/wil6210/pcie_bus.c:484:12: error: 'wil6210_pm_su=
spend' defined but not used [-Werror=3Dunused-function]
>
> Using an __maybe_unused is easier here, so I'm replacing all the
> other #ifdef in this file as well for consistency.
>
> Fixes: 94162666cd51 ("wil6210: run-time PM when interface down")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

A note to myself (unfortunately patchwork doesn't have any way to add
notes to patches): 94162666cd51 is in wireless-drivers-next so this
patch should also go to -next.

--=20
Kalle Valo=
