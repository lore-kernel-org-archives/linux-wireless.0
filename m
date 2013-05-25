Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2960 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab3EYLX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 07:23:59 -0400
Message-ID: <51A09F43.5030004@broadcom.com> (sfid-20130525_132403_789992_17900FE7)
Date: Sat, 25 May 2013 13:23:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jouni Malinen" <j@w1.fi>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jithu Jance" <jithu@broadcom.com>
Subject: P2P Device support: how to deal with p2p_no_group_iface option
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

I looked into issues around hwsim p2p tests and got all but one p2p test 
passing now (test_autogo_tdls). I had to remove the p2p_no_group_iface 
option from the p2px.conf files, because otherwise it tries to change 
the P2P management interface into a P2P group interface. When using 
P2P_DEVICE and P2P management interface this is not allowed by 
mac80211_hwsim. Also for brcmfmac the P2P_DEVICE interface is dedicated 
and can only be added/deleted, but not changed. Not sure if that is true 
for iwlmvm as well.

So I would like to discuss how to deal with the p2p_no_group_iface 
option. As P2P_DEVICE is a new concept the name of the option may no 
longer match what it intends. Is the option to force all P2P operations 
to be done on a single interface, ie. wlan0 (or whatever is specified on 
the command line) and no P2P_DEVICE is to be created. Or should it 
change the interface from the command line as P2P group interface.

If we can make a decision here I can finalize the P2P_DEVICE support 
changes.

Regards,
Arend

