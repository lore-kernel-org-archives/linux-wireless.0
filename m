Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48193 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaBLM1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 07:27:13 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Intel Linux Wireless (ilw@linux.intel.com)" <ilw@linux.intel.com>
Subject: RE: [RFC] iwlwifi: refactor the TX / RX ampdu override
Date: Wed, 12 Feb 2014 12:27:05 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D66597@HASMSX103.ger.corp.intel.com> (sfid-20140212_132730_507204_D9B9514D)
References: <1392196175-6219-1-git-send-email-egrumbach@gmail.com>
 <1392203989-15645-1-git-send-email-emmanuel.grumbach@intel.com>
 <20140212121314.GE1315@redhat.com>
In-Reply-To: <20140212121314.GE1315@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Subject: Re: [RFC] iwlwifi: refactor the TX / RX ampdu override
> 
> On Wed, Feb 12, 2014 at 01:19:49PM +0200, Emmanuel Grumbach wrote:
> > Note that this modifies the module parameter values / string which
> > means that distro will need to update their *.conf file (if any).
> 
> Hmm, this is not something that I would like to do ...

I thought you didn't care - ok - I'll respin

> 
> > -#define IWL_DISABLE_HT_ALL	BIT(0)
> > -#define IWL_DISABLE_HT_TXAGG	BIT(1)
> > -#define IWL_DISABLE_HT_RXAGG	BIT(2)
> > -#define IWL_DISABLE_HT_ALL	BIT(1)
> > +#define IWL_DISABLE_HT_TXAGG	BIT(1)
> > +#define IWL_DISABLE_HT_RXAGG	BIT(1)
> > +#define IWL_ENABLE_HT_TXAGG	BIT(2)
> > +#define IWL_ENABLE_HT_RXAGG	BIT(3)
> 
> I think we can keep IWL_DISABLE_HT_ALL option. I should be possible to
> make some per-device type default settings and if disable_11n == 0 use
> them. Otherwise use settings from module parameter. Will that work ?

I'd prefer to have the default based on the iwldvm vs. iwlmvm instead of adding yet another per-HW field. But yeah - it is possible.

