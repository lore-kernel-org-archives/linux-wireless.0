Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:26787 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYJBMw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 08:52:59 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1127128rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 05:52:58 -0700 (PDT)
Message-ID: <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com> (sfid-20081002_145304_681834_A1D34082)
Date: Thu, 2 Oct 2008 08:52:58 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <87od23mo08.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200808101401.03339.toralf.foerster@gmx.de>
	 <b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com>
	 <200810012055.58085.toralf.foerster@gmx.de>
	 <87ej30m376.fsf@denkblock.local>
	 <b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com>
	 <87ljx8ndw1.fsf@denkblock.local>
	 <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com>
	 <87od23mo08.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 2, 2008 at 3:53 AM, Elias Oltmanns <eo@nebensachen.de> wrote:
>> Ah, yes, good analysis... and ath5k_init is scheduling the timer.  I
>> doubt ieee80211_opened would fly; probably the better thing to do is
>> ensure that the cleanup gets called regardless of whether ath5k_stop
>> gets called (it shouldn't matter since the irqs all get created in
>> _attach).
>
> Not sure I agree there. Why should calibration take place regularly even
> though the interface appears to be shut down from user-space's point of
> view? It simply doesn't make sense  to start the interface if nobody
> intends to use it.

Hmm, yeah, you're right.  So, I guess we can just do your patch except
with another status bit that says it's active instead of changing
mac80211 (b43 does something along those lines).

-- 
Bob Copeland %% www.bobcopeland.com
