Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:45681 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424AbZKGCKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 21:10:32 -0500
Received: from [192.168.10.7] (builder.redfish-solutions.com [192.168.10.7])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.3/8.14.3) with ESMTP id nA72Aa3Y006607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2009 19:10:37 -0700
Message-ID: <4AF4D71B.5000907@redfish-solutions.com>
Date: Fri, 06 Nov 2009 18:10:35 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Also breakage in compat-wireless-2.6 when compiled against 2.6.27.29
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also seeing breakage in the libertas driver:

  CC [M]  /home/philipp/kernel/build_i586/compat-wireless-2009-11-01/drivers/net/wireless/libertas/assoc.o
  CC [M]  /home/philipp/kernel/build_i586/compat-wireless-2009-11-01/drivers/net/wireless/libertas/cfg.o
  CC [M]  /home/philipp/kernel/build_i586/compat-wireless-2009-11-01/drivers/net/wireless/ath/ath9k/eeprom_9287.o
/home/philipp/kernel/build_i586/compat-wireless-2009-11-01/drivers/net/wireless/libertas/assoc.c: In function 'lbs_ret_802_11_rssi':
/home/philipp/kernel/build_i586/compat-wireless-2009-11-01/drivers/net/wireless/libertas/assoc.c:483: error: implicit declaration of function 'get_unaligned_le16'
make[5]: *** [/home/philipp/kernel/build_i586/compat-wireless-2009-11-01/drivers/net/wireless/libertas/assoc.o] Error 1


I was thinking of adding bracketing to config.mk to make it easy to turn this off as well...

-Philip


