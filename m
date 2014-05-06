Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63678 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbaEFMtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 08:49:32 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so2744995wgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2014 05:49:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399373244.4218.21.camel@jlt4.sipsolutions.net>
References: <1399038031-23206-1-git-send-email-luca@coelho.fi>
	<1399373244.4218.21.camel@jlt4.sipsolutions.net>
Date: Tue, 6 May 2014 14:49:30 +0200
Message-ID: <CA+BoTQmQ-2MeWO3FkKPxo3XyUjQ4X2LAA2uOuYLzASRydF6+LQ@mail.gmail.com> (sfid-20140506_144936_577828_9A272E8E)
Subject: Re: [PATCH 1/4] cfg80211/nl80211: add channel switch started and
 failed notifications
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ilan Peer <ilan.peer@intel.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 May 2014 12:47, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-05-02 at 16:40 +0300, Luca Coelho wrote:
>
>> + * @NL80211_CMD_CH_SWITCH_STARTED_NOTIFY: Notify that a channel switch
>> + *   has been started on an interface, regardless of the initiator
>> + *   (ie. whether it was requested from a remote device or
>> + *   initiated on our own).  It indicates that
>> + *   %NL80211_ATTR_IFINDEX will be on %NL80211_ATTR_WIPHY_FREQ
>> + *   after %NL80211_ATTR_CH_SWITCH_COUNT TBTT's.
>
> You don't seem to have that now, but it may not always be needed, and we
> could add it later (unless userspace needs to rely on having the
> attribute - otherwise it has to check for it)
>
> Actually though, maybe you do need it, so that you can determine whether
> it makes sense to try anything smart - if the count is 1 or you received
> an action frame then you probably don't have time at all?
>
>> + * @NL80211_CMD_CH_SWITCH_FAILED_NOTIFY: Notify that a channel switch
>> + *   has failed on %NL80211_ATTR_IFINDEX.  This notification can
>> + *   only be sent after a @NL80211_CMD_CH_SWITCH_STARTED_NOTIFY has
>> + *   been issued.
>
> (+Ilan, Andrei)
>
> I'm not really sure why you have this - it seems that in this case the
> interface will be stopped so you'll get a STOP_AP or DISCONNECT or
> whatever other notification. This may not actually be completely true
> right now (I seem to remember a fix in this area but can't seem to find
> it in my tree!!) but we'll have to fix that part anyway. Not really sure
> why then that couldn't be used instead of this notification? The
> userspace code is going to have to worry about that anyway, I'd think.

Just a reminder - there's my pending patchset (mac80211/cfg80211: CSA
fixes/cleanups) for CSA that disconnects interfaces that fail to
switch channel. Perhaps I should re-post?


Michał
