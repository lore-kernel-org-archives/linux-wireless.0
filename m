Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:54993 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965458AbXDLIXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 04:23:23 -0400
Received: by an-out-0708.google.com with SMTP id b33so489654ana
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2007 01:23:22 -0700 (PDT)
Message-ID: <a32f33a40704120123i81624c8q90b49a85b8dfc2c4@mail.gmail.com>
Date: Thu, 12 Apr 2007 10:23:22 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: rt61: Kernel bug in ieee80211.c:4920
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1176341585.21564.30.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1176341585.21564.30.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> This is net/mac80211/ieee80211.c, line 4920:
>
> BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
>
> Apparently rt61 calls ieee80211_unregister_hw() even though it never
> called ieee80211_register_hw() due to the failure to load the firmware.
>
> Either mac80211 should be more tolerant, or rt61 should keep track of
> what it has registered.  I'm unsure which is better, hence no patch
> attached ;)

mac80211 is tolerant enough, the bug in in rt61.
fortunately the rt2x00 git tree already contains a fix for this issue
(applied yesterday),
so it will be part of the next pull request.

Ivo
