Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:38063 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaBVAXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 19:23:20 -0500
Received: by mail-la0-f41.google.com with SMTP id mc6so3034899lab.28
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 16:23:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392364441-4640-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1392364441-4640-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 16:22:59 -0800
Message-ID: <CAB=NE6WAKJjG4V9+4un-epa6-=w6pXyn+KiqXA01vATjExqSXA@mail.gmail.com> (sfid-20140222_012323_425457_2D040663)
Subject: Re: [PATCH 1/2] cfg80211: regulatory, reset regdomain in case of error
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 13, 2014 at 11:54 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Reset regdomain to world regdomain in case
> of errors in set_regdom() function.
>
> This will fix a problem with such scenario:
> - iw reg set US
> - iw reg set 00
> - iw reg set US
> The last step always fail and we get deadlock
> in kernel regulatory code. Next setting new
> regulatory wasn't possible due to:
>
> Pending regulatory request, waiting for it to be processed...
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
