Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab1CGBqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 20:46:05 -0500
Subject: Re: [ipw3945-devel] can't compile iwlwifi latest wireless-testing
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20110307012714.GA2465@tuxdriver.com>
References: <AANLkTimaVjAsW4g8kAfi=vQaPCabkj-ZO9vZw_Lex7KY@mail.gmail.com>
	 <1299446809.5082.161.camel@wwguy-huron>
	 <20110307012714.GA2465@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 17:30:19 -0800
Message-ID: <1299461419.5082.170.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Sun, 2011-03-06 at 17:27 -0800, John W. Linville wrote:
> On Sun, Mar 06, 2011 at 01:26:49PM -0800, Guy, Wey-Yi wrote:
> > Hi Daniel,
> > 
> > 
> > On Fri, 2011-03-04 at 16:15 -0800, Daniel Halperin wrote:
> > > drivers/net/wireless/iwlwifi/iwl-rx.c: In function
> > > ‘iwl_rx_card_state_notif’:
> > > drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: ‘TASK_INTERRUPTIBLE’
> > > undeclared (first use in this function)
> > > drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: (Each undeclared
> > > identifier is reported only once
> > > drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: for each function it
> > > appears in.)
> > > 
> > > 
> > > iwl-tx.c has an include for sched.h that isn't here and is probably
> > > the problem.
> > > 
> > > 
> > Stanislow last patch   
> > commit 466a19a003f3b45a755bc85f967c21da947f9a00: iwlwifi: move rx
> > handlers code to iwl-rx.c
> > break the compile
> > 
> > John, please revert the patch
> 
> That seems a bit silly.  Does adding an include for sched.h to iwl-rx.c
> fix the build issue?
> 
> I wonder why this builds fine for me?  What arch fails to build?

yes, adding sched.h works just fine and it is easy to fix, just not sure
should we add a patch and leave the compile broken or revert the patch
then re-submit with one line added. both works for me; just don't like
have the code can not compile at one point. :-)

it is my regular ubuntu 32 bit build system for me and nothing
different, not sure why works for you?

Thanks
Wey


