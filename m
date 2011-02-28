Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f51.google.com ([74.125.83.51]:64428 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab1B1Dl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 22:41:26 -0500
Received: by gwb15 with SMTP id 15so2147191gwb.10
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 19:41:26 -0800 (PST)
Message-ID: <4D6B1961.1090502@lwfinger.net>
Date: Sun, 27 Feb 2011 21:41:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Change rate-control feedback
References: <99164.32713.qm@web29504.mail.ird.yahoo.com>
In-Reply-To: <99164.32713.qm@web29504.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2011 08:21 PM, Hin-Tak Leung wrote:
>
> --- On Sun, 27/2/11, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>
>> The driver for the RTL8187L chips
>> returns IEEE80211_TX_STAT_ACK for all
>> packets, even if the maximum number of retries was
>> exhausted. In addition
>> it fails to setup max_rates in the ieee80211_hw struct,
>> This behavior
>> may be responsible for the problems noted in Bug 14168. As
>> the bug is very
>> old, testers have not been found, and I do not have the
>> case where the
>> indicated signal is less than -70 dBm.
>
>
> Possibility of division by zero? The while loop dequeues - does this code always get invoked with a non-empty queue? Also it worrys me a little if tmp<  retry?

This routine is not schedules until a packet has been transmitted, thus the 
queue length will always be at least one, but I should protect against a divide 
by zero anyway.

The hardware keeps track of the retries. I suppose there could be a possibility 
of the register wrapping back to zero. I'll throw in a test there as well.

Thanks,

Larry
