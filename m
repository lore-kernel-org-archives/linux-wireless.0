Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbeEBM7S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 08:59:18 -0400
Date: Wed, 2 May 2018 15:59:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] Add ath6kl cleaned up driver
Message-ID: <20180502125908.GA25881@mwanda> (sfid-20180502_145922_584539_E2EB33CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle Valo,

The patch bdcd81707973: "Add ath6kl cleaned up driver" from Jul 18,
2011, leads to the following static checker warning:

	drivers/net/wireless/ath/ath6kl/wmi.c:1189 ath6kl_wmi_pstream_timeout_event_rx()
	error: buffer overflow 'wmi->stream_exist_for_ac' 4 <= 255 user_rl='0-255'

drivers/net/wireless/ath/ath6kl/wmi.c
  1171  /* Inactivity timeout of a fatpipe(pstream) at the target */
  1172  static int ath6kl_wmi_pstream_timeout_event_rx(struct wmi *wmi, u8 *datap,
  1173                                                 int len)
  1174  {
  1175          struct wmi_pstream_timeout_event *ev;
  1176  
  1177          if (len < sizeof(struct wmi_pstream_timeout_event))
  1178                  return -EINVAL;
  1179  
  1180          ev = (struct wmi_pstream_timeout_event *) datap;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Smatch distrusts "datap" because it comes from skb->data on the recieve
path.

  1181  
  1182          /*
  1183           * When the pstream (fat pipe == AC) timesout, it means there were
  1184           * no thinStreams within this pstream & it got implicitly created
  1185           * due to data flow on this AC. We start the inactivity timer only
  1186           * for implicitly created pstream. Just reset the host state.
  1187           */
  1188          spin_lock_bh(&wmi->lock);
  1189          wmi->stream_exist_for_ac[ev->traffic_class] = 0;
                                         ^^^^^^^^^^^^^^^^^
How do we know it's less than 4?

  1190          wmi->fat_pipe_exist &= ~(1 << ev->traffic_class);
  1191          spin_unlock_bh(&wmi->lock);
  1192  
  1193          /* Indicate inactivity to driver layer for this fatpipe (pstream) */
  1194          ath6kl_indicate_tx_activity(wmi->parent_dev, ev->traffic_class, false);
  1195  
  1196          return 0;
  1197  }

regards,
dan carpenter
