Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45777 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaKEJNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 04:13:07 -0500
Received: by mail-wi0-f172.google.com with SMTP id bs8so11742482wib.11
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 01:13:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WLnVcBtC5_HyVuDXJnrCUfhUKsPN_rAHL6VYEfek1TMA@mail.gmail.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
 <1414046257-22184-6-git-send-email-arik@wizery.com> <CAB=NE6WLnVcBtC5_HyVuDXJnrCUfhUKsPN_rAHL6VYEfek1TMA@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 5 Nov 2014 11:12:50 +0200
Message-ID: <CA+XVXfcMhrHUhg4yj_dOf97XWu_HyvdQ-LqF4KbjXL4ewGn5PQ@mail.gmail.com> (sfid-20141105_101312_159450_C810F11F)
Subject: Re: [PATCH 5/5] cfg80211: Allow usermode to query wiphy specific regd info
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2014 at 5:23 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Wed, Oct 22, 2014 at 11:37 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> + * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating the
>> + *     regulatory information came from the driver and not from the global
>> + *     cfg80211 regulatory domain information.
>
> Awesome, can you also add another entry for those drivers that use
> regulatory_hint() API given that the wiphy->regd will be set and then
> that is a custom regdomain which I do think would be great to query as
> well.

Just to be sure we're on the same page.
1. You're asking for an attribute to be automatically sent to
userspace whenever someone registers with REGULATORY_CUSTOM_REG.
2. And then if userspace sends a wiphy idx to the NL80211_CMD_GET_REG,
we'll return wiphy->regd for that case as well?

Arik
