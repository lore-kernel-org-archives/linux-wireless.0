Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.student.tuwien.ac.at ([193.170.74.22]:33978 "EHLO
	mail2.student.tuwien.ac.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754604AbcCBKuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 05:50:51 -0500
Received: from [192.168.0.203] ([212.69.186.40])
	(authenticated bits=0)
	by mail2.student.tuwien.ac.at (8.13.8/8.13.8) with ESMTP id u22AhGT6016242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Mar 2016 11:43:17 +0100
To: linux-wireless@vger.kernel.org
From: Stefan Feirer <e0926020@student.tuwien.ac.at>
Subject: iwlwifi support of 802.11k RRM (Radio Resource Mangament)
Message-ID: <56D6C3C4.4000702@student.tuwien.ac.at> (sfid-20160302_115056_969251_5A9AA84D)
Date: Wed, 2 Mar 2016 11:43:16 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to make different wifi roaming tests with the 802.11 
amandments 802.11k and 802.11r.
I use the intel wifi chipset Intel Corporation Centrino Ultimate-N 6300 
and two Aerohive Access Points AP141 (with both 802.11k and 802.11r 
enabled).
With using wpa_supplicant (Version 2.5) and wpa_cli (Version 2.5) I was 
able to connect and roam between the APs by entering the command "roam 
<mac>" and actually an 802.11r roam was performed. Therefore the nl80211 
and iwlwifi driver was used.
So fast roaming seems to work properly, but I faced troubles with Radio 
Resource Management (802.11k)

Transmitting the command "neighbor_rep_request" in wpa_cli failed. I 
checked to log files and found the following lines:

wlan0: Control interface command 'NEIGHBOR_REP_REQUEST'
RRM: No RRM in current connection.

and

RRM: Determining whether RRM can be used - device support: 0x0
RRM: Insufficient RRM support in driver - do not use RRM

Now my question would be how to enable RRM, maybe using the iw-command?
I could not find any documenation or examples according to RRM.
The tests were performed with Ubuntu and Linux Kernel 3.13.0-79.

I hope there is someone who can help me!
Thanks, Stefan Feirer
