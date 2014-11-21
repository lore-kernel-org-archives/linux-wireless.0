Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56946 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaKUKk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 05:40:29 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so11583327wiw.8
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2014 02:40:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21615.5541.120044.376524@gargle.gargle.HOWL>
References: <1416492382-18058-1-git-send-email-sujith@msujith.org>
	<CA+BoTQnyf0tvg8ngLqsoux-A9-3J46cDuJdd-V=kS24wWS4Y1A@mail.gmail.com>
	<21615.3019.437408.992893@gargle.gargle.HOWL>
	<CA+BoTQm_X3-kpJanZu=dJ3LDPqjAfnUoyBwqzgYGX3bK+H1f2g@mail.gmail.com>
	<21615.5541.120044.376524@gargle.gargle.HOWL>
Date: Fri, 21 Nov 2014 11:40:27 +0100
Message-ID: <CA+BoTQk2fy024b5E=khSrzpUGzCL=jU_4wpxJ0AAyxmsFZuWhA@mail.gmail.com> (sfid-20141121_114033_785793_C47E1E67)
Subject: Re: [RFC] ath10k: Fix shared WEP
From: Michal Kazior <michal.kazior@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 November 2014 11:36, Sujith Manoharan <sujith@msujith.org> wrote:
> Michal Kazior wrote:
>> Good point, but what I'm worried it'll be easier to miss this subtlety
>> and introduce races in the future.
>
> I am not very familiar with ath10k locking, but peer_keys is
> also used in ath10k_clear_peer_keys(), where it relies on conf_mutex.
> Should that be addressed too ?

Yes. Basically peer->keys[] should be protected by both conf_mutex and
data_lock if you want to modify it. If you want to read it you need
either one.


>> Do you have it saved somewhere? If so, can you post it, please?
>
> http://pastebin.com/yywiPZXL

Thanks! Looks like the `cancel_work_sync(&arvif->wep_key_work);`
should go _before_ `mutex_lock(&ar->conf_mutex);`.

I'm busy with some stuff so feel free to send a patch :-)


Michał
