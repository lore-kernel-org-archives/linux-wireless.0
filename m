Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:60914 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYKNRCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 12:02:31 -0500
Received: by yw-out-2324.google.com with SMTP id 9so665471ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 09:02:30 -0800 (PST)
Message-ID: <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com> (sfid-20081114_180245_553952_DEABE649)
Date: Fri, 14 Nov 2008 12:02:30 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Dan McGee" <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	"Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 1:17 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> If our offsets are the same then its probably on line 791:
[...]
> 790             name = wiphy_dev(local->hw.wiphy)->driver->name;
> 791             local->hw.workqueue = create_freezeable_workqueue(name);

I agree, having looked at the objdump output.  Hmm, maybe ->driver pointer
is bad even though I can't see that happening.  Dan, can you try adding a
printk before line 790 to see if any of the pointers are null?

Also, do you have CONFIG_LOCKDEP enabled or no?

-- 
Bob Copeland %% www.bobcopeland.com
