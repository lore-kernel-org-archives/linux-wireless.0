Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:50919 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbZGMTfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 15:35:01 -0400
Message-ID: <4A5B8C60.9000600@gmail.com>
Date: Mon, 13 Jul 2009 21:34:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: yi.zhu@intel.com
CC: reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: iwl: potential deadlock?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we found a potential deadlock in iwl code by our tool.

Can this happen:
iwl_update_tkip_key()
-> spin_lock_irqsave(&priv->sta_lock)
-> iwl_send_add_sta()
   -> iwl_sta_ucode_activate()
      -> spin_lock_irqsave(&priv->sta_lock)
?

Thanks.
