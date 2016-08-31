Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23463 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933196AbcHaH7D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 03:59:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RESEND,
 v4] ath10k: Fix sending NULL/ Qos NULL data frames for QCA99X0 and
 later
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1469016659-1887-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Message-ID: <e8de2c3a1b534b4d9b6a9b60d0946111@euamsexm01a.eu.qualcomm.com> (sfid-20160831_095922_458151_8C679F2B)
Date: Wed, 31 Aug 2016 09:58:56 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> For chipsets like QCA99X0, IPQ4019 and later we are not getting proper
> NULL func status (always acked/successs !!) when hostapd does a
> PROBE_CLIENT via nullfunc frames when the station is powered off
> abruptly (inactive timer probes client via null func after the inactive
> time reaches beyond the threshold). Fix this by disabling the workaround
> introduced by the change ("ath10k: fix beacon loss handling ") for
> QCA99X0 and later chipsets. The normal tx path provides the proper
> status for NULL data frames. As of now disable this workaround for
> chipsets QCA99X0 and later, once the 10.1 firmware is obselete we can
> completely get rid of this workaround for all the chipsets
> 
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Superseded by:

[v5] ath10k: Fix broken NULL func data frame status for 10.4

https://patchwork.kernel.org/patch/9300961/

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9239481/
