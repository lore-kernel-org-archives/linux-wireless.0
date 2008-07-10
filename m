Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:34201 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbYGJKpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 06:45:31 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1550391ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2008 03:45:23 -0700 (PDT)
Message-ID: <1ba2fa240807100345n15c5ff84mb47267fe547a545@mail.gmail.com> (sfid-20080710_124543_494723_DC0D875F)
Date: Thu, 10 Jul 2008 13:45:23 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: sparse warnings on iwlwifi
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215681008.3932.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215681008.3932.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 12:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Was just running sparse for something unrelated and noticed these:
>
> drivers/net/wireless/iwlwifi/iwl-rx.c:832:2: warning: cast truncates bits from constant value (1c00 becomes 0)
> drivers/net/wireless/iwlwifi/iwl-rx.c:836:2: warning: cast truncates bits from constant value (6f080000 becomes 0)
> drivers/net/wireless/iwlwifi/iwl-rx.c:836:2: warning: cast truncates bits from constant value (6f080000 becomes 0)
> drivers/net/wireless/iwlwifi/iwl-rx.c:856:3: warning: cast truncates bits from constant value (4001 becomes 1)
> drivers/net/wireless/iwlwifi/iwl-rx.c:860:3: warning: cast truncates bits from constant value (a000 becomes 0)
> drivers/net/wireless/iwlwifi/iwl-rx.c:864:3: warning: cast truncates bits from constant value (c000 becomes 0)

Yeah I've actually wanted to ask someone how to solve. This comes from
radio tap code, frankly currently very low priority on my list.
Not sure why but only calling directly to put_unalinged_le32 fixes
this warning. In general put_unaligned should be expanded to this
macro.
I will submit patch that solves this.
Thanks
Tomas
