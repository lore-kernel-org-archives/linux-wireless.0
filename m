Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:62685 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZHIEz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 00:55:56 -0400
Received: by an-out-0708.google.com with SMTP id d40so2485806and.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 21:55:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249722543.31670.19.camel@johannes.local>
References: <1249702711-32737-1-git-send-email-javier@cozybit.com>
	 <1249722543.31670.19.camel@johannes.local>
Date: Sat, 8 Aug 2009 21:55:56 -0700
Message-ID: <445f43ac0908082155n7cdde6e2p7656177fc2952be@mail.gmail.com>
Subject: Re: Mesh fixes and improvements
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, andrey@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Thanks for the review.

On Sat, Aug 8, 2009 at 2:09 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
>> This series includes some fixes, testing aids and improvements to the mesh
>> stack.  It is important to note that the patch
>> "Use-3-address-format-for-mesh-broadcast-frames" breaks compatibility with
>> previous versions.  This is unavoidable and will keep happening as new versions
>> of the 802.11s drafts are produced.
>
> That's ok, can you update the Kconfig though to indicate which draft
> it's compatible with? It says 1.08 right now.

Unfortunately I don't think it is fully compatible to one particular
version.  Furthermore, compliance with a Draft is not really
achievable:  a vast number of identifiers (reason codes, element ids,
status codes, ...) are not defined until the standard is ratified.

This particular change to the broadcast frame format was introduced
between D2.03 and D2.08.  Without it mesh networks will badly interact
with widely deployed lazy WDS APs.  It is not purely an
interoperability issue with other mesh implementations but a
requirement to achieve harmonious coexistence with deployed systems.
I don't think we should hold this change back until closer compliance
to a given draft version is implemented.

I'll still be happy to change the Kconfig, but bumping the version
number to, say D2.08, might be misleading.  I guess we should be more
verbose in the Kconfig description.

>> Also, I'm not sure if "Simulate-transmission-losses-on-plinks-to-..." should be
>> merged upstream, but we find it really useful to test mesh configurations.
>> Please comment if you have different opinions on its adequacy or
>> implementation.
>
> As I said elsewhere in this thread I don't think that should be in,
> especially not, as Kalle points out, using nl80211.

Understood.  I'll withdraw that patch and regenerate the series...

> All the other patches look ok on a cursory look, I just wish you'd write
> more detailed changelog entries.

... with more changelogs.

Cheers,

Javier
