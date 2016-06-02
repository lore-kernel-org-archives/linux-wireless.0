Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55528 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbcFBIQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 04:16:10 -0400
Message-ID: <1464855365.11694.35.camel@coelho.fi> (sfid-20160602_101617_979733_7D0CF77C)
From: Luca Coelho <luca@coelho.fi>
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>,
	"me@bobcopeland.com" <me@bobcopeland.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Thu, 02 Jun 2016 11:16:05 +0300
In-Reply-To: <CAAA5faGpjybA63PMp5pzGOxbw8Zjy+vK1HwnQA4-jGGk8XWJvA@mail.gmail.com>
References: <20160529214059.GA15677@localhost>
	<CAAA5faFNa1sQrj6Yfq+hrXfUOi0Lek4qL8Zzpdv27-4+Z4n6mQ@mail.gmail.com>
	<20160601125453.GB12977@localhost>
	<1464787139.2554.74.camel@intel.com>
	<CAAA5faFaPow=Rw-1btgag9wRV-ub8=np2FgpRsoF99MPyb7row@mail.gmail.com>
	<1464841636.11694.10.camel@intel.com>
	 <CAAA5faGpjybA63PMp5pzGOxbw8Zjy+vK1HwnQA4-jGGk8XWJvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: wireless-testing on 4.7
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-06-02 at 02:02 -0600, Reinoud Koornstra wrote:
> On Wed, Jun 1, 2016 at 10:27 PM, Coelho, Luciano
> <luciano.coelho@intel.com> wrote:
> > On Wed, 2016-06-01 at 16:08 -0600, Reinoud Koornstra wrote:
> > > On Wed, Jun 1, 2016 at 7:19 AM, Coelho, Luciano
> > > <luciano.coelho@intel.com> wrote:
> > > > On Wed, 2016-06-01 at 08:54 -0400, Bob Copeland wrote:
> > > > > + Luca, Emmanuel
> > > > 
> > > > Thanks, Bob!
> > > > 
> > > > 
> > > > > On Tue, May 31, 2016 at 10:06:57PM -0600, Reinoud Koornstra
> > > > > wrote:
> > > > > > Today I compiled 4.6+ and pulled sources today
> > > > > > iwlwifi isn't super smooth.
> > > > > 
> > > > > I assume you mean wireless-testing, based on 4.7-rc1 (as this
> > > > > email
> > > > > is
> > > > > in reply to my announcement of same).
> > > > 
> > > > Yes, we need to know exactly what kernel you're using so we know
> > > > what
> > > > we're debugging.
> > > > 
> > > 
> > > Yesterday this is what I did to obtain the latest source:
> > > 
> > > git clone
> > > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > > kernel_current
> > > 
> > > This is the latest commit in that tree:
> > > 
> > > commit 367d3fd50566a313946fa9c5b2116a81bf3807e4
> > > Merge: 5eca831 cf0d44d
> > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > Date:   Tue May 31 09:43:24 2016 -0700
> > > 
> > >    Merge branch 'for-linus' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
> > > 
> > >    Pull s390 fixes from Martin Schwidefsky:
> > >     "Three bugs fixes and an update for the default configuration"
> > > 
> > >    * 'for-linus' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux:
> > >      s390: fix info leak in do_sigsegv
> > >      s390/config: update default configuration
> > >      s390/bpf: fix recache skb->data/hlen for skb_vlan_push/pop
> > >      s390/bpf: reduce maximum program size to 64 KB
> > 
> > Ah, okay.  This has nothing to do with the wireless-testing tree.  This
> > is random commit in Linus' tree.  I suggest that you use a release tag
> > or such.  For instance you could do this in Linus' tree to get the
> > current release candidate for 4.7:
> > 
> > git checkout v4.7-rc1
> > 
> > Or you could use the wireless-testing tree that Bob is maintaining,
> > which is always based on an official release candidate (currently the
> > above mentioned v4.7-rc1 release) plus the latest and greatest (and
> > probably "brokenest" :P) wireless changes:
> > 
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git
> > 
> 
> Ok, i got this tree.
> From the start it didn't work.
> 
> [    0.000000] Linux version 4.7.0-rc1-wt+
> [SNIP]
> [    2.156875] iwlwifi 0000:04:00.0: Direct firmware load for
> iwlwifi-7260-17.ucode failed with error -2
> [    2.157681] iwlwifi 0000:04:00.0: Direct firmware load for
> iwlwifi-7260-16.ucode failed with error -2
> [    2.158438] iwlwifi 0000:04:00.0: no suitable firmware found!

This is happening pretty early, did you compile the iwlwifi driver into
the kernel (instead of compiling them as modules)? There have been
problems when it's in-kernel, so we recommend that you compile them as
modules (unless strictly necessary).


> I've attached the dmesg in it's entirety.
> Booting back to 4.6:
> 
> [   17.987698] iwlwifi 0000:04:00.0: loaded firmware version
> 16.242414.0 op_mode iwlmvm
> [   18.269667] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
> Wireless AC 7260, REV=0x144

This shows that you have iwlwifi-7260-16.ucode in your file system.
 But here we are reading it much later.  So it's possible that the
kernel cannot access the firmware at a very early stage (because the
filesystem that contains it is not mounted yet) when you use in-kernel.

So, first of all, please make sure they're built as modules.  We can
continue from there then.

--
Cheers,
Luca.
