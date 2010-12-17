Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:34739 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab0LQTlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 14:41:15 -0500
Received: by iwn42 with SMTP id 42so508820iwn.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 11:41:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292579457.3715.2.camel@jlt3.sipsolutions.net>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
 <1292556197-4820-4-git-send-email-lrodriguez@atheros.com> <1292579457.3715.2.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 17 Dec 2010 11:40:54 -0800
Message-ID: <AANLkTimseBRXix3sFsHnCVBjZh6=Jfum8MGUqq1Uf6z0@mail.gmail.com>
Subject: Re: [RFC 3/8] cfg80211: pass DFS region to drivers through reg_notifier()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 1:50 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-12-16 at 19:23 -0800, Luis R. Rodriguez wrote:
>
>>       /* Lets us get back the wiphy on the callback */
>>       int (*reg_notifier)(struct wiphy *wiphy,
>> -                         struct regulatory_request *request);
>> +                         struct regulatory_request *request,
>> +                         u8 dfs_region);
>
> So does that mean we need to implement a reg_notifier if we want to have
> radar detection? Doesn't an empty reg_notifier already alter behaviour

An empty reg_notifier() should not do anything. Its either through the
reg_notifier() or we add a new callback specifically for DFS. A new
callback may give more flexibility later if we want to pass up more
data.

  Luis
