Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:51344 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1ACRYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 12:24:11 -0500
Received: by iyf40 with SMTP id 40so6384963iyf.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 09:24:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0826983CC0CB074798C42E77D8ACD07F063277@pdtms1.pdt.com>
References: <0826983CC0CB074798C42E77D8ACD07F0616CB@pdtms1.pdt.com>
 <AANLkTimH1aFuBfgD8g50YJjto9Mx3jRaPJMa5veG1o+z@mail.gmail.com> <0826983CC0CB074798C42E77D8ACD07F063277@pdtms1.pdt.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 3 Jan 2011 19:23:50 +0200
Message-ID: <AANLkTime2kkcRqA8m2D=Z24vaw+kZea6jHVTbfALLj1+@mail.gmail.com>
Subject: Re: wl1271 status/update
To: "Brzezowski, Karen" <Karen.Brzezowski@pdt.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Karen,

On Mon, Jan 3, 2011 at 7:00 PM, Brzezowski, Karen
<Karen.Brzezowski@pdt.com> wrote:
...
> I see things about compat-wireless, mac80211, sdio runtime pm support,
> lenient generic runtime pm callbacks,
> etc..
>
> I don't really understand.. do i need all of this for wl1271...

compat-wireless will build you the mac80211 layer and the wl1271
driver as external modules.

Normally that should have been enough, but in order to support the
SDIO interface of the wl1271 we had to change a few stuff in the
kernel (mainly add runtime PM support into the SDIO subsystem).

Those changes were merged into 2.6.37, so users of older kernels have
to backport them manually. Here's the list of items you need:

* SDIO runtime PM (11 patches)
* The "lenient pm callbacks" patch (a really small and trivial patch)
* "wl12xx: add platform data passing support" (that one is not
mentioned in the wiki yet for some reason, here's its link:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg34839.html)

But if you're using 2.6.31 you may need other stuff too.. E.g. I'm not
sure that SDIO suspend/resume even made it to 2.6.31 at all...

> is there any high level documentation as to how wl1271 fits into linux/android?

Hmm.. the wiki ?  :)

Regards,
Ohad.
