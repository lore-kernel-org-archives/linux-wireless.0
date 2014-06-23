Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43138 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaFWRO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 13:14:59 -0400
Received: by mail-pb0-f47.google.com with SMTP id up15so6089888pbc.20
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 10:14:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XTgcMWNHppF7WgZjqGCyaZSOJLF4FUC1hwVyyaBrJ79g@mail.gmail.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-4-git-send-email-arik@wizery.com> <CAB=NE6XTgcMWNHppF7WgZjqGCyaZSOJLF4FUC1hwVyyaBrJ79g@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 23 Jun 2014 20:14:43 +0300
Message-ID: <CA+XVXfedV=Frh8UmAzRfgPbOw8nq1Aa-Yr7QSgZTKe8h=bh78Q@mail.gmail.com> (sfid-20140623_191503_088815_043C1A1A)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2014 at 2:34 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> Allow driver and user hints to set the "world" regulatory domain,
>
> NACK - as expressed in the other patch, letting the drivers to use the
> new API to set the world regulatory domain doesn't make sense as we
> have custom apply stuff, and the world regulatory domain is not
> something dynamic.

Well we want to set the world regdomain from FW. This obviously
happens after wiphy registration, so I don't think the custom apply
can be used here? (since we generally want cfg80211 to own the
regdomain settings).

Arik
