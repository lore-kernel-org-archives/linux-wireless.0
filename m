Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:44804 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbcFNPqM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 11:46:12 -0400
Message-ID: <576017D8.9080207@ispras.ru> (sfid-20160614_174651_025621_97916E98)
Date: Tue, 14 Jun 2016 18:42:32 +0400
From: Pavel Andrianov <andrianov@ispras.ru>
MIME-Version: 1.0
To: Eugene Krasnikov <k.eugene.e@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
	Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: [ldv-project] [net] wcn36xx: potential race condition
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

There is a potential race condition in 
drivers/net/wireless/ath/wcn36xx/wcn36xx.ko. In wcn36xx_tx -> 
wcn36xx_start_tx -> wcn36xx_set_tx_data 
(http://lxr.free-electrons.com/source/drivers/net/wireless/ath/wcn36xx/txrx.c#L176) 
there is a read of sta_priv->bss_dpu_desc_index and 
sta_priv->bss_sta_index. In wcn36xx_bss_info_changed -> 
wcn36xx_smd_config_bss -> wcn36xx_smd_config_bss_rsp 
(http://lxr.free-electrons.com/source/drivers/net/wireless/ath/wcn36xx/smd.c#L1204) 
there is a write to the same fields. It  seems that the handlers may be 
called in parallel and inconsistent data may be obtained.
The same problem is with sta_priv->sta_index and 
sta_priv->sta_dpu_desc_index:
http://lxr.free-electrons.com/source/drivers/net/wireless/ath/wcn36xx/txrx.c#L181 

http://lxr.free-electrons.com/source/drivers/net/wireless/ath/wcn36xx/smd.c#L986 

Is it a real bug? Is it enough to add mutex_lock to wcn36xx_set_tx_data?

-- 
Pavel Andrianov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
e-mail: andrianov@ispras.ru

