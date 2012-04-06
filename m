Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37314 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab2DFLWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 07:22:32 -0400
Received: by eekc41 with SMTP id c41so668640eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 04:22:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Subject: Re: carl9170: not able to add P2P_GO - add_interface fail with -EBUSY
Date: Fri, 6 Apr 2012 13:22:26 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <CAFED-jno-531+5TPOjDJ598jAO1zMmFpe6UJOsRt4SfbCU9zDQ@mail.gmail.com>
In-Reply-To: <CAFED-jno-531+5TPOjDJ598jAO1zMmFpe6UJOsRt4SfbCU9zDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201204061322.26832.chunkeey@googlemail.com> (sfid-20120406_132236_635251_5F588D8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 April 2012 12:39:57 Janusz Dziedzic wrote:
> With latest compat, wpa_supplicant seems p2p_concurent is set for
> car9170 driver based on information from driver.
> So, next after p2p_group_add new virtual interface is created for that
> - p2p-wlan0-0.
> 
> Next, carl9170_op_add_interface() return -EBUSY because there is
> already main_vif (NL80211_IFTYPE_STATION) created by default on
> startup.
> Because of that p2p_group_add() always fail with such chipset and
> p2p_concurent=1.
> 
> STEPS:
> - run wpa_supplicant
> - run wpa_cli
> - p2p_group_add
> FAIL
> 
> Is that chipset limitation we could add only new STA interface when
> main_vif is also STA?
<http://wireless.kernel.org/en/users/Drivers/carl9170#Multiple_Interfaces>
no, it's not. But you'll have to go through several hoops to extend
the driver to switch the "main" interface while the device is up and
running.

good luck!

> Where could I find HW documentation for carl9170?
HW documentation for carl9170? There's no such thing.
But Qualcomm has some docs about the AR9170.
 
> I suspect lower change is not acceptable because of HW limitation?
> 
>         main_vif = carl9170_get_main_vif(ar);
> 
>         if (main_vif) {
>                 switch (main_vif->type) {
>                 case NL80211_IFTYPE_STATION:
> -                       if (vif->type == NL80211_IFTYPE_STATION)
> +                       if ((vif->type == NL80211_IFTYPE_STATION) ||
> +                           (vif->type == NL80211_IFTYPE_AP))
>                                 break;
No, it's just the driver can't guarantee that such a configuration
will be what you think it is.

Regards,
	Chr
