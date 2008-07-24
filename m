Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:50475 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbYGXQhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 12:37:38 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Date: Thu, 24 Jul 2008 13:37:58 -0300
Cc: "Hin-Tak Leung" <hintak.leung@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <3ace41890807232028u576371a6ra944431327cac76c@mail.gmail.com> <488815DE.2000903@lwfinger.net>
In-Reply-To: <488815DE.2000903@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807241337.59688.herton@mandriva.com.br> (sfid-20080724_183741_932949_094BA118)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Thursday 24 July 2008 02:40:46 Larry Finger escreveu:
> Hin-Tak Leung wrote:
> > Your patch actually works here! :-). Maybe you should retest?
> >
> > It doesn't patch cleanly against wireless-testing - just indentation
> > oddness, I think.
> > Had to apply the patch by hand. but I am using it right now, so it
> > seems to work.
>
> As I wasn't planning on it to be an official patch, I did not handle it
> with the usual care. My mailer is Thunderbird, and it does mess with the
> white space in patches.
>
> > If somebody else retest okay, can we have this in wireless-testing
> > prompto, please?
>
> To retest, I did a 'git checkout 741b4fbc44' and then applied my patch just
> in case there was a second breakage of the driver in the tree. It worked
> for a while, then went offline, but then so did the case with 741b4fbc44
> reverted. I think some of my problems may have been due to overheating. I
> thought we had that problem licked, but maybe not.
>
> I will be submitting the proper patch tomorrow, particularly if it works
> for others.

For me it works with or without the patch, may be there is some condition that 
triggers the bug that I'm not hitting. But I still have the same problem that 
I previously reported about power management, but the bug isn't on that 
commit and doesn't have to do with power management, later I found that an 
ifconfig <interface> down + ifconfig <interface> up works too, it's something 
on userspace that triggers the bug (shortly after I modprobe the module, udev 
calls automatically scripts to configure the interface, if I disable this in 
udev and run commands manually interface works here, I'll see if I catch this 
other problem, may be a race in initialization code somewhere).

>
> Larry
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
[]'s
Herton
