Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:20689 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbZAXU4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 15:56:50 -0500
Received: by ey-out-2122.google.com with SMTP id 22so1111749eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 12:56:48 -0800 (PST)
Message-ID: <497B808F.6060009@gmail.com> (sfid-20090124_215655_334774_C68D1B6E)
Date: Sat, 24 Jan 2009 21:56:47 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Artur Skawina <art.08.09@gmail.com>
CC: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH v2] p54usb: rx refill revamp
References: <200901232245.15216.chunkeey@web.de> <200901240215.44226.chunkeey@web.de> <497A967F.2010900@gmail.com> <200901241206.18690.chunkeey@web.de> <497B71E9.6080703@gmail.com>
In-Reply-To: <497B71E9.6080703@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Artur Skawina wrote:
> Christian Lamparter wrote:
>> On Saturday 24 January 2009 05:18:07 Artur Skawina wrote:
>>> [My version schedules the work for every urb, even the poisoned ones]
>> well, there's now a hard limit... no change of a endless loop now.
> 
> The whole point of the poisoning was to prevent resubmission when
> canceling the urbs -- if you work around that manually, you could just
> as well kill them, instead of poisoning.
> I don't understand why want to add extra code to the rx irq just to
> avoid scheduling a work when downing the i/f, and keep a nasty failure
> case. The difference in down() performance is not going to be measurable,
> and even if it was, it wouldn't matter.

Oh, and we could always do something like

        if (likely(atomic_read(&urb->reject)==0))
                queue_work(priv->common.hw->workqueue, &priv->rx_refill_work);

which should catch most cases then urbs are either killed or poisoned.

artur
