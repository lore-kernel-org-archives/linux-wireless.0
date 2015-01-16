Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47856 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbAPNAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 08:00:02 -0500
Received: by mail-ie0-f174.google.com with SMTP id at20so20516069iec.5
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 05:00:02 -0800 (PST)
Date: Fri, 16 Jan 2015 07:59:57 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mesh: Skip STA expiration on user_mpm mode
Message-ID: <20150116125957.GA10300@localhost> (sfid-20150116_140007_270816_50B0E806)
References: <1421202189-4020-1-git-send-email-masashi.honma@gmail.com>
 <CAEKwDSDPTiZH1NO8Hi-bdPp=25yARr1iUFK7ntnnS6Ae05ULaA@mail.gmail.com>
 <CAFk-A4ko5S_+SFNk8RWvrWJ9k-kEQnqKCEKrTZs0GrZ9QScMJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFk-A4ko5S_+SFNk8RWvrWJ9k-kEQnqKCEKrTZs0GrZ9QScMJA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2015 at 11:04:30AM +0900, Masashi Honma wrote:
> 2015-01-15 12:14 GMT+09:00 Bob Copeland <me@bobcopeland.com>:
> > I took a look at what authsae is doing, and it looks like it's just
> > prepared to handle the NL80211_CMD_DEL_STATION events generated from
> > cfg80211_del_sta() -- is there a reason that couldn't work for wpa_s
> > too?  Then you'd only need the patch to configure that timeout on the
> > client, and you can simplify it by not caring about user_mpm.
> 
> Thank you for your review.
> 
> Indeed wpa_supplicant do nothing even if it receivced NL80211_CMD_DEL_STATION.
> But the mismatch (wpa_supplicant recognizes STA is alive, mac80211
> recognizes STA leaved) is not so good.

Right - so wpa_s could be changed to handle this event (for mesh),
I think.

> Anyway I have not considered authsae user land application.
> Does authsae have it's own inactivity timer ?
> If not, I will drop this patch.

No, it relies on mac80211's inactivity timer.  So, yeah, I think this
patch would break authsae, in the sense that stations would never
get removed.

-- 
Bob Copeland %% http://bobcopeland.com/
