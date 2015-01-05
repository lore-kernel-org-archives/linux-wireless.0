Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42013 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbbAEKlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 05:41:17 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: pull request: iwlwifi 2015-01-05
Date: Mon, 5 Jan 2015 10:41:12 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B5E24A4@hasmsx107.ger.corp.intel.com> (sfid-20150105_114120_181716_2E7FC535)
References: <1420449079.12040.3.camel@egrumbacBox>
 <87ppat3518.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87ppat3518.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
> 
> > This is new content for 3.19. Details in the tag. Let me know if you have
> issues.
> > Thanks!
> 
> Thanks, pulled.
> 
> One comment:
> 
> > ----------------------------------------------------------------
> > * fix for 7265D NVM check
> > * fixes for scan: fix long scanning times and network
> > 	discovery
> > * new firmware API for iwlmvm supported devices
> > * fixes in rate control
> >
> > ----------------------------------------------------------------
> > Arik Nemtsov (1):
> >       iwlwifi: pcie: correctly define 7265-D cfg
> >
> > David Spinadel (2):
> >       iwlwifi: mvm: add a flag to enable match found notification
> >       iwlwifi: mvm: scan dwell time corrections
> >
> > Emmanuel Grumbach (2):
> >       iwlwifi: 7000: fix reported firmware name for 7265D
> >       iwlwifi: bump firmware API for mvm devices to 12
> 
> To me the firmware API bump is in a gray area, I don't see how it really fixes
> anything. I would feel much more comfortable if the patch would document
> why the bump is needed in -rc series and why it couldn't wait for -next. I'm
> guessing it has somethign to do with the dwell time corrections, but it's not
> obvious to me (and others).
> 

The bum firmware API is gray area - but it allows to load new firmware that typically
have lots of bug fixes. Especially since 3.19 will probably be used by major distributions
and I want to be able to load the new firmware there.
The driver code in 3.19 is ready to load the 12 firmware, hence the change.
