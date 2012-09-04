Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43820 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2IDQNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 12:13:31 -0400
Date: Tue, 4 Sep 2012 19:13:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mac80211: support P2P Device abstraction
Message-ID: <20120904161319.GA11494@elgon.mountain> (sfid-20120904_181334_957253_117FCC5D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes Berg,

This is a semi-automatic email about new static checker warnings.

The patch f142c6b906da: "mac80211: support P2P Device abstraction" 
from Jun 18, 2012, leads to the following Smatch complaint:

net/mac80211/iface.c:1168 ieee80211_setup_sdata()
	 error: we previously assumed 'sdata->dev' could be null (see line 1134)

net/mac80211/iface.c
  1133		/* only monitor/p2p-device differ */
  1134		if (sdata->dev) {
                    ^^^^^^^^^^
New test.

  1135			sdata->dev->netdev_ops = &ieee80211_dataif_ops;
  1136			sdata->dev->type = ARPHRD_ETHER;
  1137		}

[snip]

  1167		case NL80211_IFTYPE_MONITOR:
  1168			sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
                        ^^^^^^^^^^^^
Old dereference.

  1169			sdata->dev->netdev_ops = &ieee80211_monitorif_ops;
  1170			sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |

regards,
dan carpenter

