Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56155 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2FZKJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 06:09:53 -0400
Received: by obbuo13 with SMTP id uo13so7813708obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 03:09:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
Date: Tue, 26 Jun 2012 13:09:53 +0300
Message-ID: <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com> (sfid-20120626_120957_002713_4AE7C6BB)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 25, 2012 at 7:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi all,
>
> Some of us have discussed this before, but I wanted to get some wider
> dissemination ...
>
> With multi-channel, one problem that we get is managing the channel
> timing for authentication/association. We'll have bound the channel
> context (once we have that) before we even send a frame of course, but
> setting up the timing as to when to use the channel is very hard, in
> particular for connections to P2P GOs that might potentially be asleep.
>
the other scenario we should have in mind here is the AP side - making
sure we'll be able to auth/assoc a new station.

> 5) do remain-on-channel from mac80211, but this doesn't address P2P GO
>   synchronisation requirements
>
what are the unfulfilled requirements here?

> I haven't been able to come up with any other ways, and here we really
> don't have much of a choice -- #1 is the only thing that seems sane to
> me. Thoughts?

our current approach is making the kernel part as simple as possible,
and let userspace handle the channel management.
before authentication (or after getting auth request in the ap case)
the supplicant requests the kernel to "give priority" to a specific
vif. it's up to the low-level driver to decide on the right way to do
it (internally we implement it with ROC on the specified vif).

the con here is that this might result in the channel being reserved
for a pretty long time (retransmits, etc.), but that's why we refer it
as setting "priority" rather than actual channel reservation. if the
fw has to do other things (e.g. beacon on each beacon interval) it
will do it, even though we asked it to ROC on a different channel.

i think the "tx sync" (method 1) is good for sta mode, but it's less
suitable for ap mode.
also, when waiting for EAPOLs after association you might have to
reserve the channel for a pretty long time anyway (since you still
can't enter ps, and some APs don't send the first EAPOL immediately).

Eliad.
