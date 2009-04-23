Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55871 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760693AbZDWIAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 04:00:48 -0400
Received: by fxm2 with SMTP id 2so391631fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 01:00:46 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: powersaving when interface is up but not associated
References: <1240431356.30082.18.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 23 Apr 2009 11:00:44 +0300
In-Reply-To: <1240431356.30082.18.camel@johannes.local> (Johannes Berg's message of "Wed\, 22 Apr 2009 22\:15\:56 +0200")
Message-ID: <87vdovbxzn.fsf@litku.valot.fi> (sfid-20090423_100103_193355_AA476E14)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi!

Hello,

> Just had this idea -- when our networking interfaces are UP, but not
> actually doing anything, the RF chains consume power. 

Yes, and also firmware consumes power. For example stlc4550 has a
hibernate feature to put the firmware sleep and wake it up quickly.

> This is, often, the default state, since you'll have your wifi on due
> to NM wanting to find APs, but not associated, for example when on the
> road. Sure, you can manually turn it off, but...

That's what we do in Nokia Internet tablets. wlancond it putting
interface up and down all the time and it's a hack.

> However, it doesn't seem necessary. When we are not associated to an AP,
> and there are no extra interfaces in mac80211 active like monitor
> interfaces, it seems that we could very well turn off the radio while
> not scanning. It would be entirely trivial for mac80211 to do this,
> probably a 20 line patch or so (need some bookkeeping about why radio is
> disabled so it's not just four lines).
>
> Thoughts?

I think it's a good idea. Sometimes I have thought myself that we would
need something like this.

-- 
Kalle Valo
