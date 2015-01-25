Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:41818 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbbAYK74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 05:59:56 -0500
Received: by mail-la0-f53.google.com with SMTP id gq15so3811105lab.12
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 02:59:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422009931-4379-1-git-send-email-johannes@sipsolutions.net>
References: <1422009931-4379-1-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 25 Jan 2015 12:59:39 +0200
Message-ID: <CA+XVXffaDtG7Lr8H9Tie4Z7bavCHOV3JfDHdRND-YpbES_vDNw@mail.gmail.com> (sfid-20150125_115959_318261_5AF48574)
Subject: Re: [PATCH] mac80211: tdls: disentangle HT supported conditions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2015 at 12:45 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> These conditions are rather difficult to follow, for example
> because "!sta" only exists to not crash in the case that we
> don't have a station pointer (WLAN_TDLS_SETUP_REQUEST) in
> which the additional condition (peer supports HT) doesn't
> actually matter anyway.
>
> Cleaning this up only duplicates two lines of code but makes
> the rest far easier to read, so do that.
>
> As a side effect, smatch stops complaining about the lack of
> a sta pointer test after the !sta (since the !sta goes away)
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Reviewed-by: Arik Nemtsov <arik@wizery.com>

Arik
