Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm6.bullet.mail.ird.yahoo.com ([77.238.189.63]:29348 "EHLO
	nm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbaARJJZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 04:09:25 -0500
Message-ID: <1390035774.57288.YahooMailNeo@web172805.mail.ir2.yahoo.com> (sfid-20140118_101007_733243_E227242D)
Date: Sat, 18 Jan 2014 09:02:54 +0000 (GMT)
From: Dani Camps <danicamps81@yahoo.com>
Reply-To: Dani Camps <danicamps81@yahoo.com>
Subject: Read VLAN Tag in mac80211
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I am having trouble reading a VLAN tag inside mac80211. I believe the tag is in the packet because I can see it in wireshark. This is a simple test code that I am using in tx.c:

#include <linux/if_vlan.h>

...
        unsigned short TCI;
        unsigned short id;
...

// Checking if VLAN tag is present
        if(vlan_tx_tag_present(skb)){
                TCI = vlan_tx_tag_get (skb);
                id = TCI & VLAN_VID_MASK;
                printk ("VLAN detection:  Detected frame with VLAN ID = %x \n", id);
        }
        else{
                printk ("VLAN detection:  No VLAN Tag detected but skb->vlan_tci is %x \n", skb->vlan_tci);
        }

The previous code always fails to enter the VLAN present case, and goes to the else condition printing a skb->vlan_tci value of zero, whereas I can see in wireshark a frame with a VLAN tag and VLAN ID=1.

Can anyone help me figure out what I am missing here?

Best Regards

Daniel

