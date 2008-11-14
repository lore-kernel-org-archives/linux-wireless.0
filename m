Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:6779 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYKNRiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 12:38:01 -0500
Received: by yw-out-2324.google.com with SMTP id 9so673724ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 09:37:59 -0800 (PST)
Message-ID: <43e72e890811140937h4dc03cf8g50df7f74efcd28b2@mail.gmail.com> (sfid-20081114_183808_232372_CBB91E70)
Date: Fri, 14 Nov 2008 09:37:59 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Dan McGee" <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	"Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 9:02 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Nov 14, 2008 at 1:17 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> If our offsets are the same then its probably on line 791:
> [...]
>> 790             name = wiphy_dev(local->hw.wiphy)->driver->name;
>> 791             local->hw.workqueue = create_freezeable_workqueue(name);
>
> I agree, having looked at the objdump output.  Hmm, maybe ->driver pointer
> is bad even though I can't see that happening.

Yeah I tried digging through the work queue logic thing and don't see
why name would be NULL. I believe the name comes from the driver's
stack memory when it sets up the pci device driver structure. Only
puzzling thing for me is wiphy_dev() gets the wiphy->dev.parent, that
still hasn't sunken in yet for me, and how that gets you
->driver->name or how this can possibly be NULL.

Anyway we do set the parent before calling ieee80211_register_hw() by
using SET_IEEE80211_DEV(hw, &pdev->dev) (oh ok here is the parent). so
when we try to get the name with parent->driver I am not sure if
driver has been set yet because ath5k_pci_probe() hasn't finished yet
as probe called ath5k_hw_attach(). When does ->driver get set and why
would it fail only for ath5k?

  Luis
