Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:54263 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3LORpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 12:45:24 -0500
Message-ID: <52ADEAAF.3080107@gmail.com> (sfid-20131215_184529_506653_77704F22)
Date: Sun, 15 Dec 2013 19:45:19 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: linux-rt-users@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/10] make iwlwifi RT friendly
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com> <20131215154843.GL31090@linutronix.de>
In-Reply-To: <20131215154843.GL31090@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/15/2013 05:48 PM, Sebastian Andrzej Siewior wrote:
> * Emmanuel Grumbach | 2013-12-11 10:33:35 [+0200]:
> 
>> RT folks have raised issues with iwlwifi wrt. RT kernel some time
>> ago. Johannes had a few patches to address this, but I had a few
>> concerns with them. This series tries to address the RT concerns:
>> * we don't do anything in hard-irq context besides stopping the
>>  interrupts in the device.
>> * the interrupt cause is read from the irq handler and is handled
>>  there.
> 
> Thanks for the patches. I haven't yet looked at them I doubt I manage it
> anytime soon. Could you please answer one question: Do you grab any
> locks in the primary interrupt handler?
> 
No we don't. The primary interrupt just tells the hardware to stop
firing interrupts and wakes up the thread as written above.
