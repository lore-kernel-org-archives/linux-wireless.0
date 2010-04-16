Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46773 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab0DPTZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 15:25:40 -0400
Received: by pwj9 with SMTP id 9so2279880pwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 12:25:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m2y2d0a357f1004161107h2881b448ta8aebbc7fbc40486@mail.gmail.com>
References: <i2i2d0a357f1004060442sc332438bz4873484aa794aa2a@mail.gmail.com>
	<19389.36279.77368.650461@gargle.gargle.HOWL> <m2y2d0a357f1004161107h2881b448ta8aebbc7fbc40486@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 16 Apr 2010 12:18:30 -0700
Message-ID: <j2h43e72e891004161218u26635890j6e2b4a0a0b3a672b@mail.gmail.com>
Subject: Re: [ath9k_htc] Current patches against 2.6.34-rc3-git4
To: sedat.dilek@gmail.com
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 11:07 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> Thanks for the informations.
>
> Compat-wireless is broken ATM (see IRC backlog below).
>
> From #linux-wireless/freenode (German local-time - UTC+2):
> ...
> [06:52:54] <mcgrof> User-level discussions about wireless LANs on
> Linux | compat-wireless-2.6 only available for kernels >= 2.6.23
> (bleeding edge broken right now though)
> ...
> [19:13:41] <jensp> fivetwentysix: He says that he removed the atheros
> driver from compat-wireless and replaced it with
> http://git.kernel.org/?p=linux/kernel/git/mcgrof/ath9k_htc.git;a=summary

disregard that tree, its there just for historical purposes now.

> ...
>
> I was more interested in following the ath9k_htc development -
> especially against Linus-tree.
>
> A GIT repository like in [1] w/could be helpful and if it is
> "official" (don't know the status, last commit was before 7 weeks)
> worth updating in [2]?

I've noted elsewhere that what we need to do is to backport these
patches from linux-next:

22bedad3ce112d5ca1eaf043d4990fa2ed698c87 net: convert multicast list
to list_head
2f787b0b76bf5de2eaa3ca3a29d89123ae03c856 mac80211: Ensure initializing
private mc_list in prepare_multicast()

You can get compat-wireless working by reverting these patches (to
what does apply). Its what I would do to backpor t it. We cannot add
the new stuff as the new stuff relies on new changes to internal data
structures, so the way to properly backport this is to ifdef around
the new code and add the reverted code for older kernels.

I haven't had time to do this yet as it involves changes not only on
mac80211 but also on a few other drivers like libertas, etc. It should
be fairly easy to do just haven't had time yet.

  Luis
