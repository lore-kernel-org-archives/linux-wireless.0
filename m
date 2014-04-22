Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:61782 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaDVC6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 22:58:54 -0400
Received: by mail-la0-f48.google.com with SMTP id gf5so3752448lab.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 19:58:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397646587-11078-1-git-send-email-arik@wizery.com>
References: <1397646587-11078-1-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 21 Apr 2014 19:58:32 -0700
Message-ID: <CAB=NE6UMho_LOMu1oQEjm5QFKU7T-bQdQCEMAtZ3_vJoQMEcpg@mail.gmail.com> (sfid-20140422_045904_184677_D803E92A)
Subject: Re: [PATCH] cfg80211: avoid freeing last_request while in flight
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Colleen T <colleen@cozybit.com>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 16, 2014 at 4:09 AM, Arik Nemtsov <arik@wizery.com> wrote:
> Avoid freeing the last request while it is being processed. This can
> happen in some cases if reg_work is kicked for some reason while the
> currently pending request is in flight.
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> This is to be applied on top of
> "cfg80211: fix processing world regdomain when non modular"

Thanks for help on this Arik, in this case we actually want to apply
this *before* the other regdomain patch, as such I'll address that and
resend your patch before mine, it requires just a minor change.

  Luis
