Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbEGS3B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 14:29:01 -0400
Date: Thu, 7 May 2015 20:28:38 +0200
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
Message-ID: <20150507182838.GA20018@wotan.suse.de> (sfid-20150507_202906_770867_4DDDCBB5)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
 <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com>
 <20150506033330.GA16470@gondor.apana.org.au>
 <1430988137.8171.58.camel@x220>
 <1431021995.8171.97.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431021995.8171.97.camel@x220>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 07, 2015 at 08:06:35PM +0200, Paul Bolle wrote:
> On Thu, 2015-05-07 at 10:42 +0200, Paul Bolle wrote:
> > On Wed, 2015-05-06 at 11:33 +0800, Herbert Xu wrote:
> > > On Tue, May 05, 2015 at 05:44:21PM -0700, Luis R. Rodriguez wrote:
> > > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > > 
> > > > We're going to add firmware module signing support, but when we do
> > > > this we end up with the following recursive dependency. Fix this by
> > > > just depending on FW_LOADER, which is typically always enabled
> > > > anyway.
> > > > 
> > > > mcgrof@ergon ~/linux-next (git::master)$ make allnoconfig
> > > > scripts/kconfig/conf  --allnoconfig Kconfig
> > > > crypto/Kconfig:15:error: recursive dependency detected!
> > > > crypto/Kconfig:15:      symbol CRYPTO is selected by SYSDATA_SIG
> > > > init/Kconfig:1880:      symbol SYSDATA_SIG is selected by FIRMWARE_SIG
> > > > drivers/base/Kconfig:88:        symbol FIRMWARE_SIG depends on FW_LOADER
> > > > drivers/base/Kconfig:80:        symbol FW_LOADER is selected by CRYPTO_DEV_QAT
> > > > drivers/crypto/qat/Kconfig:1:   symbol CRYPTO_DEV_QAT is selected by CRYPTO_DEV_QAT_DH895xCC
> > > > drivers/crypto/qat/Kconfig:13:  symbol CRYPTO_DEV_QAT_DH895xCC depends on CRYPTO
> > > 
> > > This doesn't look like a real cycle to me so perhaps we can fix
> > > kbuild to understand this?
> > 
> > (Dependency circles involving selects still hurt my brain.)
> > 
> > Perhaps Luis should have another look at 02/12. See that patch adds this
> > Kconfig entry to init/Kconfig:
> >     config SYSDATA_SIG
> > 	def_bool y
> > 	select SYSTEM_TRUSTED_KEYRING
> > 	select KEYS
> > 	select CRYPTO
> > 	select ASYMMETRIC_KEY_TYPE
> > 	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> > 	select PUBLIC_KEY_ALGO_RSA
> > 	select ASN1
> > 	select OID_REGISTRY
> > 	select X509_CERTIFICATE_PARSER
> > 
> > As far as I can see this is not enclosed in anything that adds any
> > dependencies. So that basically means that SYSDATA_SIG will always be
> > set, for all architectures (because I think all arches source
> > init/Kconfig). That should make it a pretty pointless symbol (except for
> > the fact that it does trigger all those selects).
> > 
> > The same patch also adds
> > 	select SYSDATA_SIG
> > 
> > to the entry for MODULE_SIG. But to me that looks like a nop, because
> > SYSDATA_SIG will be set anyhow. So, but this is just I guess, the
> > problem might go away if
> > 	def_bool y
> > 
> > is changed to just
> > 	bool
> 
> No, it doesn't. But the change I propose still makes sense, anyway.

Thanks, yeah that should be fixed to def_bool n. I had tried def_bool n
before my submission and that didn't fix it, for some reason I forgot to
ammend that change.

> > (Note that I haven't actually tested anything here, and it wouldn't be
> > the first time my reasoning about Kconfig patches is completely off.)
> 
> Hear, hear!
> 
> > And, whatever the value of my analysis, adding a Kconfig problem in
> > 02/12 just to fix it in 03/12 is a bit silly. I think the patches should
> > be squashed if the problem can't be solved any other way.
> 
> It seems the circular dependency warning is triggered by 5/12.
> 
> And, having now fiddled a bit with this series, I think the approach
> taken in this patch might actually be preferable treewide.
> 
> See, FW_LOADER is 'y' unless EXPERT is set and one goes to the trouble
> of setting FW_LOADER to 'n'. So in the 100+ places where FW_LOADER is
> selected, that is done for, almost always, no immediate benefit.
> Changing those places to use
>     depends on FW_LOADER
> 
> should have no effect, I think. Except for the EXPERT people not wanting
> FW_LOADER. But that would be putting the burden where it belongs, I'd
> say.

I think this is a correct assessment but only because FW_LOADER is
exposed as optional via EXPERT mode. We can go on a cursade for that
if folks are OK with that.

> Am I missing something here?

Yeah, I think this issue is deeper and *must* be fixed as otherwise
we can't later do more complex intersection dependencies. What we
do *for now* -- perhaps my patch is OK then given your assessemnt,
but for our TODO item, we must keep track that we need to fix this.

