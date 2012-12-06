Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43337 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2LFXzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 18:55:38 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so15097lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 15:55:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-4-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-4-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 15:55:16 -0800
Message-ID: <CAB=NE6V-Szo6SSHdTBA3Ww+=W24avx1AFuu_-m97xSyo8uQ3mg@mail.gmail.com> (sfid-20121207_005542_272142_8B9BD045)
Subject: Re: [PATCH 03/24] regulatory: clean up regdom_intersect
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> As the dummy_rule (also renamed from irule) is only
> used for output by the reg_rules_intersect() function
> there's no need to clear it at all, remove that.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

The removal of the pointer is fine but the removal of the memset() is
not trivial but given that reg_rules_intersect() does indeed re-set
all elements of the struct this works OK. If reg_rules_intersect()
ever branches though we may need to re-add a memset() back, but its
fine like this. The issue I was trying to avoid was if you do not
memset you potentially piggy backed data set from the previous
intersect and this could potentially reduce the number of possible
valid rules.

  Luis
