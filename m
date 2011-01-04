Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:43773 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab1ADUKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 15:10:07 -0500
Received: from macbook.redfish-solutions.com (71-34-114-78.ptld.qwest.net [71.34.114.78])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.4/8.14.4) with ESMTP id p04K01ln012825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 4 Jan 2011 13:00:07 -0700
Message-ID: <4D237C41.70607@redfish-solutions.com>
Date: Tue, 04 Jan 2011 12:00:01 -0800
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Breakage in rtlwifi/base.c for 2010-12-24
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anyone else seeing the following breakage?  I'm building the 2010-12-24 snapshot against 2.6.27.49:

   CC [M]  /home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi/base.o
/home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi/base.c: In function '_rtl_init_deferred_work':
/home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi/base.c:229: error: implicit declaration of function 'alloc_workqueue'
/home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi/base.c:229: warning: assignment makes pointer from integer without a cast
make[5]: *** [/home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi/base.o] Error 1
make[4]: *** [/home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi] Error 2
make[3]: *** [/home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless] Error 2
make[2]: *** [_module_/home/philipp/astlinux/build_i586/compat-wireless-2010-12-24] Error 2
make[2]: Leaving directory `/home/philipp/astlinux/build_i586/linux-2.6.27.49-astlinux'
make[1]: *** [modules] Error 2
make[1]: Leaving directory `/home/philipp/astlinux/build_i586/compat-wireless-2010-12-24'
make: *** [/home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/net/wireless/lib80211.ko] Error 2


