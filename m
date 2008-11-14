Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:22458 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYKNSeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 13:34:12 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1536931wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 10:34:11 -0800 (PST)
Message-ID: <b6c5339f0811141034v7facb7bcgeabad400e5efc9b@mail.gmail.com> (sfid-20081114_193415_939908_938C92AF)
Date: Fri, 14 Nov 2008 13:34:11 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Dan McGee" <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	"Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <43e72e890811141006x1c396c78ube87a526f1435676@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <43e72e890811140937h4dc03cf8g50df7f74efcd28b2@mail.gmail.com>
	 <b6c5339f0811140949m462e3eecx49f114f729b33e7c@mail.gmail.com>
	 <43e72e890811141006x1c396c78ube87a526f1435676@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 1:06 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Wow.. ok, yeah I see that, this is a mac8021 bug then unless mac80211
> wants us to not callieee80211_register_hw() from probe or its children
> which would be weird.
>
> So we need to fix that.

Err, wait, I'm wrong.  That's pci_dev->driver, not pci_dev->dev->driver.

-- 
Bob Copeland %% www.bobcopeland.com
