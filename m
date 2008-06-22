Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:9912 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYFVPEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 11:04:15 -0400
Received: by an-out-0708.google.com with SMTP id d40so493952and.103
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 08:04:14 -0700 (PDT)
Message-ID: <43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com> (sfid-20080622_170420_352659_95C30F7B)
Date: Sun, 22 Jun 2008 20:34:10 +0530
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: RFC: always enable MAC80211_RC_PID?
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080622125553.GB22539@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080622125553.GB22539@cs181133002.pp.htv.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 22, 2008 at 6:25 PM, Adrian Bunk <bunk@stusta.de> wrote:
> After the scheduled removal of MAC80211_RC_SIMPLE only
> MAC80211_RC_DEFAULT_PID and MAC80211_RC_DEFAULT_NONE are
> left as choices.
>
> Does MAC80211_RC_DEFAULT_NONE have any userbase serious enough to
> justify all the constructs made for this case or could we simply
> always enable MAC80211_RC_PID?

You can currently only get away living without it if you are just
using iwl3945 or iwl4965 as they provide their own rate control
algorithms. In the future if other vendor drivers are added with their
own rate control algorithm this list grows. Disabling PID will save
you some space only on some embedded platforms. Although currently its
not evident people would do this I do see this being a reasonable
option to keep around for later.

  Luis
