Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:58024
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbYGZTzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 15:55:04 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ath9k working, almost
Date: Sat, 26 Jul 2008 20:55:01 +0100
Cc: linux-wireless@vger.kernel.org
References: <200807261742.15693.alistair@devzero.co.uk> <200807262030.39724.alistair@devzero.co.uk> <43e72e890807261236j6ae4a28fuf8eaf423cce91edf@mail.gmail.com>
In-Reply-To: <43e72e890807261236j6ae4a28fuf8eaf423cce91edf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807262055.01388.alistair@devzero.co.uk> (sfid-20080726_215508_339281_1122463B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 July 2008 20:36:22 Luis R. Rodriguez wrote:
> On Sat, Jul 26, 2008 at 12:30 PM, Alistair John Strachan
>
> <alistair@devzero.co.uk> wrote:
> > On Saturday 26 July 2008 19:15:51 Luis R. Rodriguez wrote:
> >> On Sat, Jul 26, 2008 at 9:42 AM, Alistair John Strachan
> >>
> >> <alistair@devzero.co.uk> wrote:
> >> > Hi,
> >> >
> >> > The newly announced ath9k driver works great on an AR5418 Core 2 Duo
> >> > Macbook, WPA2-TKIP/AES et al all work fine. It would be good to see
> >> > this driver in wireless-testing, it completely replaces madwifi for
> >> > me. I used linux.git (2.6.26) + wireless-testing.git +
> >> > my-wireless-testing.git with success.
> >>
> >> Please keep in mind Linus' tree is just broken for wireless. But glad
> >> it is working for you after your tremendous strange changes on your
> >> tree...
> >
> > I explicitly said I was not using Linus' tree. Perhaps it is a
> > misunderstanding on your part. If you use git pull inside a tree that
> > another tree was originally forked from, it is much smaller and faster to
> > check out. This is the process I was describing. I am pretty sure there
> > are no "tremendous strange changes". :-)
>
> Well my concern was I believe Linus' tree has the new MQ stuff and
> wireless-testing doesn't. How did you handle that?

git pull will happily merge into a non-HEAD checkout. If you do something
like this (inside your linux-2.6 checkout):

git reset --hard v2.6.26
git pull git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
git pull git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git ath9k

Then you get a minimal, incremental set of changes based on 2.6.26 (which is
what most wireless-testing users will want). There are some drawbacks but it
sure beats wasting several hundred megs on two git repos.

If you want to go back to Linus you just do:

git reset --hard v2.6.26

And it'll blow away all the merges (since you were never tracking those trees).

-- 
Cheers,
Alistair.
