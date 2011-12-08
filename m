Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56053 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1LHJid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 04:38:33 -0500
Received: by ghbz2 with SMTP id z2so1350205ghb.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 01:38:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323336302.3332.7.camel@jlt3.sipsolutions.net>
References: <1323336114-31203-1-git-send-email-helmut.schaa@googlemail.com>
	<1323336302.3332.7.camel@jlt3.sipsolutions.net>
Date: Thu, 8 Dec 2011 10:38:32 +0100
Message-ID: <CAGXE3d_Cytq=a--29KN8K5NGi=zw1ywhUV=hDqYioWbvt5Uo4A@mail.gmail.com> (sfid-20111208_103841_450629_55223FA7)
Subject: Re: [PATCH 1/2] ieee80211: Introduce ieee80211_has_frags
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 8, 2011 at 10:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> +{
>> +     return (seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)) != 0;
>> +}
>> +
>
> Maybe you should move that close to ieee80211_has_morefrags() so it's
> easy to tell the difference? :-) (that doesn't use bool either, heh)

Since all ieee80211_is/has_* functions use int already I took the same
approach.

And ieee80211_has_morefrags operates on the frame control while
this operates on seq_ctrl. Hence, I placed it at the end but if you prefer
to have it closer to ieee80211_has_morefrags I can do that too :)

Helmut
