Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:33168 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZIGXHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 19:07:53 -0400
Received: by vws33 with SMTP id 33so1950096vws.33
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 16:07:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909071523q2994b123i15eb1b6991dc073a@mail.gmail.com>
References: <20090907124548.GA5351@hash.localnet>
	 <43e72e890909071522i461ca821m703f6e2eeb2d0385@mail.gmail.com>
	 <43e72e890909071523q2994b123i15eb1b6991dc073a@mail.gmail.com>
Date: Mon, 7 Sep 2009 19:07:55 -0400
Message-ID: <b6c5339f0909071607l6b759e74g4636de1ac9f5957a@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH/RFC] ath5k: clear rx queue on reset
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Matt Smith <Matt.Smith@atheros.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 7, 2009 at 6:23 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> On Mon, Sep 7, 2009 at 3:22 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
>> Cc'ing Matt just for his information.
>>
>> I'd really rather we try to keep the frames instead of dropping them
>> and since the number of frames on the wrong channel are scarce it
>> seems better to drop just those frames instead of all pending frames
>> for now.

Ok, sounds like a better plan.  In fact we could keep and report those
frames with a base rate (we do that now) but one problem with that is we
might think we got a beacon on a channel that we really didn't, and
that could confuse the regulatory system.

-- 
Bob Copeland %% www.bobcopeland.com
