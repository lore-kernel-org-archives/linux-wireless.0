Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtareserve147.acsu.buffalo.edu ([128.205.7.157]:54296 "EHLO
        mtareserve1.acsu.buffalo.edu" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750964AbdAPVZI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 16:25:08 -0500
Received: from localmailg.acsu.buffalo.edu (localmailg.acsu.buffalo.edu [128.205.4.25])
        by mtareserve1.acsu.buffalo.edu (Postfix) with ESMTP id 289D12AEE693
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 16:16:55 -0500 (EST)
Received: from localmailg.acsu.buffalo.edu (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 1BD18E0052
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 16:16:55 -0500 (EST)
Received: from localmailg.acsu.buffalo.edu (localhost [127.0.0.1])
        by localmailg.acsu.buffalo.edu (Postfix) with ESMTP id D7C69E0054
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 16:16:54 -0500 (EST)
Received: from smtp.buffalo.edu (smtp1.acsu.buffalo.edu [128.205.5.253])
        by localmailg.acsu.buffalo.edu (Prefixe) with ESMTP id D622AE0052
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 16:16:54 -0500 (EST)
Received: from mail-yw0-f177.google.com (mail-yw0-f177.google.com [209.85.161.177])
        (Authenticated sender: jinghaos@buffalo.edu)
        by smtp.buffalo.edu (Postfix) with ESMTPSA id BBA1F1C63B86
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 16:16:54 -0500 (EST)
Received: by mail-yw0-f177.google.com with SMTP id l75so75949629ywb.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 13:16:54 -0800 (PST)
MIME-Version: 1.0
From: Jinghao Shi <jinghaos@buffalo.edu>
Date: Mon, 16 Jan 2017 16:16:23 -0500
Message-ID: <CAKdW-HF5R2=mGUvqvdAdhx2EAXmmZaRh9GvnMemxE+GYEXBQQQ@mail.gmail.com> (sfid-20170116_222512_068147_8EC03192)
Subject: Strange Behaviors in 802.11 Association MLME
To: linux-wireless@vger.kernel.org
Cc: Geoffrey Challen <challen@buffalo.edu>,
        Shuvendu Lahiri <Shuvendu.Lahiri@microsoft.com>,
        Ranveer Chandra <ranveer@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We're working on a formal validation framework for wireless protocol
implementations. We have performed experiments on the 802.11
association state machine and have found peculiar association
behaviors.We'd like to share our findings to the community and confirm
whether they reveal potential implementation bugs.

TLDR version: the client sends association request despite having
received association response from the AP, is this a bug?

We utilized a real time reactive packet jammer to create the following
packet loss pattern (the rate control policy was set to re-transmit
the packet at most once before reporting the packet as failed. This
may not be realistic in practice but helps reveal interesting
behaviors faster.)

 - ASSOC_REQ (received by the AP, confirmed by the following ASSOC_RESP)
 - ACK <---- JAMMED
 - ASSOC_REQ_RETRY <----- JAMMED, the driver will declare this packet as failed
 - ASSOC_RESP (received by the client, confirmed by the following ACK)
 - ACK
 - ASSOC_REQ <--- problematic packet
 - ...

I'm also attaching a pcap capture during this session. Our current
conjecture is that the failure status of the ASSOC_REQ was delivered
to the mac80211 MLME entity before the reception of the ASSOC_RESP
packet.

Let us know if there's any other information we can collect to help
tracing down the issue.

Regards,
Jinghao Shi
PhD Student
University at Buffalo
