Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:45288 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965834Ab2B2Gcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 01:32:47 -0500
Date: Wed, 29 Feb 2012 09:32:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jussi.kivilinna@mbnet.fi
Cc: linux-wireless@vger.kernel.org
Subject: re: rndis_wlan: split getting current channel to separate function
Message-ID: <20120229063234.GB18031@elgon.mountain> (sfid-20120229_073250_953212_48B33799)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jussi,

The patch b5257c952: "rndis_wlan: workaround device not returning bss
for currently connected AP" from Nov 9, 2011, leads to the following
warning:
drivers/net/wireless/rndis_wlan.c:1374:36: warning: cast to restricted __le16
drivers/net/wireless/rndis_wlan.c:1374:36: warning: cast from restricted __le32

  1372  
  1373          if (beacon_interval)
  1374                  *beacon_interval = le16_to_cpu(config.beacon_period);
  1375          return channel;

The problem is that config.beacon_period is declared as le32 but we're
using it as le16.

regards,
dan carpenter

