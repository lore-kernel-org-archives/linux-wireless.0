Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60857 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1KXQwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 11:52:37 -0500
Received: by ywa9 with SMTP id 9so401847ywa.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 08:52:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VoPFkTs1xugqCO20bj2j5zbAGWbUeTT5PX4JDOAtXtbA@mail.gmail.com>
References: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1322062858-15276-3-git-send-email-mcgrof@qca.qualcomm.com>
 <1322153083.5366.26.camel@jlt3.sipsolutions.net> <CAB=NE6VoPFkTs1xugqCO20bj2j5zbAGWbUeTT5PX4JDOAtXtbA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 24 Nov 2011 11:52:16 -0500
Message-ID: <CAB=NE6WhGj048g0+kL0FQmDe=fORoyvCjaNQd+iGgEnApedeCw@mail.gmail.com> (sfid-20111124_175240_664966_CD381341)
Subject: Re: [RFC 2/5] cfg80211: add support to immediately apply reg settings
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 24, 2011 at 11:50 AM, Luis R. Rodriguez
<mcgrof@frijolero.org> wrote:
> On Thu, Nov 24, 2011 at 11:44 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2011-11-23 at 10:40 -0500, Luis R. Rodriguez wrote:
>>> It is useful to apply reguatory settings immediately. We already
>>> handle applying regulatory hints immediatey for most hints but
>>> for user hints and country IE hints we want to kick hardware
>>> immediately to make these changes take effect. This adds supports
>>> to let us kick hardware to make the changes take effect as soon
>>> as possible.
>>
>> Can't say I like this -- wouldn't we rather call the regulatory update
>> callback or so?
>
> I'm not a fan either, at first I considered doing that on the
> reg_notifier() but then that also means every driver must implement a
> reg_notifier() callback, or a new reg_apply() callback. If we do it
> within cfg80211 it means all drivers get this for free and that was
> the tradeoff I wanted to review through these RFCs. Unfortunately
> setting the tx power was the only thing I saw cfg80211 could do right
> now.
>
> I'm still "meh" about this too.

I'm willing to give up on the complexity of this given that we *will*
eventually apply the settings after a scan, etc. The gains seem to be
small for what we would need to do. If we're happy to live without the
optimization I can just document it to ensure everyone knows that the
power stuff won't apply *immediately* but it will happen eventually
and typically this is soon enough.

  Luis
