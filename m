Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53828 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbZLDMMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 07:12:35 -0500
Received: by bwz27 with SMTP id 27so1887138bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 04:12:41 -0800 (PST)
To: Jason Young <a.young.jason@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mac80211: add U-APSD client support
References: <16a81f890912031225g888490y2e8ff92557a322b7@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 04 Dec 2009 14:12:37 +0200
In-Reply-To: <16a81f890912031225g888490y2e8ff92557a322b7@mail.gmail.com> (Jason Young's message of "Thu\, 3 Dec 2009 12\:25\:20 -0800")
Message-ID: <87ocmf545m.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Young <a.young.jason@gmail.com> writes:

> Hi,

Hello,

>>> here is my proposal how to add U-APSD client support to mac80211. I also
>>> included example driver implementation for wl1251.
>>>
>>> Please comment. Also I would like to get comments how U-APSD needs to be
>>> implemented in different hardware.
>
> WMM Admission Control allows queues to be configured as trigger-only
> and deliver-only via mgmt action frames. If this feature is ever
> added to mac80211 we may need to make trigger-enabled and
> deliver-enabled per queue configuration explicit rather than a
> single boolean value per access category. Being as there is no way
> to configure an access category trigger-only or deliver-only outside
> of admission control, we don't need to worry about this problem
> right now.

I decided to drop Admission Control for now because I didn't see any
real use case for it. And if we would like to utilise it properly, we
would need to have properly supported user space interface. I think we
are not ready for that quite yet.

> We will want runtime time configuration of u-apsd because its is
> necessary for station's 'WMM Power Save' certification. Recompiling
> mac80211 for the various uapsd configurations is a bit heavy-handed.
> I'd like to see debugfs support added back back for now its
> primarily a testing issue anyway.

Thanks, I wasn't aware of this. Yes, adding the debugfs interface back
makes sense now. But can you describe a bit more how you would like to
use the debugfs interface? I would like to understand about your needs
a bit more.

I also need to find the certification test plan and read it myself.

>>> - add max SP length defines to ieee80211.h
>
> The bit values for IEEE80211_WMM_IE_STA_SP_XXX are not correct. The
> Max SP Length subfield settings table in 7.3.1.17 has the least
> significant bit listed first.

Oh, I missed that entirely. And I was even thinking why the order
looked so weird (0, 2, 1, 3), I should have checked that. Thank you
for noticing this.

>>> v2:
>>> - remove cfg80211 changes
>>> - rename IEEE80211_QOS_IE to IEEE80211_WMM_IE_STA in ieee80211.h
>
> I would rename IEEE80211_WMM_IE_STA_XXX defines to something like
> IEEE80211_STA_QOSINFO_XXX to make it clear that bit values are used in the
> context of the qosinfo field octet.

Good point. Is IEEE80211_WMM_IE_STA_QOSINFO_AC_VO clear enough? At
least it's long enough :)

Thank you for the comments, I appreciate them.

-- 
Kalle Valo
