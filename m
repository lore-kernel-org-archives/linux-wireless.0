Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:15965 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYKNRto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 12:49:44 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1520246wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 09:49:43 -0800 (PST)
Message-ID: <b6c5339f0811140949m462e3eecx49f114f729b33e7c@mail.gmail.com> (sfid-20081114_184948_334311_4CE115C3)
Date: Fri, 14 Nov 2008 12:49:42 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Dan McGee" <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	"Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <43e72e890811140937h4dc03cf8g50df7f74efcd28b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <43e72e890811140937h4dc03cf8g50df7f74efcd28b2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 12:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Anyway we do set the parent before calling ieee80211_register_hw() by
> using SET_IEEE80211_DEV(hw, &pdev->dev) (oh ok here is the parent). so
> when we try to get the name with parent->driver I am not sure if
> driver has been set yet because ath5k_pci_probe() hasn't finished yet
> as probe called ath5k_hw_attach(). When does ->driver get set and why
> would it fail only for ath5k?

Ahh, I believe that would be in pci-driver.c __pci_device_probe, after driver
probe is run successfully.  Yes, we do ieee80211_register_hw from within
probe...  So, how did this ever work again? /me scratches head.

-- 
Bob Copeland %% www.bobcopeland.com
