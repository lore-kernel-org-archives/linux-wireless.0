Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:45267 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2LGAQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 19:16:52 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5740734lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 16:16:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-9-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-9-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 16:16:31 -0800
Message-ID: <CAB=NE6UGrFhSFW_K_928py+n9Qf1VQQ52_2viGOWz3J+k5-U2Q@mail.gmail.com> (sfid-20121207_011657_109966_840450CA)
Subject: Re: [PATCH 08/24] regulatory: remove useless locking on exit
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> It would be a major problem if anything were to run
> concurrently while the module is being unloaded so
> remove the locking that doesn't help anything.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

This seems to work well because we do the cancel_work_sync() and
cancel_delayed_work_sync() before, so sure, and given you know the
core better I'm for it.

  Luis
