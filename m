Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28429 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020AbaFIJfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 05:35:30 -0400
Date: Mon, 9 Jun 2014 12:35:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: re: wil6210: improve debug for WMI receive
Message-ID: <20140609093518.GA10589@mwanda> (sfid-20140609_113537_426998_6B8E648C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Vladimir Kondratiev,

The patch a715c7ddd65a: "wil6210: improve debug for WMI receive" from
May 29, 2014, leads to the following static checker warning:

	drivers/net/wireless/ath/wil6210/wmi.c:746 wmi_recv_cmd()
	info: ignoring unreachable code.

drivers/net/wireless/ath/wil6210/wmi.c
   739                  spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
   740                  {
   741                          int q = queue_work(wil->wmi_wq,
   742                                             &wil->wmi_event_worker);
   743                          wil_dbg_wmi(wil, "queue_work -> %d\n", q);
   744                  }
   745          }
   746          if (n > 1)
                ^^^^^^^^^^
We never reach this if statemtent.

   747                  wil_dbg_wmi(wil, "%s -> %d events processed\n", __func__, n);
   748  }

regards,
dan carpenter
