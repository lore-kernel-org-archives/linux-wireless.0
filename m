Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53666 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaJGLaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 07:30:35 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so4918815pdi.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2014 04:30:34 -0700 (PDT)
Received: from Mac-Pro.local ([147.46.243.214])
        by mx.google.com with ESMTPSA id d4sm13639940pdk.41.2014.10.07.04.30.31
        for <linux-wireless@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Tue, 07 Oct 2014 04:30:33 -0700 (PDT)
Date: Tue, 7 Oct 2014 20:30:27 +0900
From: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
To: linux-wireless@vger.kernel.org
Message-ID: <etPan.5433ced3.74b0dc51.2d48@Mac-Pro.local> (sfid-20141007_133038_592402_7849923B)
Subject: How to know the information about RTS reception in mac80211 or
 device driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

We are trying to develop an algorithm by using the information of RTS reception at the receiver side. (actually, we need the preceding frame of A-MPDU). 
As far as we know, RTS/CTS exchange is done by firmware of NIC.
However, in monitor mode, we quite sure that the RTS/CTS frame reception should be reported to upper layer.
As an evidence, Wireshark can capture and display the RTS/CTS reception. 

However, mac80211 and device driver (e.g., ath10k) can not recognize the reception of RTS even if we put the WiFi NIC in monitor mode.
We check the type and subtype of frame_control field for all the received frames at the “ieee80211_rx_monitor” function of mac80211.
We can find the reception of data frames amd mgmt frames, but there is no RTS/CTS frame.
(We confirm that there is the RTS/CTS frame by using wireshark.)

Is there any way to know the information about RTS reception in mac80211 or device driver?

Thank you. 

--
Okhwan Lee,


