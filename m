Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60517 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZBDPau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 10:30:50 -0500
Date: Wed, 4 Feb 2009 10:18:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Ismael Ojeda Perez <iojedaperez@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: zd1211rw NEW RF Type
Message-ID: <20090204151854.GC3845@tuxdriver.com> (sfid-20090204_163054_989244_3E58B274)
References: <a4c529250902040227g35a375fdu35c2360f0916dba6@mail.gmail.com> <a4c529250902040243r6146f56vb2c656818385c749@mail.gmail.com> <3ace41890902040717l7174fc0xc4589f17ea283e9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3ace41890902040717l7174fc0xc4589f17ea283e9c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 04, 2009 at 03:17:26PM +0000, Hin-Tak Leung wrote:
> On Wed, Feb 4, 2009 at 10:43 AM, Ismael Ojeda Perez
> <iojedaperez@gmail.com> wrote:
> > Hi, huston we have a problem
> > I have purchased a tp-link usb wireless device
> > model : tl-wn422g
> > i cant work with it because it says there is a new RF type
> > here its what dmesg shows
> 
> > [  526.984508] zd1211rw 7-2:1.0: RF MAXIM_NEW_RF 0x8 is not supported
> 
> You probably don't hang out in the right place... two people on the
> sourceforge zd1211 mailing list recently reported that
> MAXIM_NEW_RF=0x08 is just the same as    UW2453_RF=0x09 ; and one of
> them has a wn422g and the other wn322g
> (I just went back the mailing list archive and checked), so it is
> likely the same change would work for you:
> 
> in drivers/net/wireless/zd1211rw/zd_rf.c, line 89, you see:
> 
> --------------------
>         case UW2453_RF:
>                 r = zd_rf_init_uw2453(rf);
>                 break;
> ---------------------
> Just put an extra line
> 
>          case MAXIM_NEW_RF:
> either immediately before or immediately after the case UW2453_RF: line.
> 
> If it reports success for you, maybe we'll consider putting this in
> properly... I am not the maintainer for that part, so it is likely
> we'll need advice/approval from somebody else for this change to go
> into the kernel.

Or someone can send a patch with a report that it is working for them
and I'll just merge it... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
