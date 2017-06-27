Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:34758 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753699AbdF0Uoz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 16:44:55 -0400
Received: by mail-ua0-f180.google.com with SMTP id z22so26171075uah.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 13:44:54 -0700 (PDT)
MIME-Version: 1.0
From: Tordek <kedrot@gmail.com>
Date: Tue, 27 Jun 2017 17:44:53 -0300
Message-ID: <CAKUXR6OHZzfTVKXupnqbx3nX8gajpefwmkWrqtgbWcWuGyreWg@mail.gmail.com> (sfid-20170627_224511_180060_C55CE9F9)
Subject: Potential byte order issue in staging/wilc1000/wilc_wfi_cfgoperations.c
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

Line 1464 contains the following:

    if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {

However Sparse complains that `ieee80211_is_action` takes a __le16
parameter. Would a cpu_to_le16 be required in this case?

If so, I'd be happy to submit a patch.

Thanks in advance

--
Guillermo O. Freschi
