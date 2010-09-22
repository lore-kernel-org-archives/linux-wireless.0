Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab0IVOdB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 10:33:01 -0400
Subject: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force reset while
 doing scan
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
References: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 07:33:50 -0700
Message-ID: <1285166030.12056.19.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

On Wed, 2010-09-22 at 01:57 -0700, Stanislaw Gruszka wrote:
> Hi Wey
> 
> On Fri, 17 Sep 2010 14:24:17 -0700
> Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> > When uCode error condition detected, driver try to perform either
> > rf reset or firmware reload in order bring device back to
> > working condition.
> > 
> > If rf reset is required and scan is in process, there is no need
> > to issue rf reset since scan already reset the rf.
> 
> Yes, and that is already handled by iwl_scan_initiate().
> 
> > If firmware reload is required and scan is in process, skip the
> > reload request. There is a possibility firmware reload during
> > scan cause problem.
> 
> If we skip restart request now, next will be scheduled lately (correct?,

That is correct, if we still encounter the problem.

> I think there are firmware reset requests that are not repeatable). But we
> still will have scan pending since firmware is in bad shape and will not
> finish scan. So until scan_check delayed work (7s) will not finish scan,
> will not be able to reset firmware. I do not think that is what we want.
> I think patch is good for .36, but after my current scan patches, it is
> not be needed and actually it should be reverted (see below).
> 
Agree, with your recent patch, it improve a lot on how scan abort work.
I still don't like the warning, but like you say, it might be ok since
we reloading firmware.

I will ask John to revert the patch

Thanks
Wey



