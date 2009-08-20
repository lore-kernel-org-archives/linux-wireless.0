Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:34595 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZHTDWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 23:22:24 -0400
Received: by vws2 with SMTP id 2so4150876vws.4
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 20:22:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <445f43ac0908191633xf9348cdu5bbdd3ac08e13260@mail.gmail.com>
References: <445f43ac0908191633xf9348cdu5bbdd3ac08e13260@mail.gmail.com>
Date: Wed, 19 Aug 2009 23:22:25 -0400
Message-ID: <b6c5339f0908192022g7d6a52b1v54f8bed16844c87e@mail.gmail.com>
Subject: Re: ath9k mesh beaconing behavior
From: Bob Copeland <me@bobcopeland.com>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 7:33 PM, Javier Cardona<javier@cozybit.com> wrote:
> Hi,
>
> Could someone familiar with the ath9k help us solve a problem with
> mesh beaconing?

I am not too familiar with ath9k, but I would suspect that
there's an ordering issue with when enable_beacon is recognized,
so beaconing doesn't start until the next reset() is called.

E.g. this fix for ath5k sounds similar:

commit 9718512d81a7f7bd0166d1e033f8395022ecb2e9
Author: Bob Copeland <me@bobcopeland.com>
Date:   Wed Jul 29 10:29:03 2009 -0400

    ath5k: update PCU opmode whenever a new interface is added

-- 
Bob Copeland %% www.bobcopeland.com
