Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.mailasail.com ([212.227.250.41]:41433 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbZHYT0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 15:26:08 -0400
Message-ID: <4A943AD0.2050406@wildgooses.com>
Date: Tue, 25 Aug 2009 20:26:08 +0100
From: Ed W <lists@wildgooses.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Cross compiling currently broken?
References: <4A94319B.9030903@wildgooses.com> <43e72e890908251208r1451b54bt36b431ba5942917a@mail.gmail.com>
In-Reply-To: <43e72e890908251208r1451b54bt36b431ba5942917a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

> I use /lib/modules/xyz/build just fine.
>   

Can you adapt your environment to be a little closer to mine?

For example if you don't have /lib/modules/'uname -r` available do you 
get the nasty errors that I see?

> mcgrof@tux ~/devel/compat-wireless-2.6 (git::master)$ make
> KLIB=/lib/modules/2.6.27-02062726-generic/build/
> KLIB_BUILD=/lib/modules/2.6.27-02062726-generic/build/
>   

Is the above all on one line?  Assuming so then can you please try this:

> mcgrof@tux ~/devel/compat-wireless-2.6 (git::master)$ make
> KLIB=/lib/modules/2.6.27-02062726-generic/build/
> KLIB_BUILD=/lib/modules/2.6.27-02062726-generic/build/ install-modules
>   

I would expect your modules to end up in

/lib/modules/2.6.27-02062726-generic/build/lib/modules/2.6.27-02062726-generic/build/

(If you read the above you can presumably see what has happened)
 

Is this the case for you?

Your make output varies from mine (compat-wireless-2009-8-24), one of us 
obviously has somewhat newer build file - perhaps the make file just 
changed?

Thanks for your comments

Ed W
