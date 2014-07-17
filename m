Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36369 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaGQE2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 00:28:52 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so2563879pab.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 21:28:52 -0700 (PDT)
Message-ID: <1405571303.11940.3.camel@spark> (sfid-20140717_062856_062899_20D36774)
Subject: Re: About WSMP (Wave Short Message Protocol)
From: spark <saurabh6321@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: davem@redhat.com, linville@lvl7.com, siva@aradasystems.com,
	bugzilla-daemon@wireshark.org, vamsi07450@gmail.com
Date: Thu, 17 Jul 2014 09:58:23 +0530
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-07-11 at 14:45 +0530, vamsi wrote:
> Hi,
>  
> I am planing developing WSMP (Wave Short Message Protocol) protocol in
> transport layer for this give me any suggestions how to start adding
> protocol? 
> 
> Thanks 
> vamsi
> 
> --
I would like to add to this. WSMP(Wave Short Message Protocol ie. 1609.3
published by the IEEE Vehicular Society) is a part of the DSRC(Dedicated
Short Range Communications) standards suite which include 802.11p,
1609.x series. Which are used for "intervehicular communication" and
also for "vehicle to infrastructure communication".

The DSRC/WAVE stack:
        
         Application Layer (SAE J2735 Message set dictionary)
A
                ^
                |
         Transport Layer -| 
                ^         |
                |         |--(WSMP IEEE 1609.3) Both combined
         Network Layer    |
                ^         |
                |         |
         LLC(existing)   -|
                ^        
                |        
         Datalink Layer  -|
                ^         |
                |         |--(1609.4 and IEEE802.11p)
         Physical Layer  -|


Currently as IEEE 802.11-2012 has released,it is having 802.11p also
merged in it.
We may have WSMP acting as both transport layer and network layer.We
have some proprietry 
implementations of all these standards but no open source implementation
has been done.

We propose to develop this in a way so that it has a socket interface to
the user.
Please give your suggestions. 
For more info regarding the stack one may refer to the Document
IEEE1609.0 or John Kenney's 
paper on this subject "Dedicated Short-Range
Communications (DSRC) Standards in the United States"
link  "http://secs.oakland.edu/~gpcorser/vanet-kenny-DSRC.pdf"

> To unsubscribe from this list: send the line "unsubscribe
linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




