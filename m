Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33354 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbcASLfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 06:35:03 -0500
Received: by mail-wm0-f53.google.com with SMTP id 123so87494886wmz.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2016 03:35:02 -0800 (PST)
Received: from archlinux-alberto (cm-93-156-107-18.telecable.es. [93.156.107.18])
        by smtp.gmail.com with ESMTPSA id l7sm28256422wjx.14.2016.01.19.03.34.59
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Jan 2016 03:34:59 -0800 (PST)
Date: Tue, 19 Jan 2016 12:34:57 +0100
From: albertofanjul@gmail.com
To: linux-wireless@vger.kernel.org
Subject: Checking p2p capabilities
Message-ID: <20160119113457.GA32060@archlinux-alberto> (sfid-20160119_123521_709483_A29A5BDE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I'm maintainer of https://github.com/albfan/miraclecast and as a project with specific hardware needs, I build a hardware tester, but it is to naive:

https://github.com/albfan/miraclecast/blob/master/res/miracle-utils.sh#L68

basically it look for p2p interface modes grepping iw phy <phyname> info.

Lot of people trying miraclecast ask me:why it's device do not support p2p?  (while it's documentation says it does, many times is just what they think, not reality).

I wonder if that is a matter of driver, modules or pure hardware. Is there any way to check it directly and not from a grep inside iw ?.

something like:

iw phy wlp3s0 get P2P-client
iw phy wlp3s0 get P2P-GO

About kernel, modules and hardware, are they completely black box for others?, I mean, can I detect if my device hardware supports some interface but my driver or module can't?


At this point my script informs pretty well, and there's a few people ask such things, but I would like to check it in a better way, even with an api inside my project

Something related with this lines I could check by myself (I use that clone for it's line anchors)

https://github.com/cozybit/iw/blob/master/util.c#L124
https://github.com/cozybit/iw/blob/master/info.c#L276

NL80211_ATTR_SUPPORTED_IFTYPES
NL80211_IFTYPE_MAX
