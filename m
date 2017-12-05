Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51698 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752979AbdLEKbJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 05:31:09 -0500
Message-ID: <1512469867.26976.17.camel@sipsolutions.net> (sfid-20171205_113125_647386_0D043E8F)
Subject: Re: net/wireless/shipped-certs.c:2:1: error: expected expression at
 end of input
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Dec 2017 11:31:07 +0100
In-Reply-To: <0fb47825-44c1-9d4e-6eb6-ebd41bebc7c2@molgen.mpg.de>
References: <4006aefb-e9af-d809-b45a-201d20e75f9d@molgen.mpg.de>
         <1512468219.26976.15.camel@sipsolutions.net>
         <0fb47825-44c1-9d4e-6eb6-ebd41bebc7c2@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Ah, here we go - you probably don't have "hexdump" installed on this
> > system?
> 
> Well, I didn’t, but got the error, that hexdump couldn’t be found. After 
> installing it, I got the error above, and sent the message.

Ah, ok.

> Removing the file `net/wireless/shipped-certs.c`, and building again, 
> fixed the problem. So I guess, the clean-up task(?) in the build script 
> has a problem.

Did you run "make clean"? I'm not even sure it'd delete the file
though.

I suppose if this target fails we shouldn't create the file, but I
haven't quite figured out how to do that - let me try.

> I do not think, it’s necessary, as I got an error, that the executable 
> is not there. No idea, if it is documented somewhere though.

Fair enough. I do have a patch to use od/sed so perhaps I'll just throw
that in anyway just to not require people to install hexdump.

johannes
