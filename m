Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933553AbbELQIW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 12:08:22 -0400
Date: Tue, 12 May 2015 18:08:11 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org,
	Bruce Allan <bruce.w.allan@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	John Griffin <john.griffin@intel.com>
Subject: Re: [PATCH v1 03/12] crypto: qat - address recursive dependency when
 fw signing is enabled
Message-ID: <20150512160811.GB23057@wotan.suse.de> (sfid-20150512_180841_524977_616E987F)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
 <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com>
 <20150506033330.GA16470@gondor.apana.org.au>
 <1430988137.8171.58.camel@x220>
 <1431021995.8171.97.camel@x220>
 <20150507182838.GA20018@wotan.suse.de>
 <1431029675.8171.109.camel@x220>
 <1431121983.2398.54.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431121983.2398.54.camel@x220>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 08, 2015 at 11:53:03PM +0200, Paul Bolle wrote:
> On Thu, 2015-05-07 at 22:14 +0200, Paul Bolle wrote:
> > Tomorrow, after a (western European) night of sleep, I hope to explain
> > why the error in dad's file makes sense. I'm not much of a teacher so I
> > need a clear head to do that.
> 
> Let's start with mom's Kconfig file. It triggers
> 	error: recursive dependency detected!
> 	symbol GYM depends on ROCK_CLIMBING
> 	symbol ROCK_CLIMBING depends on LOCKER
> 	symbol LOCKER depends on GYM
> 
> Now you should realize that the kconfig tools have to answers questions
> like these, for each (tristate) symbol:
> 	- must it be 'n'; or
> 	- can it be 'm'; or
> 	- can it be 'y'.
> 
> Take, for example: can GYM be 'y'? Since GYM depends on ROCK_CLIMBING,
> it can only be 'y' if ROCK_CLIMBING is 'y' (both being tristate). And
> ROCK_CLIMBING depends on LOCKER, so ROCK_CLIMBING can only be 'y' if
> LOCKER is 'y' (ditto). And LOCKER, in its turn, depends on GYM, so it
> can only be 'y', if GYM is 'y'.
> 
> But we can't say whether GYM is 'y' yet, as it can still be 'n', 'm', or
> 'y' for all we know. So we can't answer that question. Hence the
> recursive dependency error. (There must be a term for this obvious
> problem in formal logic, but I'm not trained in formal logic.)
> 
> On to dad's Kconfig file (which is your example, but simplified). That
> triggers:
> 	error: recursive dependency detected!
> 	symbol GYM is selected by ROCK_CLIMBING
> 	symbol ROCK_CLIMBING depends on LOCKER
> 	symbol LOCKER depends on GYM

Note, I had ROCK_CLIMBING depeneds on !LOCKER, but indeed LOCKER does
depend on GYM.

> Let's try to determine whether GYM should be 'n'. Well, GYM is selected
> by ROCK_CLIMBING so it cannot be 'n' if ROCK_CLIMBING is 'm' or 'y'. (If
> ROCK_CLIMBING is 'm' it can be 'm' or 'y', but not 'n', and if
> ROCK_CLIMBING is 'y' it must be 'y'.) Do we know whether ROCK_CLIMBING
> should be 'n'? It should be 'n' only if LOCKER is 'n'. And LOCKER should
> in its turn be 'n' if GYM is 'n'. But we don't know yet what GYM will
> be. So, again, we can't answer this question. Recursive dependency
> error!

True, whether or not it was "depend on LOCKER" or "depends on !LOCKER"
in order to answer the negative question of whether GYM should be 'n'
indeed we reach a recursive dependency because of the indirect
link between rock climbing and gym through a depends which does have
a direct dependency. The issue here though is we want a "select" to
do work for us, we don't want it to resolve all the logic's possible
questions yet. The select is saying enable GYM now, and it should do
that now (in your case above) if LOCKER is enabled. Now, since LOCKER
does depend on GYM though it should mean that what items were selected
were dependencies of LOCKER we should go ahead and also enable those,
in this case it is GYM but we know we want that enabled, so we can
enable both now.

In light of what you described then I wonder if we do not need to
ask certain questions on the kbuild logic when select is used, or
if we need a whitelist?

> The complicated error you ran into was
> 	error: recursive dependency detected!
> 	symbol CRYPTO is selected by SYSDATA_SIG
> 	symbol SYSDATA_SIG is selected by FIRMWARE_SIG
> 	symbol FIRMWARE_SIG depends on FW_LOADER
> 	symbol FW_LOADER is selected by CRYPTO_DEV_QAT
> 	symbol CRYPTO_DEV_QAT is selected by CRYPTO_DEV_QAT_DH895xCC
> 	symbol CRYPTO_DEV_QAT_DH895xCC depends on CRYPTO
> 
> I'm lazy, so I haven't gone through this error step by step. But I'm
> sure it's just a complicated version of what I tried to explain in the
> above two examples. But if you're unconvinced I'll try to go through
> this error too.

No thanks, you've done an awesome job in explaining why it is proper and
recursive given the above two examples by considering the requirements that
kconfig has to address.

> Now I'm sure the point I'm trying to make can be made more convincingly
> and more elegantly. But the thing is, I think, that given how "select"
> works and how "depends on" works, some setups will trigger these errors.
> One might wish that "select" or "depends on" behaved differently, but
> with the thousands of Kconfig symbols now in use, that really looks
> unfeasible.

Yeah I am not sure if a fix is as simple as I described.

In the meantime I'll go ahead with the original patch but change the
wording given that FW_LOADEr is EXPERT and this is still being discussed.

  Luis
