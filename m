Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:60284 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbaGNRPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 13:15:30 -0400
Received: by mail-oa0-f53.google.com with SMTP id j17so1726331oag.26
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2014 10:15:30 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 Jul 2014 19:15:29 +0200
Message-ID: <CACna6rxEtfWya4h2nBB4vEpheDLdAjDo40qid6OLar3dW+==Kg@mail.gmail.com> (sfid-20140714_191538_486517_7AA0F196)
Subject: Setting TX power with nl80211 while being *not* connected
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've noticed that setting TX power, e.g with:
iw dev wlp2s0 set txpower fixed 1200
has no effect if I'm disconnected.

As soon as I connect to some network .config gets called, it has
IEEE80211_CONF_CHANGE_POWER set and power_level is set to "12".

I've quickly tested this and it seems that __ieee80211_recalc_txpower
returns false if I'm not connected
(rcu_dereference(sdata->vif.chanctx_conf) returns NULL).

Is that expected? Is there any way to limit TX power for scanning purposes?

-- 
Rafał
