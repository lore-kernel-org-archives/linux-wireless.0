Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:37846 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbXDNUAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 16:00:33 -0400
Received: by ug-out-1314.google.com with SMTP id 44so778875uga
        for <linux-wireless@vger.kernel.org>; Sat, 14 Apr 2007 13:00:32 -0700 (PDT)
Message-ID: <1ba2fa240704141300w2ec2beabm9cd1376c1b9ef2bb@mail.gmail.com>
Date: Sat, 14 Apr 2007 23:00:31 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/4] mac80211 and drivers: Improve wireless statistics
Cc: "John Linville" <linville@tuxdriver.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Michael Buesch" <mb@bu3sch.de>, bcm43xx-dev@berlios.de,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46211955.4080006@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <46211955.4080006@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those are really bad names.
__signal__ is not meaning a value __signal level__ or __signal
strength__ means value
__level__ is too general to describes anything
RSSI on other hand is well defined. Maybe it's too hw/vendor dependent
to use in stack
but at least its names says what it is.
Quality should be a relative number depends on maxim
I don't think this renaming make things clearer
Tomas

On 4/14/07, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In wireless statistics reporting, three quantities related to the signal are reported: "qual"
> (linear with the signal), "level" (logarithmic), and "noise". In mac80211 and the drivers that use
> it, the first two have a mixture of internal names for those quantities. To reduce confusion, this
> series of patches make the internal names match the entity that is being kept.
>
> So that any bisection of the source will always result in code that will compile, the patches are
> divided as follows:
>
> 1/4: The new names are added to the appropriate struct definitions in mac80211.
> 2/4: The mac80211 routines are modified to use the new names.
> 3/4: The drivers that use mac80211 are modified.
> 4/4: The old names are removed from the struct definitions.
>
> These changes assume the prior application of patches "[PATCH] mac80211: remove redundant rssi
> information in scan results" by Michael Wu and "[PATCH] mac80211: Report correct wireless
> statistics" by Larry Finger.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
