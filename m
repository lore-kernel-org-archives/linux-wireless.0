Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n28.bullet.mail.ukl.yahoo.com ([87.248.110.145]:26611 "HELO
	n28.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754891AbYFSAKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 20:10:00 -0400
Message-ID: <4859A589.8090301@yahoo.co.uk> (sfid-20080619_021003_400986_122DD9FC)
Date: Thu, 19 Jun 2008 01:17:13 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Uwe Hermann <uwe@hermann-uwe.de>
CC: herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id	0x8197/0x8189
References: <922158.32180.qm@web23114.mail.ird.yahoo.com> <20080618223153.GA18079@greenwood>
In-Reply-To: <20080618223153.GA18079@greenwood>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(I am not on linux-wireless so please CC: me if replying)
Uwe Hermann wrote:
> On Sun, Jun 15, 2008 at 12:59:54AM +0000, Hin-Tak Leung wrote:
<snipped>
>> The rest of the story is at:
>> https://bugzilla.redhat.com/show_bug.cgi?id=432280
<snipped>
> ACK, same here. I'm an owner of a 'One A110' mini-laptop (see
> http://a110wiki.de/wiki/Wireless) and the situation is really getting
> uncontrollable with a gazillion of tarballs and patches for the R8187B
> driver floating around, all of them with small differences...
> 
> (the ID on this laptop is 0bda:8189 btw)
> 
> I'm very interested to see something get merged upstream, and I'm also
> willing to test whatever needs testing on my hardware.

Yes, this is getting out of hand! Your page actually contains a few forked
code I don't know about... I think I can summarize the situation as this:

1) there are two main branches of drivers which work to various extent with 
various kernel versions, excluding ndiswrapper usage. One is a vendor driver
(I had 1024.0822.2007, but the 1031.0125.2008 on one's web site seems to be 
newer) based on the old pre-2.6.22 stack, and Herton's rewrite based on the new 
mac80211 stack.

2) the vendor driver (and the old stack) is considered dead-end by the 
linux-wireless people; also it suffers from "bit-rot" as it is largely
unmaintained (there is no identifiable person to contact, and this is the first 
time I heard of the one's web site newer version) and can't keep up with
progress in the rest of the kernel.

3) Herton's driver (I think he didn't have the actual hardware) was missing
a couple of lines about the management frames (details in the redhat bugzilla) 
so in its original form can scan but can't associate; it was considered at one
point to be included in the kernel a few months ago. It also suffers from some
extent of bit-rot in the last couple of months. I think I am the one currently
maintaining it, and various CC: in the redhat bugzilla has reported success with
current kernel.

So I propose these steps:
1) I think Herton wrote the new code based on 1024.0822 . We need to find out
    a) any useful difference between 1024.0822 and 1031.0125
    b) did herton have any doubts, etc while looking at 1024.0822?
2) anybody wants to review the difference of my update on herton's?
    The most important and necessary part is the management frames change, the
    rest is just to cope with bit-rot; I explained that I needed to add an inline
    (which should be taken out when added to wireless-testing),  and
    I don't know where the multi-queue data structure has gone, so I have
    hardcoded 6. I am willing to answer any questions or go over why I changed
    what I have changed to stop the bit rotting going any further.

Any patch would bit-rot if it doesn't go into the rest of the wireless stack,
so we should get this done.

Hin-Tak









