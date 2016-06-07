Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:56070 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbcFGKeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 06:34:12 -0400
Message-ID: <57569424.9040906@ispras.ru> (sfid-20160607_123432_194820_F07704CD)
Date: Tue, 07 Jun 2016 13:30:12 +0400
From: Pavel Andrianov <andrianov@ispras.ru>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	vaishali.thakkar@oracle.com, LDV list <ldv-project@ispras.ru>
Subject: [ldv-project] [net] libertas: potential race condition
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

There is a potential race condition in 
drivers/net/wireless/libertas/libertas.ko.
In the function lbs_hard_start_xmit(..), line 159, a socket buffer is 
written to priv->current_skb with a spin_lock protection.
In the function lbs_mac_event_disconnected(..), lines 50-51, the field 
current_skb is cleaned. There is no protection used. The corresponding 
handlers are activated at the same time in lbs_start_card(..) and then 
may be executed simultaneously. Note, there are two structures 
lbs_netdev_ops and mesh_netdev_ops, which have the target handler 
lbs_hard_start_xmit.
Is it a real race or I have missed something?

-- 
Pavel Andrianov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
e-mail: andrianov@ispras.ru

