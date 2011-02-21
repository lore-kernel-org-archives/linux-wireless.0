Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45264 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1BUVHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 16:07:34 -0500
Subject: Re: [ipw3945-devel] [PATCH wireless-2.6] iwlagn: Support new 5000
 microcode.
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	stable@kernel.org, linux-wireless@vger.kernel.org,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <AANLkTikFAzdV=A0uEo+5D4ixwgNz0XA3ogA00Wm=r-8t@mail.gmail.com>
References: <1298318710-23775-1-git-send-email-wey-yi.w.guy@intel.com>
	 <AANLkTikFAzdV=A0uEo+5D4ixwgNz0XA3ogA00Wm=r-8t@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 22:07:25 +0100
Message-ID: <1298322445.3836.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-21 at 21:29 +0100, Gábor Stefanik wrote:
> On Mon, Feb 21, 2011 at 9:05 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> > From: Fry, Donald H <donald.h.fry@intel.com>
> >
> > New iwlwifi-5000 microcode requires driver support for API version 5.
> >
> > Signed-off-by: Don Fry <donald.h.fry@intel.com>
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > CC: stable@kernel.org
> > ---
> > these patches are also available from wireless-2.6 branch on
> >  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> >
> >  drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
> > index 79ab0a6..537fb8c 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-5000.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
> > @@ -51,7 +51,7 @@
> >  #include "iwl-agn-debugfs.h"
> >
> >  /* Highest firmware API version supported */
> > -#define IWL5000_UCODE_API_MAX 2
> > +#define IWL5000_UCODE_API_MAX 5
> 
> Where are versions 3 and 4?

They don't (and won't) exist. We just went to version 5 wholesale to
make it easier to distinguish between the new and old file format -- in
the future new features etc. won't be announced by versions but by TLVs
in the file format (see the code that loads the ucode file from disk)
unless the firmware is completely incompatible.

johannes

