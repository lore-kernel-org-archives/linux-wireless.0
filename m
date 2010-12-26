Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58221 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0LZMWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 07:22:12 -0500
Received: by qwa26 with SMTP id 26so7905542qwa.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Dec 2010 04:22:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101226112452.31775.12810.stgit@fate.lan>
References: <20101226112404.31775.77854.stgit@fate.lan>
	<20101226112452.31775.12810.stgit@fate.lan>
Date: Sun, 26 Dec 2010 13:22:09 +0100
Message-ID: <AANLkTi=yN485OSM+TSPoZrG=h3M0vhAAmVgmndxp-BrG@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] zd1211rw: implement beacon fetching and handling ieee80211_get_buffered_bc()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/26 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:
> +       if (mac->vif || mac->vif->type == NL80211_IFTYPE_UNSPECIFIED)
> +               return;

That's smelly. I think you meant negation in first part of condition.


> -       if (int_status & INT_CFG_NEXT_BCN)
> +       if (int_status & INT_CFG_NEXT_BCN) {
>                dev_dbg_f_limit(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
> -       else
> +               zd_beacon_done(mac);
> +       } else
>                dev_dbg_f(zd_mac_dev(mac), "Unsupported interrupt\n");

Minor thing, check http://www.kernel.org/doc/Documentation/CodingStyle

> This does not apply if one branch of a conditional statement is a single
> statement. Use braces in both branches.

Use brackets for "else" as well please.

-- 
Rafał
