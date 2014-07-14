Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34316 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbaGNRwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 13:52:53 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so3046192wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2014 10:52:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rxEtfWya4h2nBB4vEpheDLdAjDo40qid6OLar3dW+==Kg@mail.gmail.com>
References: <CACna6rxEtfWya4h2nBB4vEpheDLdAjDo40qid6OLar3dW+==Kg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 14 Jul 2014 23:22:30 +0530
Message-ID: <CABPxzY+otOYY4Uwr_Sr-C3egcsrAZRmpysmHK-=C+5N0_nb1jA@mail.gmail.com> (sfid-20140714_195256_581145_D10F2B9D)
Subject: Re: Setting TX power with nl80211 while being *not* connected
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2014 at 10:45 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
>
> I've noticed that setting TX power, e.g with:
> iw dev wlp2s0 set txpower fixed 1200
> has no effect if I'm disconnected.
>
> As soon as I connect to some network .config gets called, it has
> IEEE80211_CONF_CHANGE_POWER set and power_level is set to "12".
>
> I've quickly tested this and it seems that __ieee80211_recalc_txpower
> returns false if I'm not connected
> (rcu_dereference(sdata->vif.chanctx_conf) returns NULL).
>
> Is that expected? Is there any way to limit TX power for scanning purposes?
>
Not that i know of, we use a chipset specific way to control the ceiling.
I guess the rationale for not having this is because we use the regulatory
max values coming from crda./nvram for scanning which are good enough.

But it would be good to have this feature, to improve the scan if the things are
not working well with the max reg power.
