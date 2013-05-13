Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:32842 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3EMEzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 00:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <518E0CD6.3040501@hauke-m.de>
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com>
 <518DF4B1.3020706@broadcom.com> <518E0CD6.3040501@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 12 May 2013 21:55:22 -0700
Message-ID: <CAB=NE6W8ra0fzXjJdRz8tSTEa9PoNUSAQ_MCV0aRoTr3tO1WoQ@mail.gmail.com> (sfid-20130513_065548_918077_3B8A08DD)
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and cfg80211
To: Hauke Mehrtens <hauke@hauke-m.de>,
	Julia Lawall <julia.lawall@lip6.fr>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>,
	Paul Stewart <pstew@chromium.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	JoSH Lehan <krellan@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 11, 2013 at 2:18 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 05/11/2013 09:35 AM, Arend van Spriel wrote:
>> On 05/11/2013 02:52 AM, JoSH Lehan wrote:
>>> It seems I can choose to use the mac80211/cfg80211 that came with the
>>> kernel,*or*, the mac80211/cfg80211 that come with compat-drivers.  Is
>>> this correct?  I'll have to maintain these two mac80211/cfg80211
>>> drivers in separate directories, since they have the same name, and it
>>> will complicate my detection/loading script, but if there's no other
>>> way, then this is what needs to be done.
>>
>> Luis may correct me, but I think you are correct. compat-drivers
>> provides a compat.ko which is the glue between new drivers and your
>> kernel. With the new drivers you get new features provided you have new
>> mac80211/cfg80211 as well. Hence the glue is between wireless modules
>> (including mac80211/cfg80211) and rest of your kernel. On a non-embedded
>> system the compat-driver modules are installed in a separate folder
>> /lib/modules/<your_kernel_version/updates. depmod is run during the
>> install in which this folder takes precedence.
>>
>> Not sure what your use-case is. You have a system in which different
>> wireless devices may be plugged in or ...?
>
> You can only use mac80211/cfg80211 from compat-driver *or* the kernel.
> There was a plan to rename all exported symbols and make it possible to
> use both at the same time, but no one fully implemented it.

I ended up renaming as many exported symbols as I could when and only
when we were not providing a full subsystem backport for where that
exported symbol lived. You can find these pegged with a
LINUX_BACKPORT() macro. If a subsystem is backported fully we don't do
the mapping name change. I still looked at an option to provide what
you describe though and simply rename all exported symbols with a the
LINUX_BACKPORT() prefix, ie, backport_ -- and the best lead I found
was work done by Andi Kleen a while ago on introducing module
namespaces but this work got rejected. We could try to port that
ourselves somehow for backports. For details see this commit which
talks about it:

https://git.kernel.org/cgit/linux/kernel/git/mcgrof/compat.git/commit/?id=8ae967309876a9297dedfdf64dfcca406639686f

Under the new backports tree though we now use Python for some code
mangling to help us with our backport, this will specially be useful
later when we start using SmPL for patch treatment where the hunks
don't line up anymore or simply always with SmPL. Anyway, apart from
that - we also use the python script to do some mangling of Kconfig
entries for us. Given that -- it should then also be possible for us
to then treat all EXPORT_SYMBOL_GPL() (note on backports all symbols
are EXPORT_SYMBOL_GPL() or at least that was the intent, we should fix
if anything has leaked) to add the LINUX_BACKPORT() prefix for us --
but note that it still does not address the head file changes. I
suppose you could first scrape for all exported symbols and then go
also address headers.

So these are the two options I see right now, Andi's work or Python
magic. Both are projects in themselves. Patches welcomed.

I should note the compat-drivers git tree will be renamed to backports
where it now has compat and compat-drivers merged and I'll soon make
it available on kernel.org, as soon as I get all delta merged that
gets us to backport a v3.10 release. I the meantime interested
developers should look at the instructions I provided another
developer here:

http://marc.info/?l=linux-backports&m=136838721415310&w=2

As for kernel integration of backports -- that is not possible today
but I welcome such changes. I provided a hint as to how this could be
possible to do here:

http://marc.info/?l=linux-backports&m=136823203813610&w=2

Patches welcomed.

  Luis
