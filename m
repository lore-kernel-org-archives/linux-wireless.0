Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:46287 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760254AbYHDSsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 14:48:00 -0400
Received: by nf-out-0910.google.com with SMTP id d3so774691nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 11:47:40 -0700 (PDT)
Message-ID: <1d9d9b240808041147n5032160v252e1bc956c97902@mail.gmail.com> (sfid-20080804_204811_564360_738DC61A)
Date: Mon, 4 Aug 2008 20:47:39 +0200
From: "David Planella" <david.planella@googlemail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, acx100-devel@lists.sourceforge.net,
	gregkh@suse.de, greg@kroah.com, xazz.xazz@googlemail.com,
	"Andreas Mohr" <andi@lisas.de>, andim2@users.sourceforge.net
Subject: The tiacx driver situation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm since very recently one of the maintainers of the OSS acx100
driver [1][2] (also known as tiacx at some point), aimed at the family
of acx1xx wireless chipsets from Texas instruments (TI).

What I am trying to do is to put the project a back in shape again and
break its isolation with regards to the other linux wireless drivers,
the ones in mainline kernel. Hence this e-mail, where I will try to
explain the current situation and ask for advice towards a potential
inclusion to mainline.

The main problems we are facing -apart from the lack of resources,
which is not a problem specific to us- are the legal issues. For those
who did not follow the discussion back in 2006 [3], the driver got
very close to get included in 2.6.18. However, this was decided
against, due to the way its initial development started: by
reverse-engineering a binary driver from scratch without following
clean-room practices [4].

So far all attempts to contact TI have been infructuous, and they seem
to simply have been completely ignoring the acx100 driver project.

As far as I gather, there are three ways to get a working acx driver
included in the kernel:

1) TI release their code (or their specs) using a license compatible
with the kernel's licensing.
This seems very much unlikely at the moment, but it would be the ideal solution.

2) Sort out the legal mess with the current codebase.
I have been told an option would be to contact the SFLC and carry out
a code audit in the same way it was done with the atheros driver, but
as far as I understand, TI would have to agree to work on that. If
feasible -and discarding 1)-, I would find this the most attractive
option, since it would mean being able to keep using the codebase
developed through years of effort from several OSS developers.
We would also need the advice of someone more knowledgeable on this
before going down this route.
What also brought some -albeit little- hope to me is this post [6]
from Greg KH, where he mentions he might be able to get in touch with
TI. I also contacted him directly regarding this and included him on
the current CC list.

3) Remove all public sources and start development from scratch,
following clean-room procedures.
This is the view I got from a short conversation with Johannes Berg on
IRC, and would basically mean removing all sources and references to
the current acx driver from the public domain and start completely
from scratch, with two isolated development teams: one writing the
specs and the other one doing the development separately. Most of you
probably know this method from [5].
I must say I find this the cleanest solution from an engineering and
legal point of view, but I cannot help but feeling a bit unoptimistic
about this taking off with the acx driver. There is not much of a
community left, and all the people currently involved, although not
many, would also have to leave the project, as they would have been
"tainted" with the old sources. I must say I would find leaving the
project acceptable if it were the price to pay in order to get a
working, maintainable, driver, but that's only my personal view. What
I would regret though, would be having to throw away the current work
put on the driver.
In any case, even if we -the acx100 project- agreed to remove all
public sources, I do not know how feasible it would be to expect
distributions to do the same (note that e.g. the *BSD folks also use
code based on our driver).

At this point, I would like to hear your views and ask for your
advice, since I believe the only way to get out of the current
deadlock is to work together in order to find a solution.

Kind regards,
David Planella

[1] http://acx100.sourceforge.net/
[2] http://acx100.sourceforge.net/wiki/Main_Page
[3] http://acx100.sourceforge.net/wiki/History#Kernel_inclusion
[4] http://lkml.org/lkml/2006/6/5/39
[5] http://bcm-specs.sipsolutions.net/
[6] http://marc.info/?l=linux-usb&m=121782079826639&w=2
