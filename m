Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39675 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0KVTMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 14:12:37 -0500
Received: by qwc9 with SMTP id 9so1154469qwc.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 11:12:34 -0800 (PST)
Message-ID: <4CEAC095.7020706@lwfinger.net>
Date: Mon, 22 Nov 2010 13:12:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 error under heavy load
References: <4CEAB969.20702@lwfinger.net>	 (sfid-20101122_194209_226222_FFFFFFFFA98AFC1F) <1290451982.20888.2.camel@maggie>
In-Reply-To: <1290451982.20888.2.camel@maggie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2010 12:53 PM, Michael Büsch wrote:
> On Mon, 2010-11-22 at 12:41 -0600, Larry Finger wrote: 
>> Under heavy load with multiple streams, I'm getting errors from my BCM4312
>> (14e4:4315) device as follows:
>>
>> b43-phy0 debug: TX-status contains invalid cookie: 0x0D4D
>> b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 76
>> b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 78
>> (and continues).
>>
>> Clearly that cookie is garbage as it has a slot number of 0. Any suggestions on
>> diagnostic information that I could dump to help debug this?
> 
> I think that probably is a firmware or hardware bug. The affected
> kernel code was not changed in years, as far as I know.

Thanks. I'll see if I can figure out a way for the driver to recover more
gracefully. In the meantime, I will be dumping the entire TX status struct to
see if that helps in seeing what is wrong.

Larry
