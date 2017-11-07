Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0077.outbound.protection.outlook.com ([104.47.2.77]:42306
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933920AbdKGOsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 09:48:17 -0500
To: <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>
From: Per Mejdal Rasmussen <pmr@its.aau.dk>
Subject: Update regulatory rules for Denmark (DK) on 2.4 and 5GHz
Message-ID: <0b1762cd-761d-ebe3-a88e-4a2b1823c51f@its.aau.dk> (sfid-20171107_154842_395266_C0115C2A)
Date: Tue, 7 Nov 2017 15:48:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I have taken the time research which frequencies and power levels are 
allowed for WiFi in Denmark. So db.txt for wireless-regdb can be updated.


Allowed WiFi frequencies in Denmark for WiFi:
---------------------------------------------
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5875,0 MHz
57-66 GHz

Source: https://www.retsinformation.dk/Forms/R0710.aspx?id=189932
Search for "RLAN". The website is owned by the Danish government.


Maximum transmission strength and usage
---------------------------------------
2400-2483,5 MHz  ? mW/MHz   100 mW EIRP
5150-5250 MHz   10 mW/MHz   200 mW EIRP    Both in/outdoor allowed
5470-5725 MHz   50 mW/MHz     1 W EIRP     Both in/outdoor allowed
5725-5875 MHz  200 mW/MHz     4 W EIRP     BFWA only, 5795-5815 excluded
5725-5875 MHz    ? mW/MHz    25 mW EIRP    Short range devices
57-66 GHz       20 mW/MHz    10 W EIRP     No fixed outdoor install

DFS is required for 5250-5350, 5470-5725 and because of ETSI EN 301 893
DFS is required for 5725-5875 for BFWA, because of ETSI EN 302 502

Sources:
5GHz: 
https://erhvervsstyrelsen.dk/sites/default/files/007_interface-datanet_5-6_ghz.pdf.pdf
60GHz: 
https://erhvervsstyrelsen.dk/sites/default/files/radiograenseflader-63.pdf
The website is owned by the Danish government.


Outdated content of db.txt:
---------------------------
country DK: DFS-ETSI
     (2402 - 2482 @ 40), (20)
     (5170 - 5250 @ 80), (20), AUTO-BW
     (5250 - 5330 @ 80), (20), DFS, AUTO-BW
     (5490 - 5710 @ 160), (27), DFS
     # 60 GHz band channels 1-4, ref: Etsi En 302 567
     (57000 - 66000 @ 2160), (40)


Suggested fix:
--------------
country DK: DFS-ETSI
     (2400 - 2483.5 @ 40), (20)
     (5150 - 5250 @ 80), (23), AUTO-BW
     (5250 - 5350 @ 80), (23), DFS, AUTO-BW
     (5470 - 5725 @ 160), (30), DFS
     # Short Range Devices (ETSI EN 300 440-1)
     (5725 - 5875 @ 80), (14)
     # Broadband Fixed Wireless Access (ETSI EN 302 502)
     (5725 - 5795 @ 40), (36), PTP_ONLY, DFS
     (5815 - 5875 @ 40), (36), PTP_ONLY, DFS
     # 60 GHz band channels 1-4 (ETSI EN 302 567)
     (57000 - 66000 @ 2160), (40), NO-OUTDOOR



History of WiFi frequencies in Denmark for WiFi:
------------------------------------------------
 From 1999-09-07:
2400,0-2483,5 MHz
5150,0-5250,0 MHz

 From 2000-03-30
2400,0-2483,5 MHz
5150,0-5350,0 MHz

 From 2002-12-10
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
17,1-17,3 GHz

 From 2006-11-07
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5925,0 MHz
17,1-17,3 GHz

 From 2007-09-20
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5875,0 MHz
17,1-17,3 GHz

 From 2008-06-11
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5875,0 MHz

 From 2009-11-27 (current)
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5875,0 MHz
57-66 GHz

-- 
Per Mejdal Rasmussen
http://personprofil.aau.dk/109070
