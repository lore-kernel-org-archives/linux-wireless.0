Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33687 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbbBZSB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 13:01:26 -0500
Received: by iecar1 with SMTP id ar1so18721197iec.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 10:01:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424958650-11165-1-git-send-email-jouni@qca.qualcomm.com>
References: <1424958650-11165-1-git-send-email-jouni@qca.qualcomm.com>
Date: Thu, 26 Feb 2015 10:01:25 -0800
Message-ID: <CA+55aFyMoNhwYKcYwfs7Jjxh-wQbQK92Gqs8pv9AcLJUwk13RA@mail.gmail.com> (sfid-20150226_190131_843489_DAD57C65)
Subject: Re: [PATCH] mac80211: Send EAPOL frames at lowest rate
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Thu, Feb 26, 2015 at 5:50 AM, Jouni Malinen <jouni@qca.qualcomm.com> wrote:
>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>

Also "Tested-by:", and I'd suggest marking it for stable too (although
I understand that David generally doesn't use stable tags, and just
sends them separately to the stable tree).

This fixes both Atheros and brcmsmac for me (with Ubiquiti UniFi APs).

My main laptop is iwlwifi, and the only reason that worked is
apparently that the iwlwifi driver already basically does something
similar on its own.

All the other devices I have apparently don't use the 802.11 code even
if they are Linux-based (ie mostly android, and presumably they use
some vendor driver rather than the minstrel rate-handling code).

                         Linus
