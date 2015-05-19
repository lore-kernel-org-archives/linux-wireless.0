Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34827 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbbESXAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 19:00:38 -0400
Date: Wed, 20 May 2015 06:59:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
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
Message-ID: <20150519225945.GB5718@gondor.apana.org.au> (sfid-20150520_010042_802513_BFEF4EB0)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
 <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com>
 <20150506033330.GA16470@gondor.apana.org.au>
 <1430988137.8171.58.camel@x220>
 <1431021995.8171.97.camel@x220>
 <20150518200100.GY23057@wotan.suse.de>
 <1431981930.9091.29.camel@x220>
 <20150519000921.GA23057@wotan.suse.de>
 <1432022535.9091.48.camel@x220>
 <20150519154630.GB23057@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150519154630.GB23057@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 05:46:30PM +0200, Luis R. Rodriguez wrote:
>
> Instead of depends on we should just drop it and and issues arise we
> should fix them provided an allyesconfig and allmodconfig work when
> FW_LOADER is disabled. That was the approach I wanted to take at
> least. To make this easier to phase we can break it down by subsystem.

Modules select FW_LOADER because they call request_firmware.

If you disable FW_LOADER then every case will result in a build
failure.  So you must either have a select or a depends on.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
