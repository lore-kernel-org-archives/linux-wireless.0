Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46761 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbaKUKOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 05:14:07 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so2173227wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2014 02:14:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21615.3019.437408.992893@gargle.gargle.HOWL>
References: <1416492382-18058-1-git-send-email-sujith@msujith.org>
	<CA+BoTQnyf0tvg8ngLqsoux-A9-3J46cDuJdd-V=kS24wWS4Y1A@mail.gmail.com>
	<21615.3019.437408.992893@gargle.gargle.HOWL>
Date: Fri, 21 Nov 2014 11:14:03 +0100
Message-ID: <CA+BoTQm_X3-kpJanZu=dJ3LDPqjAfnUoyBwqzgYGX3bK+H1f2g@mail.gmail.com> (sfid-20141121_111412_930708_F6CDED7F)
Subject: Re: [RFC] ath10k: Fix shared WEP
From: Michal Kazior <michal.kazior@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 November 2014 10:54, Sujith Manoharan <sujith@msujith.org> wrote:
> Michal Kazior wrote:
[...]
>> Read access to peer->keys should be protected by either data_lock or
>> conf_mutex. Obviously the latter can't be used because this function
>> will be called from an atomic context leaving the data_lock. The
>> entire is_peer_wep_key_set() should require data_lock to be held while
>> it is called to avoid races.
>>
>> Oh, and apparently this is buggy anyway because
>> ath10k_install_peer_wep_keys() is oblivious to this. Oops..
>
> I don't think it can happen, though ? ath10k_install_peer_wep_keys()
> would be called only when a station transitions to ASSOC and message 3
> can't be received when that happens ?

Good point, but what I'm worried it'll be easier to miss this subtlety
and introduce races in the future.


> (But, I did see a lockdep splat when using WEP).

Do you have it saved somewhere? If so, can you post it, please?


Michał
