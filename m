Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33558 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbbKXO1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 09:27:54 -0500
Date: Tue, 24 Nov 2015 17:27:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: bzhao@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: re: wireless: mwifiex: initial commit for Marvell mwifiex driver
Message-ID: <20151124142745.GA24420@mwanda> (sfid-20151124_152758_183118_ADAB3794)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Bing Zhao,

The patch 5e6e3a92b9a4: "wireless: mwifiex: initial commit for
Marvell mwifiex driver" from Mar 21, 2011, leads to the following
static checker warning:

	drivers/net/wireless/marvell/mwifiex/sta_event.c:634 mwifiex_process_sta_event()
	warn: inconsistent indenting

drivers/net/wireless/marvell/mwifiex/sta_event.c
   608          case EVENT_PS_AWAKE:
   609                  mwifiex_dbg(adapter, EVENT, "info: EVENT: AWAKE\n");
   610                  if (!adapter->pps_uapsd_mode && priv->port_open &&
   611                      priv->media_connected && adapter->sleep_period.period) {
   612                                  adapter->pps_uapsd_mode = true;
   613                                  mwifiex_dbg(adapter, EVENT,
   614                                              "event: PPS/UAPSD mode activated\n");
   615                  }
   616                  adapter->tx_lock_flag = false;
   617                  if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
   618                          if (mwifiex_check_last_packet_indication(priv)) {
   619                                  if (adapter->data_sent ||
   620                                      (adapter->if_ops.is_port_ready &&
   621                                       !adapter->if_ops.is_port_ready(priv))) {
   622                                          adapter->ps_state = PS_STATE_AWAKE;
   623                                          adapter->pm_wakeup_card_req = false;
   624                                          adapter->pm_wakeup_fw_try = false;
   625                                          del_timer(&adapter->wakeup_timer);
   626                                          break;
   627                                  }
   628                                  if (!mwifiex_send_null_packet
   629                                          (priv,
   630                                           MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET |
   631                                           MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET))
   632                                                  adapter->ps_state =
   633                                                          PS_STATE_SLEEP;
   634                                          return 0;


The PS_STATE_SLEEP line is indented one tab more than it should be.  It
looks like the code is buggy?  Possibly curly braces were intended:

					if (!mwifiex_send_null_packet(priv,
                                                    MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET |
                                                    MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET)) {
                                                adapter->ps_state = PS_STATE_SLEEP;
                                                return 0;
					}

We're right up against the 80 character limit so it's hard to be sure.

   635                          }
   636                  }
   637                  adapter->ps_state = PS_STATE_AWAKE;
   638                  adapter->pm_wakeup_card_req = false;
   639                  adapter->pm_wakeup_fw_try = false;
   640                  del_timer(&adapter->wakeup_timer);
   641  
   642                  break;
   643  
   644          case EVENT_DEEP_SLEEP_AWAKE:

regards,
dan carpenter
