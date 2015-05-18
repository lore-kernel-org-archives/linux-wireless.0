Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168AbbERUBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 16:01:06 -0400
Date: Mon, 18 May 2015 22:01:00 +0200
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
Message-ID: <20150518200100.GY23057@wotan.suse.de> (sfid-20150518_220115_538178_622CDDF5)
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
> See, FW_LOADER is 'y' unless EXPERT is set and one goes to the trouble
> of setting FW_LOADER to 'n'. So in the 100+ places where FW_LOADER is
> selected, that is done for, almost always, no immediate benefit.
> Changing those places to use
>     depends on FW_LOADER
> 
> should have no effect, I think. Except for the EXPERT people not wanting
> FW_LOADER. But that would be putting the burden where it belongs, I'd
> say.

Paul, how would you recommend we proceed with this? Should we go ahead and
change all 'select FW_LOADER' to 'depends on' ? If not does this need to be
fixed on kconfig?

 Luis
