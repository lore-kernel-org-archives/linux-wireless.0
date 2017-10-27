Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:38958 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbdJ0NdS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:33:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/12] wil6210: run-time PM when interface down
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1508937247-11890-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1508937247-11890-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <589009024f344a718e1616b30dd3edd0@euamsexm01a.eu.qualcomm.com> (sfid-20171027_153322_187004_413BCDA8)
Date: Fri, 27 Oct 2017 15:33:09 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:

> Allow run-time suspend when interface is down, keep card alive when
> interface is up.
> If driver is in wmi only or debug_fw mode run-time PM won't suspend.
> 
> Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
> 	pcie_bus.c
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kbuild bot found problems:

   drivers/net//wireless/ath/wil6210/pcie_bus.c: In function 'wil6210_pm_runtime_resume':
>> drivers/net//wireless/ath/wil6210/pcie_bus.c:511:2: error: implicit
>> declaration of function 'wil6210_resume'
>> [-Werror=implicit-function-declaration]
     return wil6210_resume(dev, true);
     ^
   drivers/net//wireless/ath/wil6210/pcie_bus.c: In function
'wil6210_pm_runtime_suspend':
>> drivers/net//wireless/ath/wil6210/pcie_bus.c:524:2: error: implicit
>> declaration of function 'wil6210_suspend'
>> [-Werror=implicit-function-declaration]
     return wil6210_suspend(dev, true);
     ^

-- 
https://patchwork.kernel.org/patch/10026675/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
