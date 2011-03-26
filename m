Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33836 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1CZDjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 23:39:31 -0400
Received: by ywj3 with SMTP id 3so691437ywj.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2011 20:39:30 -0700 (PDT)
Message-ID: <4D8D5FEF.6010009@lwfinger.net>
Date: Fri, 25 Mar 2011 22:39:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mattias Nissler <mattias.nissler@gmx.de>,
	Stefano Brivio <stefano.brivio@polimi.it>
CC: wireless <linux-wireless@vger.kernel.org>,
	"Mark (The Wirie)" <mark@thewirie.com>
Subject: Question about code in rc80211_pid_algo.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm writing to you as the listed authors of the PID code in the mainline kernel.

I am helping adapt the PID algorithm for an appliance that will use the Realtek 
vendor driver and the ALFA AWUS036H device. The vendor driver's rate-control 
mechanism is not very effective. As the target kernel for the appliance is 
2.6.21, we are not backporting mac80211 and the rtl8187 driver.

The package is working quite well, but Mark, the project manager, brought one 
section to my attention and I am forwarding it.

In routine rate_control_pid_sample(), the percentage failure is calculated, then 
if the rate has been changed, the code goes on to "update the rate behaviour 
info". At that point, the calculation is

          tmp = (pf - spinfo->last_pf);
          tmp = RC_PID_DO_ARITH_RIGHT_SHIFT(tmp, RC_PID_ARITH_SHIFT);

 From our analysis of the code, both pf and last_pf must be in the range 0-100, 
and the first statement results in tmp between -100 and 100. After the second 
line does an arithmetic right shift of 8, the resulting value will always be 
zero. Did we miss something, or is this really a convoluted way to set "tmp" to 
zero?

Thanks,

Larry
