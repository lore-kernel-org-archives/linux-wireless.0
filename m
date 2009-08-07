Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:37844 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZHGUml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 16:42:41 -0400
Received: by ey-out-2122.google.com with SMTP id 9so581112eyd.37
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 13:42:40 -0700 (PDT)
Message-ID: <4A7C91B8.2010106@gmail.com>
Date: Fri, 07 Aug 2009 21:42:32 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/4] orinoco: use cfg80211 for key manipulation
References: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Kilroy wrote:
> First attempt at connect/disconnect, join_ibss/leave_ibss, and add_key
> etc. These patches rely on the series I just sent, but conflict with
> Holgers set_channel patch. Simple to resolve, and I'll do that in my
> next update.
> 
> This doesn't work yet*, but I've a number of questions.

FYI, I've got this kinda working with wpa_supplicant in wext mode.

First: on it's own wpa_supplicant keeps doing the 4 way handshake, while
 cfg80211 pumps out the following:

------------[ cut here ]------------
WARNING: at net/wireless/sme.c:451 __cfg80211_roamed+0x9a/0x1a5 [cfg80211]()
Hardware name: Latitude C600
Modules linked in: orinoco_cs orinoco cfg80211 michael_mic snd_maestro3
aty128fb [last unloaded: cfg80211]
Pid: 5, comm: events/0 Tainted: G   M    W  2.6.31-rc4-wl #87
Call Trace:
 [<c101ca51>] warn_slowpath_common+0x60/0x90
 [<c101ca8e>] warn_slowpath_null+0xd/0x10
 [<d1521659>] __cfg80211_roamed+0x9a/0x1a5 [cfg80211]
 [<d15139a9>] cfg80211_event_work+0x104/0x1bc [cfg80211]
 [<c102b39c>] worker_thread+0x15e/0x208
 [<d15138a5>] ? cfg80211_event_work+0x0/0x1bc [cfg80211]
 [<c102e5d5>] ? autoremove_wake_function+0x0/0x33
 [<c102b23e>] ? worker_thread+0x0/0x208
 [<c102e261>] kthread+0x66/0x6b
 [<c102e1fb>] ? kthread+0x0/0x6b
 [<c1003053>] kernel_thread_helper+0x7/0x10
---[ end trace 12e5dbe2024c37ae ]---

Cfg80211 is trying to select the bss we've authenticated against.
Unfortunately the BSS list is empty.

If before starting wpa_supplicant I run:

iw dev eth1 scan ssid <SSID>

Then wpa_supplicant connects fine. The AP in question is configured with
a hidden SSID.

Any suggestions as to how I need to address this?


Regards,

Dave.
