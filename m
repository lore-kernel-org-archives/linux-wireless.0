Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm20-vm0.bullet.mail.ird.yahoo.com ([77.238.189.221]:23708 "HELO
	nm20-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755171Ab2FSWBN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 18:01:13 -0400
Message-ID: <1340143271.55570.YahooMailClassic@web29404.mail.ird.yahoo.com> (sfid-20120620_000117_978906_DF4C12EE)
Date: Tue, 19 Jun 2012 23:01:11 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: rtl8187 on compat-wireless Re: regression?
To: herton@canonical.com, Larry.Finger@lwfinger.net,
	Shane Klinedinst <services@beyondcr.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1340117919.75084.YahooMailClassic@web29404.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 19/6/12, Hin-Tak Leung <htl10@users.sourceforge.net> wrote:

<snipped>
> The 6th thing is, why are you using a compat-wireless which
> is over a month old? compat-wireless is what it is, bleeding
> edge snpashot code, you may need to try a different
> snapshot.
> [    6.481568] Compat-wireless backport release:
> compat-wireless-2012-05-04
> [    6.481570] Backport based on linux-next.git
> next-20120510

Just to confirm that it working perfectly well here (my dmesg) - not sure why next-05-10 was the most recent one, Luis might like to comment.

[125591.037794] Compat-wireless backport release: compat-wireless-2012-05-04
[125591.037807] Backport based on linux-next.git next-20120510

against 3.4.2-4.fc17.x86_64 . I see the original poster had 3.2.x, and a tainted kernel, no less; so that's an "anything goes" scenario.

Not entirely sure why there was a duplicate symbol (supposedly for 3.5 compatibility):
[125123.258683] compat: exports duplicate symbol simple_open (owned by kernel)

I just commented out that part of compat/compat-3.5.c which export that symbol. I suspect fedora kernels are just a little closer to 3.5 than compat-wireless expects, but I am not too bothered about it. John and Luis might like to comment on this; also about the -p and -pc tar balls.

Anyway, the exact same compat-wireless version works here.

> --- On Tue, 19/6/12, Shane Klinedinst <services@beyondcr.com>
> wrote:
> 
> From: Shane Klinedinst <services@beyondcr.com>
> Subject: regression?
> To: herton@canonical.com,
> htl10@users.sourceforge.net,
> Larry.Finger@lwfinger.net
> Date: Tuesday, 19 June, 2012, 12:12
> 
> Hello, I cannot get my wireless interface to work with
> compat-wireless nomatter what I do here is my dmesg file any
> and all suggestions will be greatly appreciated http://pastebin.com/yq8FZd5y PaulFertser said it looks
> like a regression and I should mail the driver maintainer. I
> am not good at this type of thing but if you need any more
> information just tell me what to do. Thanks.
> 
> Best wishes,Shane Klinedinst
> 
> 
