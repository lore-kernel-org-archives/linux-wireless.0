Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39006 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751429AbYKEI7S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 03:59:18 -0500
Subject: Re: [PATCH] make assocaittion only if SSID is known.
From: Alexey Fisher <bug-track@fisher-privat.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, rjw@sisk.pl, kernel-testers@vger.kernel.org
In-Reply-To: <871vxq217k.fsf@nokia.com>
References: <1225836101-5723-1-git-send-email-bug-track@fisher-privat.net>
	 <1225838828.22671.0.camel@localhost.localdomain> <871vxq217k.fsf@nokia.com>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 09:59:15 +0100
Message-Id: <1225875556.5905.11.camel@zwerg> (sfid-20081105_095923_451492_456B983C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, den 05.11.2008, 07:25 +0200 schrieb Kalle Valo:
> Dan Williams <dcbw@redhat.com> writes:
> 
> > On Tue, 2008-11-04 at 23:01 +0100, Alexey Fisher wrote:
> >> 'iwconfig eth1 channel 6' would trigger association to _something_,
> >> which is wrong. Changing the channel should (and does) trigger
> >> reassociation, but only if there is an SSID to associate with!
> >
> > Heh :)  Need the Signed-off-by: here too though.
> 
> And the subject should contain the driver name, for example like this:

I found some time to _read_ linux-2.6/Documentation/Submit* ! ;)
but i think it need some "howto submit the patch with git". My englisch
is to bad to make documentation. Here was my steps:

$git clone
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
$git pull
$vi make/changes
$git-commit -a
$git-log -p ORIG_HEAD..
$mkdir ../pending
$git-format-patch ORIG_HEAD.. -o ../pending/
$vi ../pending/0001-ipw2200.patch
$git-send-email --cc kernel-testers@vger.kernel.org --to
linux-wireless@vger.kernel.org --from "Alexey Fisher
<bug-track@fisher-privat.net>" --smtp-server mail.gmx.net --smtp-user
me@gmx.net --smtp-ssl  ../pending/0001-ipw2200.patch 

