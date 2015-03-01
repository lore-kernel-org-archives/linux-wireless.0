Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:38718 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbCAIVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 03:21:37 -0500
Received: by labgf13 with SMTP id gf13so277637lab.5
        for <linux-wireless@vger.kernel.org>; Sun, 01 Mar 2015 00:21:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425041427.1960.1.camel@sipsolutions.net>
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
 <1424850911-21017-4-git-send-email-marek.puzyniak@tieto.com> <1425041427.1960.1.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 1 Mar 2015 10:21:20 +0200
Message-ID: <CA+XVXfchZ+L1iH47S=rM04vJbjBSKA4O8TYuhEkfZuLpNb9QDA@mail.gmail.com> (sfid-20150301_092141_377483_5A6D108A)
Subject: Re: [PATCH v2 3/4] mac80211: initialize rate control earlier for tdls station
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 27, 2015 at 2:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> +Arik.
>
> It'd be nice (for me anyway) if you didn't send this in a series of
> other patches I don't care about - I only ever saw this due to
> patchwork.
>
> On Wed, 2015-02-25 at 08:55 +0100, Marek Puzyniak wrote:
>> Currently when TDLS station in driver goes from assoc
>> to authorized state it can not use rate control parameters
>> because rate control is not initialized yet. Some drivers
>> require parameters already initialized by rate control when
>> entering authorized state. It can be done by initializing
>> rate control after station transition to authorized state
>> but before notifyiIEEE80211_STA_ASSOCng driver about that.
>
> Arik, you have a similar patch handling only NSS. Does this one look
> fine to you, and would it solve the problem your other patch solved?

Well currently iwlmvm requires the NSS to be set before
IEEE80211_STA_ASSOC (earlier), so this doesn't help directly.
I could change mvm a bit to make it work, but I don't really see a
good reason for it :)

The patch looks good. Shouldn't introduce new issues (at least for iwlwifi).

Arik
