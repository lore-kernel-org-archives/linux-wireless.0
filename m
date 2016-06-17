Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34521 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbcFQNLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 09:11:41 -0400
MIME-Version: 1.0
From: Prasun Maiti <prasunmaiti87@gmail.com>
Date: Fri, 17 Jun 2016 18:41:39 +0530
Message-ID: <CAEO8o4=aLbrwHka8X2h-YUCeuKoWzU0q7JWLuuaYsRW=69q_DQ@mail.gmail.com> (sfid-20160617_151201_190362_FC301754)
Subject: [Query] mwifiex: few observations to reduce number of endian conversions
To: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,

I have two observations:

1. I have found that in the command response path for host command
"HostCmd_CMD_802_11_EEPROM_ACCESS", a "0" value has been endian
converted. It can only be a safe futuristic approach for any non-zero
value there however! Otherwise, the endian conversion can be removed.

2. For multiple Host Commands (e.g HostCmd_CMD_802_11_EEPROM_ACCESS
etc.) "cpu_to_leX"-converted values are saved to driver. So
"leX_to_cpu" conversion is required too many times afterwards in
driver.
On the contrary, we can save the values to driver without any
conversion, and only command buffer(s) are prepared with endian
converted values. In this way we can gain some efficiency [code size /
time] by reducing the number of endian conversion considerably.

Please let me know your opinion on the above.

-- 
Thanks,
Prasun
