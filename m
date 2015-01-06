Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64662 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbbAFOFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 09:05:04 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so5407361wiw.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 06:05:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420552744.1966.31.camel@sipsolutions.net>
References: <1420112563-3981-1-git-send-email-arik@wizery.com>
 <1420112563-3981-2-git-send-email-arik@wizery.com> <1420541766.1966.18.camel@sipsolutions.net>
 <1420552744.1966.31.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 6 Jan 2015 16:04:47 +0200
Message-ID: <CA+XVXfcAW19fzEpAV8R=hDbBdXEgJmrT8m4mqFg8tUhdx1XvKQ@mail.gmail.com> (sfid-20150106_150510_381710_0C6B011B)
Subject: Re: [PATCH 2/2] cfg80211: avoid reg-hints in self-managed only systems
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2015 at 3:59 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2015-01-06 at 11:56 +0100, Johannes Berg wrote:
>> On Thu, 2015-01-01 at 13:42 +0200, Arik Nemtsov wrote:
>> > When a system contains only self-managed regulatory devices all hints
>> > from the regulatory core are ignored. Stop hint processing early in this
>> > case. These systems usually don't have CRDA deployed, which results in
>> > endless (irrelevent) logs of the form:
>> > cfg80211: Calling CRDA to update world regulatory domain
>>
>> Applied.
>
> I take that back - dropped again. This was causing spurious messages in
> the hwsim test run VM, saying something like "couldn't set reg domain:
> -7". Maybe at that point not a single wiphy existed?

Interesting. I guess I should fix this to only drop the request in
case there's at least one self-managed wiphy.

Arik
