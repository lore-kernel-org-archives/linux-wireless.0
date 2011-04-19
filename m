Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1DSL40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 07:56:26 -0400
Subject: Re: [PATCH wireless-2.6] iwlwifi: fix frame injection for HT
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>
In-Reply-To: <20110419114158.GA3445@redhat.com>
References: <1303141291-902-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20110419114158.GA3445@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 13:56:12 +0200
Message-ID: <1303214172.3603.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-19 at 13:41 +0200, Stanislaw Gruszka wrote:
> On Mon, Apr 18, 2011 at 08:41:31AM -0700, Wey-Yi Guy wrote:
> > From: Daniel Halperin <dhalperi@cs.washington.edu>
> > 
> > For some reason, sending QoS configuration causes transmission to stop
> > after a single frame on HT channels when not associated. Removing the
> > extra QoS configuration has no effect on station mode, and fixes
> > injection mode.
> > 
> > Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> > these patches are also available from wireless-2.6 branch on
> >  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> 
> This is basically revert of:
> 
> commit 35a6eb36520b938742d8680fd8d821df20982ced
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Wed Nov 10 09:56:43 2010 -0800
> 
>     iwlwifi: resending QoS command when HT changes

Indeed.
    

> Does problem that 35a6eb36520b938742d8680fd8d821df20982ced fixed
> gone now? How?

Yes, Shanyu had another patch to send QoS info after RXON, so this one
isn't necessary any more.

johannes

