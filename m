Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4849 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288Ab1E3GYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 02:24:14 -0400
Message-ID: <4DE3380C.2@gmail.com> (sfid-20110530_082428_892209_961ED501)
Date: Mon, 30 May 2011 08:24:12 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-2.6] rt2x00: fix rmmod crash
References: <20110529104529.GA2769@localhost.localdomain> <4DE278CD.3030708@gmail.com> <20110529204200.GA2472@localhost.localdomain>
In-Reply-To: <20110529204200.GA2472@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/11 22:42, Stanislaw Gruszka wrote:
> On Sun, May 29, 2011 at 06:48:13PM +0200, Gertjan van Wingerde wrote:
>> On 05/29/11 12:45, Stanislaw Gruszka wrote:
>>> Do not destroy workqueue, which still can be used by autowakeup_work,
>>> before ieee80211_unregister_hw() is called.
>>>
>>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>>
>> Could you add some details of the crash here, e.g. the stack trace of when this occurs, so that
>> we can understand what is exactly happening that is causing the crash, for our education.
> 
> Crash is in workqueue code in interrupt context, there is no indication about rt2x00 blame in
> the calltrace, but crash happen directly after rmmod rt73usb, here is a photo:
> https://bugzilla.kernel.org/attachment.cgi?id=59992 

OK. Thanks for the info.

Could you create a v2 of the patch that:
1. Includes a reference to the bugzilla entry that the patch is resolving.
2. Cc's the stable team.

In that v2 you can add my acked-by as follows:
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Thanks for the patch.

---
Gertjan
