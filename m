Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38039 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbdHJMZt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 08:25:49 -0400
Date: Thu, 10 Aug 2017 15:23:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: karun256@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] rsi: add support for U-APSD power save
Message-ID: <20170809201232.ylzsprsmx2haju6u@mwanda> (sfid-20170810_142554_448534_7687CB22)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Karun Eagalapati,

The patch db07971d085f: "rsi: add support for U-APSD power save" from
Aug 3, 2017, leads to the following static checker warning:

	drivers/net/wireless/rsi/rsi_91x_mac80211.c:575 rsi_mac80211_bss_info_changed()
	warn: inconsistent indenting

drivers/net/wireless/rsi/rsi_91x_mac80211.c
   555          mutex_lock(&common->mutex);
   556          if (changed & BSS_CHANGED_ASSOC) {
   557                  rsi_dbg(INFO_ZONE, "%s: Changed Association status: %d\n",
   558                          __func__, bss_conf->assoc);
   559                  if (bss_conf->assoc) {
   560                          /* Send the RX filter frame */
   561                          rx_filter_word = (ALLOW_DATA_ASSOC_PEER |
   562                                            ALLOW_CTRL_ASSOC_PEER |
   563                                            ALLOW_MGMT_ASSOC_PEER);
   564                          rsi_send_rx_filter_frame(common, rx_filter_word);
   565                  }
   566                  rsi_inform_bss_status(common,
   567                                        bss_conf->assoc,
   568                                        bss_conf->bssid,
   569                                        bss_conf->qos,
   570                                        bss_conf->aid);
   571                  adapter->ps_info.dtim_interval_duration = bss->dtim_period;
   572                  adapter->ps_info.listen_interval = conf->listen_interval;
   573  
   574          /* If U-APSD is updated, send ps parameters to firmware */
   575          if (bss->assoc) {

Is this supposed to be inside the if BSS_CHANGED_ASSOC if statement or
after?

   576                  if (common->uapsd_bitmap) {
   577                          rsi_dbg(INFO_ZONE, "Configuring UAPSD\n");
   578                          rsi_conf_uapsd(adapter);
   579                  }
   580          } else {
   581                  common->uapsd_bitmap = 0;
   582          }
   583          }
   584  
   585          if (changed & BSS_CHANGED_CQM) {

regards,
dan carpenter
