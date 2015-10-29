Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35513 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbbJ2Gqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 02:46:33 -0400
Received: by igpw7 with SMTP id w7so21260003igp.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 23:46:32 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 29 Oct 2015 12:16:13 +0530
Message-ID: <CABPxzYJNCFzCWgbRYxGbkrf1x6BPupC8+O5R7167FDL1rK+4mA@mail.gmail.com> (sfid-20151029_074636_568910_169BDB70)
Subject: Undocumented Sleep Requirements for ieee80211_ops
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>From the documentation:(mac80211.h) For the ieee80211_ops
(un)assign_vif_chanctx, there is no mention of explicit sleep
requirements (allowed/disallwoed) for the callback.

>From a quick glance at the code calling the OP, looks like we can
sleep (mutexes are used). So how should we handle such OPS? is it ok
to sleep in the callback?

We have a requirement where we need to wait for channel programming to
be done, before we allow data packets and it might take a while.

-- 
Thanks,
Regards,
Chaitanya T K.
