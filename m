Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:45105 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbbAPCEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 21:04:31 -0500
Received: by mail-ig0-f175.google.com with SMTP id r2so1233583igi.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2015 18:04:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEKwDSDPTiZH1NO8Hi-bdPp=25yARr1iUFK7ntnnS6Ae05ULaA@mail.gmail.com>
References: <1421202189-4020-1-git-send-email-masashi.honma@gmail.com>
	<CAEKwDSDPTiZH1NO8Hi-bdPp=25yARr1iUFK7ntnnS6Ae05ULaA@mail.gmail.com>
Date: Fri, 16 Jan 2015 11:04:30 +0900
Message-ID: <CAFk-A4ko5S_+SFNk8RWvrWJ9k-kEQnqKCEKrTZs0GrZ9QScMJA@mail.gmail.com> (sfid-20150116_030440_427840_863EF931)
Subject: Re: [PATCH] mesh: Skip STA expiration on user_mpm mode
From: Masashi Honma <masashi.honma@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-15 12:14 GMT+09:00 Bob Copeland <me@bobcopeland.com>:
> I took a look at what authsae is doing, and it looks like it's just
> prepared to handle the NL80211_CMD_DEL_STATION events generated from
> cfg80211_del_sta() -- is there a reason that couldn't work for wpa_s
> too?  Then you'd only need the patch to configure that timeout on the
> client, and you can simplify it by not caring about user_mpm.

Thank you for your review.

Indeed wpa_supplicant do nothing even if it receivced NL80211_CMD_DEL_STATION.
But the mismatch (wpa_supplicant recognizes STA is alive, mac80211
recognizes STA leaved) is not so good.

Anyway I have not considered authsae user land application.
Does authsae have it's own inactivity timer ?
If not, I will drop this patch.
