Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:45164 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbAGNps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:45:48 -0500
Received: by mail-we0-f181.google.com with SMTP id q58so1205522wes.12
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 05:45:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcAW19fzEpAV8R=hDbBdXEgJmrT8m4mqFg8tUhdx1XvKQ@mail.gmail.com>
References: <1420112563-3981-1-git-send-email-arik@wizery.com>
 <1420112563-3981-2-git-send-email-arik@wizery.com> <1420541766.1966.18.camel@sipsolutions.net>
 <1420552744.1966.31.camel@sipsolutions.net> <CA+XVXfcAW19fzEpAV8R=hDbBdXEgJmrT8m4mqFg8tUhdx1XvKQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 7 Jan 2015 15:38:33 +0200
Message-ID: <CA+XVXfdKq1tUoUrbH+9BE=LX_Nf+tNNeoHLYMa4NfX41cMoysg@mail.gmail.com> (sfid-20150107_144551_960893_17B6D10F)
Subject: Re: [PATCH 2/2] cfg80211: avoid reg-hints in self-managed only systems
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2015 at 4:04 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Tue, Jan 6, 2015 at 3:59 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Tue, 2015-01-06 at 11:56 +0100, Johannes Berg wrote:
>>> On Thu, 2015-01-01 at 13:42 +0200, Arik Nemtsov wrote:
>>> > When a system contains only self-managed regulatory devices all hints
>>> > from the regulatory core are ignored. Stop hint processing early in this
>>> > case. These systems usually don't have CRDA deployed, which results in
>>> > endless (irrelevent) logs of the form:
>>> > cfg80211: Calling CRDA to update world regulatory domain
>>>
>>> Applied.
>>
>> I take that back - dropped again. This was causing spurious messages in
>> the hwsim test run VM, saying something like "couldn't set reg domain:
>> -7". Maybe at that point not a single wiphy existed?
>
> Interesting. I guess I should fix this to only drop the request in
> case there's at least one self-managed wiphy.

Could you point me to the hwsim test that failed for you?
Also where is that message coming from? I don't see it in wpa_s or the kernel.

Arik
