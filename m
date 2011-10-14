Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62767 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1JNJyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 05:54:52 -0400
Received: by iaek3 with SMTP id k3so2391781iae.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 02:54:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318433496.3933.44.camel@jlt3.sipsolutions.net>
References: <1317543352-29019-1-git-send-email-eliad@wizery.com>
	<1318433496.3933.44.camel@jlt3.sipsolutions.net>
Date: Fri, 14 Oct 2011 11:54:51 +0200
Message-ID: <CAB3XZEe2ZjJk97N13gNTmtBpKDNJ2WPEpG7H-RssC1f9SOxNJQ@mail.gmail.com> (sfid-20111014_115456_799195_9425F08A)
Subject: Re: [PATCH v2] mac80211: pass vif param to conf_tx() callback
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 12, 2011 at 5:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2011-10-02 at 10:15 +0200, Eliad Peller wrote:
>> tx params should be configured per interface.
>> add ieee80211_vif param to the conf_tx callback,
>> and change all the drivers that use this callback.
>
> For the record, I said this to you on IRC but you weren't around I
> guess. This patch (with the other ones) is now passing a bogus sdata/vif
> pointer to drivers -- e.g. for monitor mode interfaces from
> ieee80211_do_open -> ieee80211_set_wmm_default -> drv_conf_tx.
>
> I suspect the way to fix this would be to move the call to
> ieee80211_set_wmm_default into the last switch statement in do_open,
> could you please look into it?
>
thanks for the info.
i'll look into it.

Eliad.
