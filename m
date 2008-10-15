Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:26500 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbYJOTbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 15:31:32 -0400
Received: by ik-out-1112.google.com with SMTP id c30so2145724ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 12:31:30 -0700 (PDT)
Message-ID: <48F6450E.7040809@gmail.com> (sfid-20081015_213137_263284_DB346BE1)
Date: Wed, 15 Oct 2008 20:31:26 +0100
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] orinoco: reload firmware on resume
References: <200810111816.26370.arvidjaar@mail.ru> <48F0E58F.6000900@gmail.com> <200810121636.34373.arvidjaar@mail.ru>
In-Reply-To: <200810121636.34373.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On Saturday 11 October 2008, Dave wrote:
>>> -	int err;
>>> +	int err = 0;
> 
> Fixed version attached.

Acked-by: David Kilroy <kilroyd@googlemail.com>


Note that if the firmware download fails the card won't work because we no longer  allocate a fid. However even if we were to allocate a fid the driver flags would be inconsistent with the firmware capabilities, and the driver would just encounter a bunch of errors.

We should probably think about how we can fall back to the inbuilt firmware after a failed firmware download - but this can be done separately.


Regards,

Dave.
