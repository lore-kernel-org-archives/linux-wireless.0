Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:38678 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZLIRS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 12:18:26 -0500
Received: by iwn1 with SMTP id 1so4712772iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 09:18:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fd145f7d0912082203l1d7ebc50j291cc36dd65a4408@mail.gmail.com>
References: <fd145f7d0912082203l1d7ebc50j291cc36dd65a4408@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 9 Dec 2009 09:18:12 -0800
Message-ID: <43e72e890912090918m55d2816co9b04065e91e4d4f1@mail.gmail.com>
Subject: Re: WARNING at mac80211_ieee80211_rx
To: Jeffrey Baker <jwbaker@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2009 at 10:03 PM, Jeffrey Baker <jwbaker@gmail.com> wrote:
> My access point with an AR9220 stopped passing traffic,

Jeffrey, thanks for your report, can you be a little more verbose here
and elaborate as to what you mean by this? Do you mean that you stop
hostapd or that it hostapd is still running and that somehow you
notice it stops sending data between its associated STAs?

> and these were
> seen in dmesg.  I am using compat-wireless 2009-11-06.
>
> also at pastebin: http://pastebin.com/m527862e9
>
> [505869.263259] ------------[ cut here ]-----------             -
> [505869.269520] WARNING: at
> /root/compat-wireless-2009-11-06/net/mac80211/rx.c:2486

This would be from:

        /*
         * The same happens when we're not even started,
         * but that's worth a warning.
         */
        if (WARN_ON(!local->started))
                goto drop

So somehow the RX tasklet kicked in and ath9k RX engine was still running.

  Luis
