Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23106.mail.ird.yahoo.com ([217.146.189.46]:32252 "HELO
	web23106.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753194AbYG3XJJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 19:09:09 -0400
Date: Wed, 30 Jul 2008 23:09:07 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: RTL8187B with id 0x8198 (Re: RTL8187B datasheet)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, jhn98032@gmail.com,
	hadmut@danisch.de
In-Reply-To: <4890D762.9060306@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <759412.52472.qm@web23106.mail.ird.yahoo.com> (sfid-20080731_010915_107950_F7E513B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 30/7/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
<snipped>
> Linux-wireless had a post this morning 
> (http://article.gmane.org/gmane.linux.kernel.wireless.general/18727)

It is this thread instead:
http://article.gmane.org/gmane.linux.kernel.wireless.general/18676

There is actually another known 0x8198 user: (added CC:)
http://bugzilla.kernel.org/show_bug.cgi?id=10900
who I have sent the last driver a few weeks ago (?) and yet to hear from.

> from a guy 
> that is trying to get one of the 8198 Toshiba devices
> working. It was going 
> off-line every 6 seconds and he wondered if there was a
> watchdog timer that was 
> expiring, and wondered if we had the datasheet. I sent him
> all the patches we 
> have, and thought I would send him the datasheet if it
> would not be a problem.
> 
> With the latest patches, he has better success; however, it
> is still going 
> off-line on him.
> 
> BTW, With the latest set of patches I have been on-line
> continuously for 16 
> hours with my RTL8187B.

2.6.27-rc1 would likely be the same as wireless-testing at 2 weeks ago, i.e. known to be broken due to the tx seq number problem. The stop after 6 seconds/6 ping packets, I have already reported/mentioned a few times -
The tx seq number fix is needed. None of the patches are in wireless-
testing yet, so wireless-testing does not work either.

About 8187B datasheet: yes, we have been in touch with realtek and we have the 8187B datasheet - this is probably not a big secret, since one of Larry's(?) recent stats commit mentions this. Whether we have the right to give it away is another issue; they have a linux driver and choose not to put it out publicly, so they probably don't want the datasheet posted publicly either.

On difference between 8197 and 8198: this is actually a direct question I asked the Realtek folks (and Larry/Herton/John CC'ed in) a few weeks ago. Their answers were a bit contradictory from my reading: they said there is
no programmatic difference between 8197 and 8198, but also say that they
cannot give us the 8198 datasheet (which suggest there is a *different*
datasheet, and there are differences). I think there might be some
language issue involved (most of the Realtek people seems to be based in
Mainland or Taiwan), and I was tempted to ask them to switch to Chinese if
it is easier for them...

I would suggest, make sure one has all the latest patches (the tx seq number fix patch in particular). The mutex lock patch seems to improve life with Network Manager/wpa_supplicant, so depends on whether one is
trying to connect manually or system-config-network or via network
manager. (manaually/system-config-network works better).

There are 3 patches outside 2.6.27-rc1/wireless-testing at the moment:
the improved stats patch, the tx seq number patch, the mutex lock patch.


      __________________________________________________________
Not happy with your email address?.
Get the one you really want - millions of new email addresses available now at Yahoo! http://uk.docs.yahoo.com/ymail/new.html
