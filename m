Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:36859 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab3BSAgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 19:36:54 -0500
Date: Tue, 19 Feb 2013 04:04:44 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: txpower setting regression
Message-ID: <alpine.DEB.2.02.1302190349180.12894@icf.org.ru> (sfid-20130219_013658_949427_DAA370B1)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-635903113-1361232284=:12894"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-635903113-1361232284=:12894
Content-Type: TEXT/PLAIN; format=flowed; charset=KOI8-R
Content-Transfer-Encoding: 8BIT


Hi all, there is some kind of regression with setting transmit power, hardware is warious
ar9280 cards, all work as sould with compat-wireless-3.6 and compat-drivers-2013-02-13, i 
have modified regulatory database:

iw reg get
country RU:
     (2402 - 2494 @ 40), (24, 23)
     (5030 - 5835 @ 40), (24, 23)

with compat-wireless-3.6 and compat-drivers-2013-02-13 i can change txpower in this rules,
iw list show channels and it's power according to database rules:

                 Frequencies:
                         * 2412 MHz [1] (23.0 dBm)
                         * 2417 MHz [2] (23.0 dBm)
                         * 2422 MHz [3] (23.0 dBm)
                         * 2427 MHz [4] (23.0 dBm)
                         * 2432 MHz [5] (23.0 dBm)
                         * 2437 MHz [6] (23.0 dBm)
                         * 2442 MHz [7] (23.0 dBm)
                         * 2447 MHz [8] (23.0 dBm)
                         * 2452 MHz [9] (23.0 dBm)
                         * 2457 MHz [10] (23.0 dBm)
                         * 2462 MHz [11] (23.0 dBm)
                         * 2467 MHz [12] (23.0 dBm)
                         * 2472 MHz [13] (23.0 dBm)
                         * 2484 MHz [14] (23.0 dBm)

but with compat-drivers 3.7.6 and 3.8-rc7 i cannot set power level, 
iw phy phy0 set txpower fixed 10/limit 10/iw dev dev0/etc give same 
error - command failed: Operation not supported (-95), and iw list 
give strange output like this:

                 Frequencies:
                         * 2412 MHz [1] (20.0 dBm)
                         * 2417 MHz [2] (21.0 dBm)
                         * 2422 MHz [3] (21.0 dBm)
                         * 2427 MHz [4] (21.0 dBm)
                         * 2432 MHz [5] (21.0 dBm)
                         * 2437 MHz [6] (21.0 dBm)
                         * 2442 MHz [7] (21.0 dBm)
                         * 2447 MHz [8] (21.0 dBm)
                         * 2452 MHz [9] (21.0 dBm)
                         * 2457 MHz [10] (21.0 dBm)
                         * 2462 MHz [11] (20.0 dBm)
                         * 2467 MHz [12] (23.0 dBm)
                         * 2472 MHz [13] (23.0 dBm)
 		        * 2484 MHz [14] (23.0 dBm)

and channel levels different on different cards.


C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-635903113-1361232284=:12894--
