Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57963 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3FKXoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 19:44:09 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld11so3149070pab.22
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 16:44:08 -0700 (PDT)
Received: from [131.179.210.181] (Cs-210-181.CS.UCLA.EDU. [131.179.210.181])
        by mx.google.com with ESMTPSA id tt7sm390256pbc.34.2013.06.11.16.44.05
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 11 Jun 2013 16:44:06 -0700 (PDT)
Message-ID: <51B7B644.5040207@gmail.com> (sfid-20130612_014413_143492_11D3A476)
Date: Tue, 11 Jun 2013 16:44:04 -0700
From: wen <allen.z.wen@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Ironic kernel panic when changing STATION channel type (b/t HT20
 and HT40)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello developers!

I am new to linux wireless driver coding, and is trying to implement 
Notify Channel Width Action frame.

Along with sending the action frame to request AP send data using 
specified bandwidth (20MHZ or 40MHZ), STATION also need to change its 
channel type accordingly (b/t HT20 and HT40).

For now, my implementation on action frame and updating sending rate b/t 
HT20 rates and HT40 rates works fine, but not for channel type change.

One way I tried to change channel type is calling 
ieee80211_set_channel_type() primitive. This can change channel type as 
wish on AP side, but ironically, it causes kernel panic (inside 
ieee80211_set_channel_type() function) when called exactly on STATION, 
even the same way as it is called on AP.

Another way I tried is through calling drv_config(), which causes kernel 
panic on both AP and STATION side also.

I truly appreciate it if you could help me with your rich experience!
Thanks in advance!

Wen


