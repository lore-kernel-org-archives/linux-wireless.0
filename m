Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:63511 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933565Ab3E1IjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 04:39:12 -0400
From: Rohini Srinivas <rohini.srinivas@sasken.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Compact-wireless build issue
Date: Tue, 28 May 2013 08:39:08 +0000
Message-ID: <6B416C79F6231545B911C08312C479F2F01A@exgmbxfz02.sasken.com> (sfid-20130528_103917_376011_8E85E9E9)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is Rohini Srinivas from Sasken Communication Technologies, Bangalore. I am trying to build the compact wireless for wilink8 with our dm814x specific ezsdk kernel version 2.6.37.
We are currently facing issues with regard to the same.

I have followed the steps as mentioned in http://processors.wiki.ti.com/index.php/WL18xx_Build_System_Scripts .Procedure under "System Build Scripts".

The dm81x ezsdk version details - http://processors.wiki.ti.com/index.php/EZSDK_Feature_List .The ezsdk version we are using is 5.04.

As per the README document in compat-wireless downloaded for wilink8 "ol_r8.a6.01" tag, I see that kernel verison > 2.6.24 is compatible. I am trying to build this compact-wireless package with our 2.6.37 kernel, which is failing due to some variables been referred which are added post 3.2 kernel.

Script run - ./wl18xx_build.sh all
Error-
  CC [M]  /u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless/drivers/net/wireless/ti/wlcore/sdio.o
/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless/drivers/net/wireless/ti/wlcore/sdio.c: In function 'wl1271_probe':
/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless/drivers/net/wireless/ti/wlcore/sdio.c:272: error: 'SDIO_SDIO_REV_3_00' undeclared (first use in this function)
/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless/drivers/net/wireless/ti/wlcore/sdio.c:272: error: (Each undeclared identifier is reported only once
/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless/drivers/net/wireless/ti/wlcore/sdio.c:272: error: for each function it appears in.)
make[5]: *** [/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless/drivers/net/wireless/ti/wlcore/sdio.o] Error 1
make[4]: *** [/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless/drivers/net/wireless/ti/wlcore] Error 2
make[3]: *** [/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless/drivers/net/wireless/ti] Error 2
make[2]: *** [/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless/drivers/net/wireless] Error 2
make[1]: *** [_module_/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/wlan_settings/build-utilites/wlan_tools/compat-wireless] Error 2
make[1]: Leaving directory `/u/rohinis/ezsdk_dm814x-evm_5_04_00_11_setuplinux/board-support/linux-2.6.37-psp04.04.00.01_roh'
make: *** [modules] Error 2

Could patches be provided to the kernel 2.6.37 wrt to wilink8 module only which may resolve this problem? Or any other suggestions if you have would be helpful.

Please could you provide me any pointers and help us resolve this issue.

Thanks and Regards,
Rohini

________________________________

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
