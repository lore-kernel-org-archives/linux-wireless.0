Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:38751 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZCPPGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 11:06:19 -0400
Received: by fxm24 with SMTP id 24so3524294fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 08:06:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49BE64CF.8020407@lwfinger.net>
References: <COL113-W348B209977311F6BB460ADCB9B0@phx.gbl>
	 <49BE64CF.8020407@lwfinger.net>
Date: Mon, 16 Mar 2009 15:06:16 +0000
Message-ID: <3ace41890903160806j78057c1duffb52b532b40d07a@mail.gmail.com> (sfid-20090316_160622_107530_DBBAFEE4)
Subject: Re: rtl8180 Bit Rate regression in 2.6.29
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Adrian Bassett <adrian.bassett@hotmail.co.uk>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 2:40 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> My system says that there are 6172 commits between 2.6.29-rc8 and 2.6.28, thus
> it will take roughly 13 kernel builds to bisect the problem.

I had used a "poor man's git bisect" system once or twice: get a
couple of months of daily compat-wireless tarballs, and
doing manual bisect to find the two tar balls which results in the
regression, then look up the release tags inside and extract the
patches from wireless git (it is about 40 daily) then apply them in
sequence, etc.

The beauty of this scheme is that (1) installing/changing/switching
between compat-wireless snapshot does not require a reboot - you just
need to give up wireless connectivity for a moment during the switch,
(2) building compat-wlreless is a lot faster than building whole
kernel trees, (3) particularly if you don't have or don't intend to
clone the whole of wireless git (a few hundred MB), the tarballs are
relatively small - and just known which two (and their release tags)
spans the regression would narrow the problem down to about 40
changes, many of them are obviously irrelevant, so this info could be
useful to the developers. The release tags (*-release at the top of
the tarball) are at the top of the unpacked tar balls.

This process assumes that one can find a sufficiently old
compat-wireless snapshot which did not have the problem, and a
sufficiently new one which has it...
