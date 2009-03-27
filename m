Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37410 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZC0FL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 01:11:57 -0400
Received: by fxm2 with SMTP id 2so860532fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 22:11:54 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: p54spi - mesh mode summary
Date: Fri, 27 Mar 2009 08:03:54 +0300
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <200903260922.48489.jcmvbkbc@gmail.com> <1238055167.4331.3.camel@johannes.local>
In-Reply-To: <1238055167.4331.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903270803.54820.jcmvbkbc@gmail.com> (sfid-20090327_061204_890075_725A5E8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > 4) Pings don't go, because MPs don't answer ARP requests sent to it.
> > Haven't tested for the root cause yet.
>
> Maybe some multicast issue?

ARP requests get filtered out by LMAC.
Can anyone explain why? My 802.11s comprehension is quite weak.
Here's the packet:

IEEE 802.11 Data, Flags: ......FT
    Type/Subtype: Data (0x20)
    Frame Control: 0x0308 (Normal)
        Version: 0
        Type: Data frame (2)
        Subtype: 0
        Flags: 0x3
            DS status: WDS (AP to AP) or Mesh (MP to MP) Frame (To DS: 1 From DS: 1) (0x03)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: Broadcast (ff:ff:ff:ff:ff:ff)
    Transmitter address: NokiaDan_9b:ee:6c (00:1d:6e:9b:ee:6c)
    Destination address: Broadcast (ff:ff:ff:ff:ff:ff)
    Fragment number: 0
    Sequence number: 2
    Source address: NokiaDan_9b:ee:6c (00:1d:6e:9b:ee:6c)
    Mesh Header
        Address Extension 0
        Mesh TTL: 5
        Mesh Seq: 0
Logical-Link Control
    DSAP: SNAP (0xaa)
    IG Bit: Individual
    SSAP: SNAP (0xaa)
    CR Bit: Command
    Control field: U, func=UI (0x03)
        000. 00.. = Command: Unnumbered Information (0x00)
        .... ..11 = Frame type: Unnumbered frame (0x03)
    Organization Code: Encapsulated Ethernet (0x000000)
    Type: ARP (0x0806)
Address Resolution Protocol (request)
    Hardware type: Ethernet (0x0001)
    Protocol type: IP (0x0800)
    Hardware size: 6
    Protocol size: 4
    Opcode: request (0x0001)
    Sender MAC address: NokiaDan_9b:ee:6c (00:1d:6e:9b:ee:6c)
    Sender IP address: 192.168.4.13 (192.168.4.13)
    Target MAC address: 00:00:00_00:00:00 (00:00:00:00:00:00)
    Target IP address: 192.168.4.14 (192.168.4.14)


I'm tempted to do something like this in p54_setup_mac:

-               case NL80211_IFTYPE_MESH_POINT:
                        mode = P54_FILTER_TYPE_IBSS;
                        break;
+               case NL80211_IFTYPE_MESH_POINT:
+                       mode = P54_FILTER_TYPE_IBSS | P54_FILTER_TYPE_TRANSPARENT;
+                       break;

But I guess that's bad solution, at least for pci/usb drivers.
Christian, Johannes, what would you suggest?

-- 
Thanks.
-- Max
