Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm14-vm0.bullet.mail.ird.yahoo.com ([77.238.189.193]:29963 "HELO
	nm14-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753817Ab2BVVvj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 16:51:39 -0500
Message-ID: <1329947497.90659.YahooMailClassic@web29504.mail.ird.yahoo.com> (sfid-20120222_225142_752050_8A45EE00)
Date: Wed, 22 Feb 2012 21:51:37 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Add Ad-hoc mode
To: Attila Fazekas <turul64@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
In-Reply-To: <CAFmNhL=5TSTZ94ZrSUztG9Hs28Mqk8vMB7rS51SNgE2RCK5s7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 21/2/12, Attila Fazekas <turul64@gmail.com> wrote:

> I think it is worth the effort.
> 
> Hostapd AFAIK is not working with rtl8187 now.
> Until we can make it work in master mode, the adhoc mode
> could be an
> alternative. I think even if we can use it in master mode,
> ad-hoc mode
> should be implemented.

You (and others) could comment on the issue of not-working hostapd a bit more; we might want to get it working properly anyway.

As Larry requested - please send the patch without munching from your 
e-mail client. Since you are on gmail, I could offer a little advice on git-send-email, which may or may not be something you already know. This is what I do to send patches from my gmail account (change "name" and "acct" and "FILLTHISIN" and "patch-file" to suit yourself), and you could add --cc a few of us there also: 

git send-email --from 'name <acct@gmail.com>' \
--to linux-wireless@vger.kernel.org --to linville@tuxdriver.com \
--smtp-server smtp.gmail.com --smtp-server-port 465 --smtp-user \ acct@gmail.com --smtp-pass FILLTHISIN --smtp-ssl patch-file

You can do "man git-send-email" (all git man pages uses "git-something" to document the "git something" sub commands, with a dash between) to read about all the switches and what they are supposed to do.

> About refactoring:
> 
> rtl8180_beacon_work()
> Now is almost the same, I think it is possible to make it
> generic by a
> macro, or by creating new source/object file linked to both
> driver, or
> even possible to create a common module.
> But, this function will be different if someone will be able
> to add
> some hardware aided beacon timestamp update. (If I can have
> more
> information about this hardware I'll try it)
> Creating a new common module just for one small function,
> IMHO not
> worth the effort.
> Please advice.
> 
> struct rtl8187_vif, struct rtl8180_vif  now are the
> same, they might
> be the same in the future as well.
> We can remove them and create new one named rtl818x_vif in
> the rtl818x.h .
> Shall I do it ?

I haven't got a strong opinion on this - but we probably like to try your patch out first :-).

Thanks for the work!

Hin-Tak
