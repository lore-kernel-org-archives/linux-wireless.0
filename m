Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11579 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab1HPOIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 10:08:48 -0400
Subject: Re: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by
 all layers
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
In-Reply-To: <20110816092610.GB6085@redhat.com>
References: <1313257116-2697-6-git-send-email-wey-yi.w.guy@intel.com>
	 <20110815081010.GA3317@redhat.com> <20110815084355.GB3317@redhat.com>
	 <1313414020.15170.32.camel@wwguy-huron> <20110815142144.GA15718@redhat.com>
	 <1313416005.15170.35.camel@wwguy-huron> <20110815144359.GA15719@redhat.com>
	 <1313417422.15170.39.camel@wwguy-huron> <20110815151231.GB15718@redhat.com>
	 <1313422152.15170.43.camel@wwguy-huron>  <20110816092610.GB6085@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 07:04:03 -0700
Message-ID: <1313503443.6823.9.camel@wwguy-ubuntu> (sfid-20110816_160852_372389_D56CC3DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-16 at 02:26 -0700, Stanislaw Gruszka wrote:
> On Mon, Aug 15, 2011 at 08:29:12AM -0700, Guy, Wey-Yi wrote:
> > On Mon, 2011-08-15 at 08:12 -0700, Stanislaw Gruszka wrote:
> > > On Mon, Aug 15, 2011 at 07:10:22AM -0700, Guy, Wey-Yi wrote:
> > > > On Mon, 2011-08-15 at 07:44 -0700, Stanislaw Gruszka wrote:
> > > > > On Mon, Aug 15, 2011 at 06:46:45AM -0700, Guy, Wey-Yi wrote:
> > > > > > On Mon, 2011-08-15 at 07:21 -0700, Stanislaw Gruszka wrote:
> > > > > > > On Mon, Aug 15, 2011 at 06:13:39AM -0700, Guy, Wey-Yi wrote:
> > > > > > > > now we are working on separate iwlagn driver into two layers (upper and
> > > > > > > > lower), the lower layer contains both bus and transport sub-layer which
> > > > > > > > is hw dependent, and the upper layer should be bus/hw independent. by
> > > > > > > > doing so, the single driver can handle different bus and different core
> > > > > > > > architecture. Having the share data structure (priv->shrd->foo) between
> > > > > > > > two layers is for that reason (loosely couple).
> > > > > > > 
> > > > > > > You did not explained reason for introducing iwl_shared structure,
> > > > > > > actually you confirmed it is useless. You should simply share iwl_priv
> > > > > > > on any layer you have.
> > > > > > > 
> > > > > > > Stanislaw
> > > > > > 
> > > > > > It is not true, I mean "boring" but not "useless", it does not make
> > > > > > sense share all the priv with lower layer.
> > > > > 
> > > > > Why? Even if there are some fields that you will use only on
> > > > > upper layer, it does not mean that pointer to priv structure
> > > > > could not be passed to lower layer.
> > > > > 
> > > > why, if we doing that, lower layer need to know how to reference the
> > > > priv which I don't believe it is a good design. I want to make the upper
> > > > and lower layer as loose as possible and it is flexible for new
> > > > architecture.
> > > 
> > > Providing more abstraction layers than needed is worse.
> > 
> > I don't really see any issues with it
> 
> It make driver more complex than it could be.
> 
> >  and I don't believe it will cause
> > problem if we do it right. by doing so, we will improve the flexibility.
> 
> It does not offer any more flexibility than sharing iwl_priv, it
> is actually less flexible.
> 
how so, different upper layer can have differ private structure, just
has to include shrd which is shared with lower layer


> > > > > > think about I also mention
> > > > > > different core architecture, that mean we can have different upper layer
> > > > > > which has different priv; but shrd is always common to all different
> > > > > > upper layer to share with lower layer.
> > > > > 
> > > > > What different upper layer? Non mac80211, if so you should write
> > > > > separate driver for it.
> > > > 
> > > > not mac80211, it is still part of driver, but different upper layer
> > > > might/can contain different system flow. that is why I mention different
> > > > core architecture. now we are doing preparation work so you did not see
> > > > the new stuff yet.
> > > 
> > > Can we get opinion from Johannes about that, and eventually ACKs/NACKs
> > > for patches?
> > > 
> > 
> > it is pure iwlagn driver changes and not impact mac80211 at all.
> > Johannes already in the loop and he understand the changes.
> 
> I'm asking about Johannes opinion, not your opinion about his opinion :-)
> 
but I am not seeing any relation those patches related to mac80211

Wey

