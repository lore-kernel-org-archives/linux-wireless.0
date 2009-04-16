Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:44563 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbZDPLBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 07:01:39 -0400
Received: by bwz17 with SMTP id 17so332091bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 04:01:37 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] mac80211 powersave improvements
References: <20090415171046.336006351@sipsolutions.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 14:01:36 +0300
In-Reply-To: <20090415171046.336006351@sipsolutions.net> (Johannes Berg's message of "Wed\, 15 Apr 2009 19\:10\:46 +0200")
Message-ID: <87iql4981b.fsf@litku.valot.fi> (sfid-20090416_130142_806176_C3951E7E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi,

Hallo,

> This series contains the following:
>
>  1) improve powersave to only allow it when a single
>     managed interface is active
>
>  2) disable PS when the maximum networking latency
>     applications are are willing to put up with is
>     smaller than the beacon interval -- in that case
>     we cannot allow the AP to buffer frames

No problem with these.

>  3) enable powersave by default
>
> The last part might be controversial?

I think this a bad idea. For normal users we should not enable powersave
by default, at least not yet. I believe that there would be so much
problems that we would have to revert the change eventually.

> Should we have a default setting for the dynamic PS
> timeout?

Yes. Having timeout zero makes no sense in normal laptop use.

> Oh also -- below is a small program to play with the
> pm_qos framework, feel free to rip it for anything.

Thanks, this is useful.

-- 
Kalle Valo
