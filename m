Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42198 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2KUTqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 14:46:22 -0500
Date: Wed, 21 Nov 2012 14:43:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2012-11-21
Message-ID: <20121121194326.GG2066@tuxdriver.com> (sfid-20121121_204626_121986_42EBC87A)
References: <1353507914.10444.28.camel@jlt4.sipsolutions.net>
 <20121121182131.GB2066@tuxdriver.com>
 <20121121183756.GC2066@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20121121183756.GC2066@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, figured it out...

On Wed, Nov 21, 2012 at 01:37:56PM -0500, John W. Linville wrote:
> There was a merge conflict on that file, I may have screwed it up...
> 
> On Wed, Nov 21, 2012 at 01:21:32PM -0500, John W. Linville wrote:
> > Hmmm...building wireless-next with an allyesconfig:
> > 
> >   CC      drivers/net/wireless/iwlwifi/pcie/trans.o
> > drivers/net/wireless/iwlwifi/pcie/trans.c: In function ‘iwl_trans_pcie_alloc’:
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1288:3: error: label ‘out_pci_release_regions’ used but not defined
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1281:3: error: label ‘out_pci_disable_device’ used but not defined
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1258:3: error: label ‘out_no_pci’ used but not defined
> > drivers/net/wireless/iwlwifi/pcie/trans.c: At top level:
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1306:7: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘->’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1307:12: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘->’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1308:12: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘->’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1309:7: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘->’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1310:7: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘->’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1311:16: error: expected ‘)’ before ‘->’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1315:2: error: expected identifier or ‘(’ before ‘do’
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1315:2: error: expected identifier or ‘(’ before ‘while’
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1316:2: error: expected identifier or ‘(’ before ‘do’
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1316:2: error: expected identifier or ‘(’ before ‘while’
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1318:16: error: expected ‘)’ before ‘->’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1321:7: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘->’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1322:7: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘->’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1330:2: error: expected identifier or ‘(’ before ‘if’
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1333:2: error: expected identifier or ‘(’ before ‘return’
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1335:20: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘:’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1337:24: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘:’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1339:23: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘:’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1341:11: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘:’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1343:2: error: expected identifier or ‘(’ before ‘return’
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1344:1: error: expected identifier or ‘(’ before ‘}’ token
> > drivers/net/wireless/iwlwifi/pcie/trans.c: In function ‘iwl_trans_pcie_alloc’:
> > drivers/net/wireless/iwlwifi/pcie/trans.c:1304:2: warning: control reaches end of non-void function [-Wreturn-type]
> > make[2]: *** [drivers/net/wireless/iwlwifi/pcie/trans.o] Error 1
> > 
> > On Wed, Nov 21, 2012 at 03:25:14PM +0100, Johannes Berg wrote:
> > > John,
> > > 
> > > In his quest to try to understand the current iwlwifi problems (like
> > > stuck queues etc.) Emmanuel has first cleaned up the PCIe code, I'm
> > > including his changes in this pull request. Other than that I only have
> > > a small cleanup from Sachin Kamat to remove a duplicate include and a
> > > bugfix to turn off MFP if software crypto is enabled, but this isn't
> > > really interesting as MFP isn't supported right now anyway.
> > > 
> > > Please pull.
> > > 
> > > Thanks,
> > > johannes
> > > 
> > > The following changes since commit d18aa87fbfe80f33076942d11f19c9d813e835b1:
> > > 
> > >   iwlwifi: return commands with error on FW error (2012-11-09 20:55:14 +0100)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> > > 
> > > for you to fetch changes up to eea54c8ec971d4759c541dba351477dafc39ce54:
> > > 
> > >   iwlwifi: remove effectless assignment (2012-11-21 11:30:39 +0100)
> > > 
> > > ----------------------------------------------------------------
> > > Emmanuel Grumbach (14):
> > >       iwlwifi: don't warn if transport's allocation failed
> > >       iwlwifi: don't enable interrupt as a W/A when MSI is enabled
> > >       iwlwifi: add comments for the PCIe transport statuses
> > >       iwlwifi: rename functions in transport layer
> > >       iwlwifi: init the replenish work in rx_init
> > >       iwlwifi: continue clean up - pcie/rx.c
> > >       iwlwifi: continue clean up - pcie/trans.c
> > >       iwlwifi: continue clean up - pcie/tx.c
> > >       iwlwifi: merge 2 functions in reclaim flow
> > >       iwlwifi: make iwl_queue_used return bool
> > >       iwlwifi: more cleanup in pcie/rx.c
> > >       iwlwifi: make iwl_pcie_rxq_inc_wr_ptr static
> > >       iwlwifi: update the RB_TIMEOUT to 0x11
> > >       iwlwifi: remove effectless assignment
> > > 
> > > Johannes Berg (1):
> > >       iwlwifi: disallow MFP with software crypto
> > > 
> > > Sachin Kamat (1):
> > >       iwlwifi: Remove duplicate inclusion of iwl-trans.h in pcie/drv.c
> > > 
> > >  drivers/net/wireless/iwlwifi/dvm/mac80211.c  |    9 +-
> > >  drivers/net/wireless/iwlwifi/dvm/main.c      |    2 -
> > >  drivers/net/wireless/iwlwifi/iwl-config.h    |    2 +-
> > >  drivers/net/wireless/iwlwifi/iwl-fh.h        |    2 +-
> > >  drivers/net/wireless/iwlwifi/pcie/drv.c      |    1 -
> > >  drivers/net/wireless/iwlwifi/pcie/internal.h |  104 +--
> > >  drivers/net/wireless/iwlwifi/pcie/rx.c       |  357 ++++++--
> > >  drivers/net/wireless/iwlwifi/pcie/trans.c    | 1018 ++---------------------
> > >  drivers/net/wireless/iwlwifi/pcie/tx.c       | 1146 ++++++++++++++++++++------
> > >  9 files changed, 1299 insertions(+), 1342 deletions(-)
> > > 
> > > 
> > > 
> > 
> > -- 
> > John W. Linville		Someday the world will need a hero, and you
> > linville@tuxdriver.com			might be all we have.  Be ready.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
