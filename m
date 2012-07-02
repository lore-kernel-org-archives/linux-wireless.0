Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35754 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2GBPVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 11:21:25 -0400
Received: by ghrr11 with SMTP id r11so4191259ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 08:21:25 -0700 (PDT)
Message-ID: <4FF1BC71.4070002@lwfinger.net> (sfid-20120702_172128_982714_DCA6DAA5)
Date: Mon, 02 Jul 2012 10:21:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Kernel oops in __netif_schedule() for at76c50x-usb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regarding the oops that I reported for PPC architecture that reported "Unable to 
handle kernel paging request for data at address 0x000004c", I have now repeated 
it on x86_64 architecture, where the objdump tool is better. The error occurs in 
the line in __netif_schedule() that says

          if (!test_and_set_bit(__QDISC_STATE_SCHED, &q->state))

Debug printouts have shown that q is not NULL, and it appears to be in the 
correct address range. I think q->state is zero; however, q->state cannot be 
written.

Additional testing shows this problem to be another side effect of commit 
3a25a8c ("mac80211: add improved HW queue control") for a device with only a 
single HW queue.

Any suggestions for additional debugging printouts will be greatly appreciated.

Thanks,

Larry
