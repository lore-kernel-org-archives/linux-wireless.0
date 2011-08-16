Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1HPPOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 11:14:35 -0400
Date: Tue, 16 Aug 2011 17:12:57 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by all
 layers
Message-ID: <20110816151256.GA4932@redhat.com> (sfid-20110816_171439_087550_49AF5C08)
References: <20110815084355.GB3317@redhat.com>
 <1313414020.15170.32.camel@wwguy-huron>
 <20110815142144.GA15718@redhat.com>
 <1313416005.15170.35.camel@wwguy-huron>
 <20110815144359.GA15719@redhat.com>
 <1313417422.15170.39.camel@wwguy-huron>
 <20110815151231.GB15718@redhat.com>
 <1313422152.15170.43.camel@wwguy-huron>
 <20110816092610.GB6085@redhat.com>
 <1313503443.6823.9.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313503443.6823.9.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 16, 2011 at 07:04:03AM -0700, wwguy wrote:
> > >  and I don't believe it will cause
> > > problem if we do it right. by doing so, we will improve the flexibility.
> > 
> > It does not offer any more flexibility than sharing iwl_priv, it
> > is actually less flexible.
> > 
> how so, different upper layer can have differ private structure, just
> has to include shrd which is shared with lower layer

Simply by adding to iwl_priv different struct ops/data for each upper
layer you will have. You need to have the same thing to clue with
mac80211, whatever upper layer will be. Otherwise, if mac80211 clue
have to be different, new hardware probably needs different driver.

> > > it is pure iwlagn driver changes and not impact mac80211 at all.
> > > Johannes already in the loop and he understand the changes.
> > 
> > I'm asking about Johannes opinion, not your opinion about his opinion :-)
> > 
> but I am not seeing any relation those patches related to mac80211

I would like to know Johannes opinion as iwlwifi driver developer.

Stanislaw
