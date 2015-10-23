Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33492 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbbJWOT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 10:19:28 -0400
Received: by qkcy65 with SMTP id y65so76735762qkc.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 07:19:27 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 Oct 2015 17:19:26 +0300
Message-ID: <CAFSVvRdboZtYGYAjX7WziNmqv=CmN_hAtXVELZM8Lnu14_5x6w@mail.gmail.com> (sfid-20151023_161931_686278_CD93FA90)
Subject: Regression in minstrel_ht vs minstrel?
From: Dmitrijs Ivanovs <dmitrijs.ivanovs@ubnt.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

While investigating a case of intermittent extreme packet loss, I've
found that minstrel_ht algo has one possible regression compared to
non-HT version of minstrel. It does not add lowest rate to the last
element of rate table array.

Minstrel:

    /* Use lowest rate last */
    ratetbl->rate[i].idx = mi->lowest_rix;
    ratetbl->rate[i].count = mp->max_retry;
    ratetbl->rate[i].count_cts = mp->max_retry;
    ratetbl->rate[i].count_rts = mp->max_retry;

Minstrel HT:

    rates->rate[i].idx = -1;

This difference can be easily patched. I have two otherwise identical
ath9k-based stations under test for the last two days sitting in the
same noisy environment. So far, patched one seems to be more robust.

Is this difference an intentional design decision or should I submit the patch?
