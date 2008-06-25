Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4461 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbYFYOS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 10:18:26 -0400
Date: Wed, 25 Jun 2008 10:08:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id
	0x8197/0x8189
Message-ID: <20080625140809.GA9111@tuxdriver.com> (sfid-20080625_161839_176873_6CD3EDF0)
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
> 
> I think I have forward-port the patch mostly correctly, but I'd like to hear about comments, etc and how to make it better...

Thanks for your effort on this issue.  I am very proud of the way you
and others have participated in improving this patch as documented
in the bugzilla link above.

I apologize for having been slow to respond but I seem to constantly
be buried in patches...  That is even more true today since I have
recently been on vacation.  Still, this patch has been languishing
in my mailbox too long!

Please review the guidelines here:

   http://linux.yyz.us/patch-format.html

If possible, please wrap your changelog comment lines at 80 columns
or less.  Also you should probably include Signed-off-by lines from
Herton and Pavel.  And please include the patch inline if possible
for easier review -- use a mailer that preserves whitespace correctly.

I may have more specific comments about the patch itself later, but now
I really need to get caught-up on some other merging.  I just wanted to
ensure that you knew I was not (completely) ignoring your efforts! :-)

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
