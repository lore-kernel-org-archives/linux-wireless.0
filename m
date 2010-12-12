Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:62380 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0LLPd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 10:33:56 -0500
Received: by gxk19 with SMTP id 19so3424710gxk.11
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 07:33:55 -0800 (PST)
Message-ID: <4D04EB7D.1090009@lwfinger.net>
Date: Sun, 12 Dec 2010 09:34:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ssb: Save sprom image for dump of device at alternate
 location
References: <4d044307.Ipm73VWEgifFrF0m%Larry.Finger@lwfinger.net>	 (sfid-20101212_043513_712988_FFFFFFFF9320429C) <1292143551.20015.24.camel@maggie>
In-Reply-To: <1292143551.20015.24.camel@maggie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2010 02:45 AM, Michael Büsch wrote:
> On Sat, 2010-12-11 at 21:35 -0600, Larry Finger wrote: 
>> Some recent Broadcom devices in netbooks have an SPROM that is located
>> at 0x0800, not the normal location of 0x1000. Initial reading of the
>> SPROM has been solved in a previous commit; however, dumping to a console
>> no longer works. This difficulty is fixed by saving the SPROM image
>> from the initial read, and only freeing that memory at module unload.
> 
> Ah wait. Now I get what you were talking about.
> Yes, those devices map the SPROM into the wireless core window.
> So, yes, the wireless core has to be mapped for the readout to work,
> of course. I don't know what other prerequisites have to be met to
> read the data. Maybe IHR region has to be disabled.
> I don't know how writing works on these devices.

I do not think it is worthwhile to bother to find out how to rewrite the SPROM.
As long as we can read it in case of questions regarding content, that should be
enough. In V2, I will return -ENOTSUP rather than -EINVAL as that is more
appropriate.

Larry
