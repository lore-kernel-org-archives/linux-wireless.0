Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35685 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab3ERVHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 17:07:11 -0400
Received: by mail-ob0-f176.google.com with SMTP id wp18so5850453obc.35
        for <linux-wireless@vger.kernel.org>; Sat, 18 May 2013 14:07:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5197AF6B.5040800@thinktube.com>
References: <CAMfPB_xTUy72YokSoYJezOX_gb54CJEd7V6+4pAfOHnAzUMJcQ@mail.gmail.com>
	<5197AF6B.5040800@thinktube.com>
Date: Sat, 18 May 2013 23:07:11 +0200
Message-ID: <CAMfPB_yVuSD765CAycUtdWBTvEEam=MpdCGKpWDJAvFiEjvLrw@mail.gmail.com> (sfid-20130518_230716_581537_1DC76B1C)
Subject: Re: rt3070-based usb device won't accept mac address changes
From: Alessandro Lannocca <alessandro.lannocca@gmail.com>
To: Bruno Randolf <br1@thinktube.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After digging a bit into linux-stable.git I found the culprit: this
regression comes from commit #
6c50f9459e62eb133563fd23606f68bfc9d120e8 (rt2x00: Use addr_mask to
disallow invalid MAC addresses in mutli-bssid mode) ; reverting it
fixes the problem, tested by me in compat-drivers-2013-03-28-5-u .


I can't tell if reverting that commit adds any trouble as I'm not a
developer; however I'm sure you guys will know how to handle the
situation.


Alessandro Lannocca
