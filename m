Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:33236 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755432AbeDWQlJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:41:09 -0400
Received: by mail-wr0-f182.google.com with SMTP id z73-v6so43115604wrb.0
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2018 09:41:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wowxdirv.fsf@kamboji.qca.qualcomm.com>
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
 <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
 <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com> <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
 <87604oodt4.fsf@kamboji.qca.qualcomm.com> <a7dd1b94951725c61034f5be6744b725@codeaurora.org>
 <8736zrjgq6.fsf@kamboji.qca.qualcomm.com> <c48c1bae-04c9-55d0-fdb9-d9ae8f7cb843@dd-wrt.com>
 <5AD9A1DF.6060007@broadcom.com> <87wowxdirv.fsf@kamboji.qca.qualcomm.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Mon, 23 Apr 2018 09:41:06 -0700
Message-ID: <CAJ-Vmoky_ErN447XxvUw4fcHZPptzbBpfLU1eXSCbevhAayy8A@mail.gmail.com> (sfid-20180423_184137_342001_895AAF08)
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        govinds@codeaurora.org, pillair@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 April 2018 at 08:50, Kalle Valo <kvalo@codeaurora.org> wrote:

>
> Adrian was also commenting something similar about adding a debugfs
> interface but I don't really see the point right now while we are adding
> initial wcn3990 support. If someone wants to run measurements with and
> without this parameter it's very easy to edit it out from the sources.
> Later on we can consider making it dynamic if there's really the need
> for that, but I'm very skeptic that anyone would even need that.

Hi!

We have at ${WORK}, because we've found various devices (atheros and
qualcomm and QCA and otherwise) have this nasty habit of trying to
guess when a good time to clock-gate down is, but we're busy doing low
latency audio/video.

10, 20ms may not be a lot of latency for bulk data but that's a half
to one of a video frame in my world. :-)



-adrian
