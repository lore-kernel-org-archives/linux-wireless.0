Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:8699 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbYKNSRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 13:17:06 -0500
Received: by ti-out-0910.google.com with SMTP id b6so920161tic.23
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 10:17:04 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18717.49111.572993.44410@localhost.localdomain> (sfid-20081114_191711_705877_0B70AEB0)
Date: Fri, 14 Nov 2008 23:43:43 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Bob Copeland" <me@bobcopeland.com>,
	"Dan McGee" <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	"Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
In-Reply-To: <43e72e890811141006x1c396c78ube87a526f1435676@mail.gmail.com>
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	<43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	<b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	<43e72e890811140937h4dc03cf8g50df7f74efcd28b2@mail.gmail.com>
	<b6c5339f0811140949m462e3eecx49f114f729b33e7c@mail.gmail.com>
	<43e72e890811141006x1c396c78ube87a526f1435676@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Fri, Nov 14, 2008 at 9:49 AM, Bob Copeland <me@bobcopeland.com> wrote:
> > On Fri, Nov 14, 2008 at 12:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> >> Anyway we do set the parent before calling ieee80211_register_hw() by
> >> using SET_IEEE80211_DEV(hw, &pdev->dev) (oh ok here is the parent). so
> >> when we try to get the name with parent->driver I am not sure if
> >> driver has been set yet because ath5k_pci_probe() hasn't finished yet
> >> as probe called ath5k_hw_attach(). When does ->driver get set and why
> >> would it fail only for ath5k?
> >
> > Ahh, I believe that would be in pci-driver.c __pci_device_probe, after driver
> > probe is run successfully.  Yes, we do ieee80211_register_hw from within
> > probe...  So, how did this ever work again? /me scratches head.
> 
> Wow.. ok, yeah I see that, this is a mac8021 bug then unless mac80211
> wants us to not callieee80211_register_hw() from probe or its children
> which would be weird.

>From the original log:
ath5k_pci 0000:01:00.0: registered as ''

Sujith
