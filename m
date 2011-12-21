Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31878 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab1LURPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 12:15:11 -0500
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable
 when moving between multiple APs)
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: Cheng Renquan <crquan@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CA+icZUUhg91UAPMRGgXYAvo6wkr5ogb+vW8SsB28BeUP_6-g6w@mail.gmail.com>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
	 <1324424765.13074.281.camel@wwguy-huron>
	 <CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
	 <CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com>
	 <CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com>
	 <CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com>
	 <CAH5vBdLq6zOagjmyM1h9Jon+fYnz5t05Dx7u6VqOWGHna+M3_Q@mail.gmail.com>
	 <CA+icZUVixfk0h1ENU-tWMS5hgurbEV4jYpYNWbzaxCUx_b64UQ@mail.gmail.com>
	 <CAH5vBdK62juwC_qPPTfmgFkMp9XMy+3j1YLvBSxBc+zr9_oBJQ@mail.gmail.com>
	 <CA+icZUUhg91UAPMRGgXYAvo6wkr5ogb+vW8SsB28BeUP_6-g6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 08:14:34 -0800
Message-ID: <1324484074.13074.313.camel@wwguy-huron> (sfid-20111221_181514_970775_EB549447)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Renquan,

On Wed, 2011-12-21 at 03:14 -0800, Sedat Dilek wrote:
> On Wed, Dec 21, 2011 at 11:36 AM, Cheng Renquan <crquan@gmail.com> wrote:
> > On Wed, Dec 21, 2011 at 1:20 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> [...]
> > read these from MAINTAINERS, just want to confirm if iwlwifi.git has more
> > fresh content, this should be the most upstream, right?
> >
> 
> Wey-Yi or Johannes can gave you precise answers on iwwifi development.
> Of course the iwlwifi GIT (master) tree has latest stuff.
> As you might have seen there are different GIT branches for stuff to
> go into wireless-testing (experimental sofware), wireless-next
> (linux-next.git) and wireless (linux.git).
> 
http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=summary
contain the latest patches(both features and bugs fix) which being
updates on daily base. Like Sadet mention, those are experimental and
not being fully test yet. Once those new patches pass the basic
regression test. the patches will push into two different tree
wireless-next : patch contain new features
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=summary
wireless: bug fix patch
http://git.kernel.org/?p=linux/kernel/git/linville/wireless.git;a=summary
Linville also merge  both wireless-next and wireless  tree  into
wireless-testing for people who want to test the breeding edge wireless
driver changes
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=summary

of cause, Linville will push the patches to both net-next and net tree
once he believe the patches are ready.

> > (only here has new fix and fixes are verified correct, then John Linville could
> > pull from here the iwlwifi.git, right? As I understand, the MAINTAINERS model
> > should be the way of iwlwifi.git => wireless.git => net.git => linus)
> >
> 
> For mainline this workflow seems to be correct, but AFAICS you want an
> official statement, so wait for Wey-Yi's answer :-).
> 
> > INTEL WIRELESS WIFI LINK (iwlwifi)
> > M:      Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > M:      Intel Linux Wireless <ilw@linux.intel.com>
> > L:      linux-wireless@vger.kernel.org
> > W:      http://intellinuxwireless.org
> > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
> > S:      Supported
> > F:      drivers/net/wireless/iwlwifi/
> >
> >
> > By comparing the two, I got that iwlwifi.git really has more, now
> > prefetched for tomorrow
> > when in office sometimes Internet is not available, and in case
> > wireless.git with your patch
> > still does not work, I could have a try of iwlwifi.git;
> >
> 
> If you want latest iwlwifi bits, you can try also the work from there.
> But a better strategy would be to test this order:
> 1. wireless (stable)
> 2. wireless-next or linux-next (testing)
> 3. wireless-testing and/or wiwlwifi (experimental)
> 
wireless-testing = wireless + wireless-next

Thanks
Wey

> - Sedat -
> 
> > http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=history;f=drivers/net/wireless/iwlwifi
> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless.git;a=history;f=drivers/net/wireless/iwlwifi
> >
> [...]