Let me explain.

Based on a closer look at the qat Kconfig file I think the issue
might be that for some reason kbuild is assuming that a symbol's
select's and their own dependencies are in and of themselves
related dependencies, that is incorrect. Although the request_firmware()
call is done within the common code (CRYPTO_DEV_QAT), if just for
testing purposes of my point we move "select FW_LOADER" to
CRYPTO_DEV_QAT_DH895xCC the dependency issue becomes clearer:

mcgrof@ergon ~/linux-next (git::your-recursive-qat-mom)$ make allnoconfig
scripts/kconfig/conf  --allnoconfig Kconfig
crypto/Kconfig:15:error: recursive dependency detected!
crypto/Kconfig:15:	symbol CRYPTO is selected by SYSDATA_SIG
init/Kconfig:1880:	symbol SYSDATA_SIG is selected by FIRMWARE_SIG
drivers/base/Kconfig:88:	symbol FIRMWARE_SIG depends on FW_LOADER
drivers/base/Kconfig:80:	symbol FW_LOADER is selected by CRYPTO_DEV_QAT_DH895xCC
drivers/crypto/qat/Kconfig:12:	symbol CRYPTO_DEV_QAT_DH895xCC depends on CRYPTO
#
# configuration written to .config
#

I'm saying that *if* the request_firmware() call was in
CRYPTO_DEV_QAT_DH895xCC it would be wrong for kbuild to think
that CRYPTO is somehow a dependency for FW_LOADER, although
the above does not say that I think I thinks that as otherwise
I cannot see why this would be considered a recursive dependency.

This issue can be made clear by just removing as a test
CRYPTO_DEV_QAT all together and having CRYPTO_DEV_QAT_DH895xCC
select CRYPTO:

config CRYPTO_DEV_QAT_DH895xCC                                                  
        tristate "Support for Intel(R) DH895xCC"                                
        depends on X86 && PCI                                                   
        default n                                                               
        select CRYPTO                                                           
        select FW_LOADER                                                        
        help                                                                    
          Support for Intel(R) DH895xcc with Intel(R) QuickAssist Technology    
          for accelerating crypto and compression workloads.                    
                                                                                
          To compile this as a module, choose M here: the module                
          will be called qat_dh895xcc. 

mcgrof@ergon ~/linux-next (git::your-recursive-qat-mom)$ make allnoconfig
scripts/kconfig/conf  --allnoconfig Kconfig
crypto/Kconfig:15:error: recursive dependency detected!
crypto/Kconfig:15:	symbol CRYPTO is selected by SYSDATA_SIG
init/Kconfig:1880:	symbol SYSDATA_SIG is selected by FIRMWARE_SIG
drivers/base/Kconfig:88:	symbol FIRMWARE_SIG depends on FW_LOADER
drivers/base/Kconfig:80:	symbol FW_LOADER is selected by CRYPTO_DEV_QAT_DH895xCC
drivers/crypto/qat/Kconfig:1:	symbol CRYPTO_DEV_QAT_DH895xCC depends on CRYPTO
#
# configuration written to .config
#

So it should not mean that if CRYPTO_DEV_QAT_DH895xCC's selects something
that that select depends on other of CRYPTO_DEV_QAT_DH895xCC's
selects. For instance in this case it would would mean that we
could not negate a feature that other drivers that selected FW_LOADER
enabled.

Here's a simple test Kconfig entry one can use to test this:

Let's say rock climbers hate locker rooms, but swimmer need them. We can
then have:

config GYM                                                                      
        tristate                                                                
        default n                                                               
                                                                                
config LOCKER                                                                   
        tristate                                                                
        default n                                                               
        depends on GYM                                                          
                                                                                
config SWIMMING                                                                 
        tristate                                                                
        default n                                                               
        select GYM                                                              
        select LOCKER                                                           
                                                                                
config ROCK_CLIMBING                                                            
        tristate                                                                
        default n                                                               
        depends on !LOCKER                                                      
        select GYM  

Kbuild seems to believe that because swimmers need lockers that rock climbers
need them too. That is obviously not true.

mcgrof@ergon ~/linux-next (git::your-swimming-dad)$ make allnoconfig
scripts/kconfig/conf --allnoconfig Kconfig
drivers/crypto/qat/Kconfig:25:error: recursive dependency detected!
drivers/crypto/qat/Kconfig:25:	symbol GYM is selected by ROCK_CLIMBING
drivers/crypto/qat/Kconfig:40:	symbol ROCK_CLIMBING depends on LOCKER
drivers/crypto/qat/Kconfig:29:	symbol LOCKER depends on GYM
#
# configuration written to .config
#

So kbuild does not accept intersection of a feature as a possible outlet
for a dependency, it wants things very atomic. In the FW_SIG case we do
want to enable FW_LOADER but not have all drivers require CRYPTO. The
issue is created because kbuild thinks FW_LOADER depends on CRYPTO
given that a driver selects it.

  Luis
