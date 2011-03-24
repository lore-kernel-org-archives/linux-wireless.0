Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41815 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab1CXNKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 09:10:51 -0400
Received: by bwz15 with SMTP id 15so25178bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 06:10:50 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
Date: Thu, 24 Mar 2011 14:09:03 +0100
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org
References: <201103232358.29966.helmut.schaa@googlemail.com> <AANLkTi=BLTJhxYf552GLW1zG-AvVdeKj86e2K-vEm_Wy@mail.gmail.com> <201103240836.45753.helmut.schaa@googlemail.com>
In-Reply-To: <201103240836.45753.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103241409.03170.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[trimmed CC as this is not rt2x00 specific anymore]

Am Donnerstag, 24. März 2011 schrieb Helmut Schaa:
> After adding the code to issue BARs when a AMPDU subframe failed, the issue
> seems to not happen anymore. However, in some rare cases it happened again and
> the Intel STA wasn't able to "receive" anything anymore (for example it still
> happenend after running an iperf for ~150 seconds instead of just a few seconds
> as before).

Ok, found out some more. The problem now seems to trigger only if the Intel STA
leaves powersave and mac80211 dropped a frame while the STA was sleeping (either
due to the size of the STA PS buffer or due to a race between rx/tx processing).

This can also cause a sequence number hole in the STAs rx reordering buffer but
we won't send a BAR in that case ending in the same situation that the Intel STA
BlockAcks AMPDUs to it but doesn't pass them to the user space.

Johannes, does it make sense to always send a BAR when a STA wakes up from
sleep and we've got an active aggregation session?

Thanks,
Helmut
