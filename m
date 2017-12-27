Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:53961 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdL0KEy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Dec 2017 05:04:54 -0500
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        Dedy Lansky <qca_dlansky@qualcomm.com>,
        Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        Lior David <qca_liord@qca.qualcomm.com>,
        Gidon Studinski <QCA_gidons@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wil6210: fix build warnings without CONFIG_PM
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171218134604.3087909-1-arnd@arndb.de>
References: <20171218134604.3087909-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Message-ID: <798460c2d6ed47dcb85c9540829a5ef8@euamsexm01a.eu.qualcomm.com> (sfid-20171227_110517_976305_144D62CA)
Date: Wed, 27 Dec 2017 11:04:43 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> The #ifdef checks are hard to get right, in this case some functions
> should have been left inside a CONFIG_PM_SLEEP check as seen by this
> message:
> 
> drivers/net/wireless/ath/wil6210/pcie_bus.c:489:12: error: 'wil6210_pm_resume' defined but not used [-Werror=unused-function]
> drivers/net/wireless/ath/wil6210/pcie_bus.c:484:12: error: 'wil6210_pm_suspend' defined but not used [-Werror=unused-function]
> 
> Using an __maybe_unused is easier here, so I'm replacing all the
> other #ifdef in this file as well for consistency.
> 
> Fixes: 94162666cd51 ("wil6210: run-time PM when interface down")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

203dab8395d9 wil6210: fix build warnings without CONFIG_PM

-- 
https://patchwork.kernel.org/patch/10119565/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
