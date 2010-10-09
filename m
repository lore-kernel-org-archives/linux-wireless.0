Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51080 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760085Ab0JIMSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 08:18:14 -0400
Received: by fxm14 with SMTP id 14so930956fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 05:18:13 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/3] cfg80211: add channel utilization stats to the survey command
Date: Sat, 9 Oct 2010 14:17:25 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, br1@einfach.org
References: <1286584771-76663-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286584771-76663-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010091417.25727.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag 09 Oktober 2010 schrieb Felix Fietkau:
> Using these, user space can calculate a relative channel utilization
> with arbitrary intervals by regularly taking snapshots of the survey
> results.

What if you've got multiple consumers, wouldn't that mess up the
survey results?

I mean, for example mac80211 and/or hostapd might want to use the busy time
statistics for the BSS load IE while a different userspace process might
want to monitor the channel utilization in order to detect a worsening
channel condition.

If the consumers happen to use the same interval and request the survey
very soon after each other one consumer will get the values on a nice (close
to the query interval) time base while the other one will get the values
based on a very small interval (which might lower the value's
representativeness).

Helmut
