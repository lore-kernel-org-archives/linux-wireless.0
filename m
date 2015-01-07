Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44487 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbbAGKOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 05:14:03 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so7729715wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 02:14:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420432796-10765-1-git-send-email-sujith@msujith.org>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
Date: Wed, 7 Jan 2015 11:14:01 +0100
Message-ID: <CA+BoTQ=HqF0vBj4chXfoY9GKcFBP8Xh37HXo5etDDZ1XCg6O4w@mail.gmail.com> (sfid-20150107_111408_880910_0BCA8C7E)
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
From: Michal Kazior <michal.kazior@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 January 2015 at 05:39, Sujith Manoharan <sujith@msujith.org> wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> The HTT RX ring is replenished with a maximum of 16 buffers,
> but this might be insufficient when RX traffic is high.
> Not having enough RX buffers throttles the FW, resulting
> in low throughput.
>
> This patch adds a module parameter to adjust the fill size
> based on the platform/usage.

I don't think this should be adjustable.

I assume you tested this in conjunction with rx batching patch - what
fill level values did you use to see throughput improvement? How
(un)responsive was serial/ssh connection to the machine?

I have a patch internally which removes the replenishment tasklet and
I wonder how will it behave with rx batching then, hmm..


Michał
