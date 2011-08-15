Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab1HOOpU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 10:45:20 -0400
Date: Mon, 15 Aug 2011 16:44:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by all
 layers
Message-ID: <20110815144359.GA15719@redhat.com> (sfid-20110815_164526_828955_8ADAC7FF)
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
 <1313257116-2697-6-git-send-email-wey-yi.w.guy@intel.com>
 <20110815081010.GA3317@redhat.com>
 <20110815084355.GB3317@redhat.com>
 <1313414020.15170.32.camel@wwguy-huron>
 <20110815142144.GA15718@redhat.com>
 <1313416005.15170.35.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313416005.15170.35.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 15, 2011 at 06:46:45AM -0700, Guy, Wey-Yi wrote:
> On Mon, 2011-08-15 at 07:21 -0700, Stanislaw Gruszka wrote:
> > On Mon, Aug 15, 2011 at 06:13:39AM -0700, Guy, Wey-Yi wrote:
> > > now we are working on separate iwlagn driver into two layers (upper and
> > > lower), the lower layer contains both bus and transport sub-layer which
> > > is hw dependent, and the upper layer should be bus/hw independent. by
> > > doing so, the single driver can handle different bus and different core
> > > architecture. Having the share data structure (priv->shrd->foo) between
> > > two layers is for that reason (loosely couple).
> > 
> > You did not explained reason for introducing iwl_shared structure,
> > actually you confirmed it is useless. You should simply share iwl_priv
> > on any layer you have.
> > 
> > Stanislaw
> 
> It is not true, I mean "boring" but not "useless", it does not make
> sense share all the priv with lower layer.

Why? Even if there are some fields that you will use only on
upper layer, it does not mean that pointer to priv structure
could not be passed to lower layer.

> think about I also mention
> different core architecture, that mean we can have different upper layer
> which has different priv; but shrd is always common to all different
> upper layer to share with lower layer.

What different upper layer? Non mac80211, if so you should write
separate driver for it.

Stanislaw
