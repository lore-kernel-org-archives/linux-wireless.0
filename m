Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38866 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753442Ab1EFWZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 18:25:48 -0400
Date: Fri, 6 May 2011 23:26:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: <akpm@linux-foundation.org>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <hpa@zytor.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<allen.kao@atheros.com>, <roman.gezikov@atheros.com>,
	<joonas.viskari@atheros.com>
Subject: Re: [RFC 1/2] misc: add Atheros ar1520 GPS support
Message-ID: <20110506232638.72e8900a@lxorguk.ukuu.org.uk> (sfid-20110507_002605_942761_2E4A29A3)
In-Reply-To: <1304719780-27347-2-git-send-email-lrodriguez@atheros.com>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
	<1304719780-27347-2-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Last time this driver came up the answer was that the userspace was
proprietary and this was in fact part of a mixed user/kernel driver which
seemed to raise all sorts of interesting questions.

This was NAKked before for that reason so why the resubmit. Kernel policy
is clear enough ?

> + * You need a userspace application to cooperate with this driver. It and
> + * more information about this driver can be obtained here:
> + *
> + * http://wireless.kernel.org/en/users/Drivers/ar5120

Which says:

Userspace application

This driver requires a userspace application which will interact with the
driver via ioctl. More information on this to be posted later. 

So NAK


Let's see an open userspace and then this driver can be submitted

+		time =
  wait_event_interruptible_timeout(ar1520_data->wait_irq,
+
  ar1520_data->irq_rx, +
  msecs_to_jiffies(3142));

Why 3142 ?

Come to think of it why not fixes the races while you are it.

Alan
