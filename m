Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44147 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaKPLHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2014 06:07:06 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so60370wiv.14
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2014 03:07:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141113231323.GG24486@wotan.suse.de>
References: <1415895219-19848-1-git-send-email-arik@wizery.com>
 <1415895219-19848-4-git-send-email-arik@wizery.com> <20141113231323.GG24486@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 16 Nov 2014 13:06:49 +0200
Message-ID: <CA+XVXfeqfHHDh6AcgkuBW9BwUo-s77+pnbDtP_y=e0dZQVBitg@mail.gmail.com> (sfid-20141116_120711_380898_244AC3F5)
Subject: Re: [PATCH v2 4/4] cfg80211: Allow usermode to query wiphy specific
 regd info
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2014 at 1:13 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Nov 13, 2014 at 06:13:39PM +0200, Arik Nemtsov wrote:
>> From: Jonathan Doron <jond@wizery.com>
>>
>> Allow usermode to query wiphy-specific regd info, for drivers that use
>> wiphy-specific regulatory management.
>>
>> Use the existing API for sending regdomain info to usermode, but return
>> the wiphy-specific regd in case wiphy index is provided and the driver
>> employs wiphy-specific management. This implies user and kernel-mode
>> support for the feature and is backward compatible.
>
> This patch does not address my feedback about making this generic
> to any wiphy->regd.

Copy-pasting my previous reply:

Well always sending wiphy->regd whenever it is set is easy, but it
might be problematic I guess:

We intend to add a patch to wpa_s to always add the wiphy_idx to
NL80211_CMD_GET_REG. With the current approach only drivers with
SELF_MANAGED_REG will get wiphy->regd back. This is ok since these are
new drivers, which are familiar with this API.

But if we use your suggestion and always return wiphy->regd, then some
driver like ath9k that uses regulatory_hint() will now get it's
private regd returned to the wpa_s that manages it. I'm not saying
it's necessarily bad, but it's different than what was returned
before. The cfg80211 regdomain is intersected with wiphy->regd, so now
ath9k will start getting more permissive channels in usermode.

So we thought it's best to enable the new behavior only if the driver
explicitly wants it, using a new regulatory flag.

Arik
