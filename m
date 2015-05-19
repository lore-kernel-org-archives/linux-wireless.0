Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbbESAJ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 20:09:26 -0400
Date: Tue, 19 May 2015 02:09:21 +0200
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
Message-ID: <20150519000921.GA23057@wotan.suse.de> (sfid-20150519_020942_820293_B8CEDF4D)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
 <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com>
 <20150506033330.GA16470@gondor.apana.org.au>
 <1430988137.8171.58.camel@x220>
 <1431021995.8171.97.camel@x220>
 <20150518200100.GY23057@wotan.suse.de>
 <1431981930.9091.29.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431981930.9091.29.camel@x220>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2015 at 10:45:30PM +0200, Paul Bolle wrote:
> [...] so, probably, almost
> all .config files have FW_LOADER set. So I think, except for some corner
> cases, either converting all "select FW_LOADER" to "depends on
> FW_LOADER" or simply dropping  "select FW_LOADER" all together, should
> be fine.

Well, that makes sense. I just dropped all "select FW_LOADER" entries
on next-20150518, then I enabled everything with 'make allyesconfig'
and then went into menuconfig to disable FW_LOADER. The build worked.

Going to try a few more build matrix combinations and send patches to
do away with this.

> Those corner cases should then be handled on a case by case basis. 
> 
> > If not does this need to be fixed on kconfig?
> 
> There's no reason to think the logic of the kconfig tools, as it is
> currently implemented, is flawed. Feel free to convince me of the
> opposite.

Very well, thanks so much for your review and help.

  Luis
