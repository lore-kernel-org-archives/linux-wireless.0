Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:41581 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbeECXtH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 19:49:07 -0400
Received: by mail-wr0-f175.google.com with SMTP id g21-v6so19254358wrb.8
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2018 16:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org> <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
In-Reply-To: <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
From: Adrian Chadd <adrian@freebsd.org>
Date: Thu, 03 May 2018 23:48:53 +0000
Message-ID: <CAJ-VmonSEuh7Ou=K9Gu-gZ5ikpX9H=nzXe9NssNu1vw8fEk3hg@mail.gmail.com> (sfid-20180504_014910_647646_3A5BB585)
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
To: srirrama@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

May we have a little more information about how this is supposed to work?

It looks like we're supposed to send the information about the matched
radar pattern back to the firmware for confirmation? What's the intended
behaviour from the firmware? Will the firmware have a hard-coded set of
patterns we have to answer in/by?

I ask (like Peter, we work together) because we've had to tweak this
behaviour a little to actually pass FCC / ETSI DFS certification. My
general concern is that this'll cause a lot of false detects on boards that
haven't had things tweaked for the given board. As far as I'm aware the DFS
parameters are still hard-coded into the firmware image so if you have to
change those you're SOL without the relevant NDAs - this makes running the
open source DFS stuff a little tricksy on vendor boards.



-adrian
