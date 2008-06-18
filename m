Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs162167.vserver.de ([62.75.162.167]:42218 "EHLO
	unmaintained-free-software.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbYFRWj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 18:39:28 -0400
Date: Thu, 19 Jun 2008 00:31:53 +0200
From: Uwe Hermann <uwe@hermann-uwe.de>
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id
	0x8197/0x8189
Message-ID: <20080618223153.GA18079@greenwood> (sfid-20080619_003932_167219_065DBD2F)
References: <922158.32180.qm@web23114.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <922158.32180.qm@web23114.mail.ird.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 15, 2008 at 12:59:54AM +0000, Hin-Tak Leung wrote:
> (I am not on linux-wireless so please CC: me if replying)
> 
> This is a patch against compat-wireless-2008-06-14 to work with 2.6.25.6-55.fc9.x86_64 kernel headers. I am using it right now so it works for me, YMMV.
> 
> It is mostly a patch from Herton a few months ago to add support for
> Realtek 8187B. Herton's patch was missing a little quirk change for usb endpoint 12 for management frame; and I ported it forward to current fedora 9 kernel headers. 
> 
> The rest of the story is at:
> https://bugzilla.redhat.com/show_bug.cgi?id=432280
> 
> I have a few questions during the porting:
> 
> - control->queue, which the herton's change used, for switching between 4 tramission queue at end point 6,7,5,4, has disappeared. I hard-coded 6 in this version, (see commemt #37 for background), but what's the correct
> way to do this in current wireless-2.6 code?
> 
> - compat-wireless seems to use a small inlined routine 
> from http://article.gmane.org/gmane.linux.kernel.wireless.general/15830,
> which isn't in the redhat header yet. so I have added an ifndef at
> the top of rtl8187_dev.c . so the patch needs to have that part removed
> if commited to compat-wireless.
> 
> - obviously it is getting a bit painful to forward-port the patch every time something else changes or something else changes in the header... 
> what can I do to make this go into wireless-2.6 ?

ACK, same here. I'm an owner of a 'One A110' mini-laptop (see
http://a110wiki.de/wiki/Wireless) and the situation is really getting
uncontrollable with a gazillion of tarballs and patches for the R8187B
driver floating around, all of them with small differences...

(the ID on this laptop is 0bda:8189 btw)

I'm very interested to see something get merged upstream, and I'm also
willing to test whatever needs testing on my hardware.


Thanks, Uwe.
-- 
http://www.hermann-uwe.de  | http://www.holsham-traders.de
http://www.crazy-hacks.org | http://www.unmaintained-free-software.org
