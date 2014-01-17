Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ir2.yahoo.com ([212.82.96.69]:32630 "EHLO
	nm7.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbaAQQcy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 11:32:54 -0500
Message-ID: <1389976009.26074.YahooMailNeo@web172803.mail.ir2.yahoo.com> (sfid-20140117_173257_636111_93260E44)
Date: Fri, 17 Jan 2014 16:26:49 +0000 (GMT)
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
