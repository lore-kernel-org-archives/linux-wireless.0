Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:37398 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbXI1Set (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 14:34:49 -0400
Received: by nf-out-0910.google.com with SMTP id g13so2598598nfb
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2007 11:34:47 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: r2x00: Wrong rfkill inputdev poll interval
Date: Fri, 28 Sep 2007 20:49:12 +0200
Cc: linux-wireless@vger.kernel.org
References: <200709281358.57627.mb@bu3sch.de>
In-Reply-To: <200709281358.57627.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709282049.12473.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 September 2007, Michael Buesch wrote:
> You pass the poll interval as (HZ/4), but the input
> dev expects milliseconds instead of jiffies.

Oops. Thanks, I'll fix this immediately. :)

> So a value of 250 would be right in your case.
> Though, I think polling that often for this event might be overkill.
> 
> I'd say polling once a second should be OK for b43, for example.
> We currenty also poll it only once per second.
> But that's up to your choice. :)

Yeah, I was not really sure what a nice timeout value should be.
I'll raise it to 1 second as well.

Thanks,

Ivo
