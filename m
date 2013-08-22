Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42317 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3HVVh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 17:37:56 -0400
Received: by mail-oa0-f46.google.com with SMTP id j10so4684296oah.33
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2013 14:37:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377117341-9327-1-git-send-email-johannes@sipsolutions.net>
References: <1377117341-9327-1-git-send-email-johannes@sipsolutions.net>
Date: Fri, 23 Aug 2013 00:37:55 +0300
Message-ID: <CAB3XZEexJ28291uKi=0tPvsORHQinbc272KRe2m=Zr6_CV3vFA@mail.gmail.com> (sfid-20130822_233759_180851_616BCAE5)
Subject: Re: [RFC] mac80211: fix locking with ieee80211_resume_disconnect()
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 21, 2013 at 11:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> If it is needed to disconnect multiple virtual interfaces after
> (WoWLAN-) suspend, the most obvious approach would be to iterate
> all interfaces by calling ieee80211_iterate_active_interfaces()
> and then call ieee80211_resume_disconnect() for each one. This
> is what the iwlmvm driver does.
>
> Unfortunately, this causes a locking dependency from mac80211's
> iflist_mtx to the key_mtx. This is problematic as the former is
> intentionally never held while calling any driver operation to
> allow drivers to iterate with their own locks held. The key_mtx
> is held while installing a key into the driver though, so this
> new lock dependency means drivers implementing the logic above
> can no longer hold their own lock while iterating.
>
> To fix this, modify the ieee80211_resume_disconnect() API to do
> the iteration in there (using RCU) while holding the key_mtx so
> there's no new lock dependency, and let the driver device which
> interface should be disconnected by passing a decision function
> that returns true/false.
>
can't you simply add a new rtnl-locked interface iterator?

Eliad.
