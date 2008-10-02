Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:42275 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYJBCEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 22:04:44 -0400
Received: by rv-out-0506.google.com with SMTP id k40so905818rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 19:04:43 -0700 (PDT)
Message-ID: <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com> (sfid-20081002_040447_401156_2CFC32E3)
Date: Wed, 1 Oct 2008 22:04:43 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <87ljx8ndw1.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200808101401.03339.toralf.foerster@gmx.de>
	 <b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com>
	 <200810012055.58085.toralf.foerster@gmx.de>
	 <87ej30m376.fsf@denkblock.local>
	 <b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com>
	 <87ljx8ndw1.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 1, 2008 at 6:34 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
> "Bob Copeland" <me@bobcopeland.com> wrote:
>> On Wed, Oct 1, 2008 at 5:10 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
> Oh, but it is cleaned up by ath5k_stop_hw(). The issue is a different
> one here:
>
> ath5k_init() == ->start()
> ath5k_stop_hw() == ->stop()
>
> Since the mac80211 layer never opened a device, it won't close it
> either. Thus, ath5k_stop_hw() does not get called on module unload. By
> calling ath5k_init() on resume, the driver has effectively started the
> device when it was not supposed to do so and this event is not being
> tracked by the higher layers.

Ah, yes, good analysis... and ath5k_init is scheduling the timer.  I
doubt ieee80211_opened would fly; probably the better thing to do is
ensure that the cleanup gets called regardless of whether ath5k_stop
gets called (it shouldn't matter since the irqs all get created in
_attach).

-- 
Bob Copeland %% www.bobcopeland.com
