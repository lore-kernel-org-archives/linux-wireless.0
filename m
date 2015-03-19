Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbbCSOeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 10:34:14 -0400
Date: Thu, 19 Mar 2015 15:30:34 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [1/3] rt2x00usb: initialize the read value in case of failure
Message-ID: <20150319143033.GA2516@redhat.com> (sfid-20150319_153419_529959_A165E397)
References: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
 <20150316160652.789B313FBE6@smtp.codeaurora.org>
 <20150316164100.GA6208@linutronix.de>
 <20150317083414.GA1276@linutronix.de>
 <20150318131124.GA11724@redhat.com>
 <550ACDF2.30507@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <550ACDF2.30507@linutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2015 at 02:24:02PM +0100, Sebastian Andrzej Siewior wrote:
> On 03/18/2015 02:11 PM, Stanislaw Gruszka wrote:
> > On Tue, Mar 17, 2015 at 09:34:14AM +0100, Sebastian Andrzej Siewior wrote:
> >> I have no idea what AutoRun mode is (it seems that the stick already
> >> has a firmware and is happy with it) and I have no clue why the firmware
> >> decides to lie about it. I looked at the vendor driver I found at github
> >> (which seems to be from 2012-10-22, DPO_RT5572_LinuxSTA_2.6.1.3) and
> >> well, I look again if someone says it is worth looking… They seem to do
> >> some kind "firmware is comming" magic which might be already done in the
> >> current driver at a different spot but I think the main question is why
> >> request is answered wrong. I *think* the vendor driver sends the
> >> USB_MODE_AUTORUN request only once but it is hard to tell…
> > 
> > Does the below patch solve the issue ?
> 
> So you kill the please-load-the-firware bit and avoid further questions
> regarding its state. Yes, it helps as in my test-case is now running
> for ~15h. I see the "NIC in AutoRun mode" just once. Thanks.
> 
> I am still curious why it answers wrong but lets hope the first answer
> is correct :)

I don't know, perhaps this value is only valid at initialization stage.
Looks that vendor driver reads it only once and saves it as flag in the
memory.

Stanislaw
