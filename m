Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46937 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1CWJqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 05:46:45 -0400
Received: by ewy4 with SMTP id 4so2085738ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 02:46:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300807242.3746.47.camel@jlt3.sipsolutions.net>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
	<1300807242.3746.47.camel@jlt3.sipsolutions.net>
Date: Wed, 23 Mar 2011 11:46:43 +0200
Message-ID: <AANLkTikZtEsrv2VN-jeGnagTdw0uBKABgsugAMVaGviV@mail.gmail.com>
Subject: Re: [RFC 0/9] add WoW support
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 22, 2011 at 5:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I think what we should do instead is this:
>  1) Add suspend/resume ops instead of going through stop/start and all
>    the deconfiguration / reconfiguration (of course keep all the
>    previous logic for drivers that don't implement suspend.)
>
>  2) Implement more iterators / accessors to allow drivers to get access
>    to more information. Some of that might not be necessary since at
>    resume in some cases the device might just go and request a restart,
>    but in other cases this might be necessary to simplify/avoid book-
>    keeping in drivers.
>
> Adding such APIs would allow drivers to be more in control of what
> happens at suspend, which given the complexity of how this might work,
> with configuring the driver etc.
>
> Thoughts?
>
i agree.
new suspend/resume ops sounds like the right thing to do.
i'm not sure why i didn't add them in the first place. :)

Eliad.
