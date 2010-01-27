Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46537 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0A0SMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 13:12:41 -0500
Received: by pwi21 with SMTP id 21so3903950pwi.21
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 10:12:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <868377.1443.qm@web51406.mail.re2.yahoo.com>
References: <868377.1443.qm@web51406.mail.re2.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Jan 2010 10:12:21 -0800
Message-ID: <43e72e891001271012r60356d85k60fe55fbb027aa40@mail.gmail.com>
Subject: Re: mac80211: Open bug in current wireless-testing
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2010 at 6:17 AM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
> Hello all,
> some time ago I reported that it is currently impossible to change a manually selected data rate back to the automatic rate selection. This bug is still present and is easy to reproduce:
>
> iwconfig wlan0 rate 54M
> iwconfig wlan0 rate auto
>
> I know that the wireless extensions are deprecated, but until iw supports manual rate selection, iwconfig is what I have to use.

Review the patch:

Author: Jouni Malinen <jouni.malinen@atheros.com>
Date:   Tue Dec 29 12:59:45 2009 +0200

    nl80211: New command for setting TX rate mask for rate control

    Add a new NL80211_CMD_SET_TX_BITRATE_MASK command and related
    attributes to provide support for setting TX rate mask for rate
    control. This uses the existing cfg80211 set_bitrate_mask operation
    that was previously used only with WEXT compat code (SIOCSIWRATE). The
    nl80211 command allows more generic configuration of allowed rates as
    a mask instead of fixed/max rate.

    Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
    Acked-by: Johannes Berg <johannes@sipsolutions.net>

I think that addresses this, not sure if we ever got the iw equivalent
patches to let userspace use this yet.

There are however three wext things which we still do need implement to nl80211:

iwconfig wlan0 txpower 17 # sets TX output power to 17 dBm
iwconfig wlan0 power off # disables power save
iwconfig wlan0 power 500m # enables dynamic power wave with 500ms idle
timeout trigger

I've stuffed this int our todo list [1], if you confirm that the above
patch does not yet address what you wish please add it to the todo
list.

http://wireless.kernel.org/en/developers/todo-list

  Luis
