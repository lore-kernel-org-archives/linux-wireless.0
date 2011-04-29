Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64768 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760875Ab1D2VJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 17:09:55 -0400
Received: by iwn34 with SMTP id 34so3369591iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 14:09:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=mJE+M79-XOJsTPRu1zGodiiZ8bg@mail.gmail.com>
References: <1303849311-8817-1-git-send-email-arik@wizery.com> <BANLkTi=mJE+M79-XOJsTPRu1zGodiiZ8bg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sat, 30 Apr 2011 00:09:40 +0300
Message-ID: <BANLkTinnQgZGjZOigQuUSVD0kCBTuzUE1A@mail.gmail.com> (sfid-20110429_230959_115843_0A9E1E97)
Subject: Re: [PATCH v2] wl12xx: support FW TX inactivity triggers
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey John,

Looking at the latest git, it seems you've picked up this patch
(commit 47684808fd89d6809c0886e06f8ac324252499d8).
This is unfortunate, since there's currently a FW bug that will cause
many disconnections in STA mode with this patch.

How would we go about reverting this?

Thanks,
Arik

On Thu, Apr 28, 2011 at 11:18, Arik Nemtsov <arik@wizery.com> wrote:
> On Tue, Apr 26, 2011 at 23:21, Arik Nemtsov <arik@wizery.com> wrote:
>> In AP mode we register for the MAX_TX_RETRY and INACTIVE_STA events.
>> Both are reported to the upper layers as a TX failure in the offending
>> stations.
>>
>> In STA mode we register only for the MAX_TX_RETRY event. A TX failure is
>> interpreted as a loss of connection.
>>
>> Support for IEEE80211_HW_REPORTS_TX_ACK_STATUS has been removed to avoid
>> the inherent race condition of a mac80211 TX failure counter in addition
>> to the FW counter.
>>
>> This patch depends on "mac80211: allow low level driver to report packet
>> loss"
>>
>
> Luca please don't take this one for now. It appears the FW sometimes
> misfires the event in STA mode.
> We'll need some more debugging.
>
> Arik
>
