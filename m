Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34379 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2F3EPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 00:15:12 -0400
Received: by wgbds11 with SMTP id ds11so1369531wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2012 21:15:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHD-aqL9tW_rF3V0-_FX4erdyZE8vNYr+d=dShptRbePaXN_JQ@mail.gmail.com>
References: <CAHD-aq+nNs4L0iZNxYSABX-1Wk+B=s-Avqc1TFYfO-8JOOZ5kA@mail.gmail.com>
 <20455.47109.203396.141311@gargle.gargle.HOWL> <CAHD-aqL9tW_rF3V0-_FX4erdyZE8vNYr+d=dShptRbePaXN_JQ@mail.gmail.com>
From: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
Date: Sat, 30 Jun 2012 01:14:50 -0300
Message-ID: <CAHD-aqJZmG7uXyTgAqFqot-R1K1EhVsnXLhjsJr_pQsSCbrnNg@mail.gmail.com> (sfid-20120630_061531_792632_0DE9C280)
Subject: Re: Regression on ath9k_htc managed mode
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 26, 2012 at 4:26 PM, Guido Iribarren
<guidoiribarren@buenosaireslibre.org> wrote:
> On Sun, Jun 24, 2012 at 9:59 PM, Sujith Manoharan
> <c_manoha@qca.qualcomm.com> wrote:
>> Guido Iribarren wrote:
>>> Hello nice people,
>>> we've recently found a bug when using infrastructure mode with tplink
>>> wn722n usb dongles (ath9k_htc driver)
>>
>> Can you try this patch : http://tinyurl.com/7ywqzoz ?
>
> Hello Sujith!
> thanks for the patch, i found it strange because it seems related to
> IBSS, but i just tried it anyway
> unfortunately it didn't solve the problem :(

Well, turns out I wasn't applying the patch correctly.
That is, I applied it manually in the build_dir of openwrt, and when I
ran "make" it was overwritten with the vanilla (unpatched)
compat-wireless
So the tests were null :-$

I just applied the patch correctly, and it works!

ath9k_htc in client mode now correctly accepts broadcast packets,
after applying the patch you sent Sujith!

Thanks a lot,

Now, i see this comes from linville tree: is this going to be (or has
already been) applied in trunk?

Thanks again for the help Sujith,

Guido
