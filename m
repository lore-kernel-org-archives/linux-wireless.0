Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31415 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab0GVSiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 14:38:08 -0400
Subject: Re: iwlagn and many firmware restarts with Fedora kernel
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: drago01 <drago01@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTilxa09Cqn3icsTRAULhKBPzv5evOVPTqI-GrYiU@mail.gmail.com>
References: <1279565034.4572.36.camel@localhost.localdomain>
	 <AANLkTinGUQjPoMRmt_jeFgpxLhzma7qhfR14t_tWLvO1@mail.gmail.com>
	 <1279582174.4572.43.camel@localhost.localdomain>
	 <1279583798.28066.3.camel@wwguy-ubuntu>
	 <AANLkTinJrjvSUuOSeb6fQESN-T789wWCU1ezRXwQ3KXK@mail.gmail.com>
	 <1279744628.6548.0.camel@wwguy-ubuntu>
	 <AANLkTilxa09Cqn3icsTRAULhKBPzv5evOVPTqI-GrYiU@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 Jul 2010 11:37:29 -0700
Message-Id: <1279823849.32290.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi drago,


On Wed, 2010-07-21 at 14:00 -0700, drago01 wrote:
> On Wed, Jul 21, 2010 at 10:37 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> > Hi drago,
> > On Wed, 2010-07-21 at 12:59 -0700, drago01 wrote:
> >> On Tue, Jul 20, 2010 at 1:56 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> >> > Hi drago,
> >> >
> >> >
> >> > Are you using 5350? here I attach a "RFC patch", could you give a try to
> >> > see if it help?
> >>
> >> Not quite I am on 5300; your patch seem to only touch the 5350 code
> >> ... should I try the same change for 5300?
> >
> > Yes, please
> 
> Hi,
> 
> As there is no such field in .34 I patched the .35 driver which seems
> to be fine with the change ... I couldn't trigger it using the close
> lid (no suspend) and wait a bit trick ... but I have not used it for
> long enough to say for certain that its gone.
> 
> But unfortunately the driver has a different issue it spams my log with tons of:
> 
> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
> 
Yes, I aware of this, this is introduced by a recent patch 
commit d9763a384216336e180399b69461eae37f6c4f54

I will work on a new patch to help address this.

Thanks
Wey

