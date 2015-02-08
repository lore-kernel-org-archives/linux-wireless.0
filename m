Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:61894 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbBHK5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 05:57:45 -0500
Received: by mail-ig0-f180.google.com with SMTP id b16so11172237igk.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 02:57:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=rj=1OE8xv_q4cTRVkF_=Ko-3amjn4_6tYHXg9dtev=9A@mail.gmail.com>
References: <1420645811-17877-1-git-send-email-eliad@wizery.com>
	<1420645811-17877-3-git-send-email-eliad@wizery.com>
	<20150207115758.GA503@w1.fi>
	<CALhHN=rj=1OE8xv_q4cTRVkF_=Ko-3amjn4_6tYHXg9dtev=9A@mail.gmail.com>
Date: Sun, 8 Feb 2015 12:57:44 +0200
Message-ID: <CAB3XZEfJt=YKP8+SKie7L_4sdxcdrGUtzruDvrjFKDvXKo2L3w@mail.gmail.com> (sfid-20150208_115757_883211_7A175F84)
Subject: Re: [PATCH v2 3/3] mac80211: don't defer scans in case of radar detection
From: Eliad Peller <eliad@wizery.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 7, 2015 at 9:17 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> BTW, what in case we will start AP on first interface (DFS channel),
> on second one we will try to connect to other AP. As I understand this
> correctly, second iface (STA iface) will not allow to scan (connect)
> ...?
>
right.
The rationale behind it that you must listen constantly to detect
radar events, which prevents scanning off-channel.
(i guess an exception for on-channel scanning can be added if needed, though)

> Other case, what if we start DFS AP and allow to scan in AP mode (eg
> for ACS purpose, allow to choose better channel and do CSA ...)?
ditto. you just have to make sure you keep listening on the operating channel.

Eliad.
