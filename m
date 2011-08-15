Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19452 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1HONxr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:53:47 -0400
Subject: Re: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by
 all layers
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
In-Reply-To: <20110815084355.GB3317@redhat.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1313257116-2697-6-git-send-email-wey-yi.w.guy@intel.com>
	 <20110815081010.GA3317@redhat.com>  <20110815084355.GB3317@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 06:13:39 -0700
Message-ID: <1313414020.15170.32.camel@wwguy-huron> (sfid-20110815_155350_052755_CD3BE8DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Mon, 2011-08-15 at 01:43 -0700, Stanislaw Gruszka wrote:
> On Mon, Aug 15, 2011 at 10:10:11AM +0200, Stanislaw Gruszka wrote:
> > What for are you doing this? These changes through patch 60 seems
> > have no sense.
> I mean only these containing priv->foo to priv->shrd->foo transastruction.
> 
> Stanislaw

iwlagn driver is under major transformation now. As you know, we split
the iwlwifi driver into iwlagn and iwlegacy which is the first step to
prepare the transformation.

now we are working on separate iwlagn driver into two layers (upper and
lower), the lower layer contains both bus and transport sub-layer which
is hw dependent, and the upper layer should be bus/hw independent. by
doing so, the single driver can handle different bus and different core
architecture.  Having the share data structure (priv->shrd->foo) between
two layers is for that reason (loosely couple).

Hope this answer the questions why we have so much "looks boring"
patches, those are the preparation work  for upcoming new stuffs.

Tanks
Wey

