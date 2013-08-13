Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:41746 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3HMKWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 06:22:53 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so2554524bkh.12
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 03:22:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1376373578-2180-3-git-send-email-michal.kazior@tieto.com>
References: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
	<1376373578-2180-1-git-send-email-michal.kazior@tieto.com>
	<1376373578-2180-3-git-send-email-michal.kazior@tieto.com>
Date: Tue, 13 Aug 2013 12:22:51 +0200
Message-ID: <CA+BoTQ=5HwVpbWWBw_iRBhZ=yC_33buEdZ10=cU_7UJzQo=_kg@mail.gmail.com> (sfid-20130813_122256_863331_9141B4F1)
Subject: Re: [PATCH v2 2/4] ath10k: fix HTC endpoint worker starvation
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 August 2013 07:59, Michal Kazior <michal.kazior@tieto.com> wrote:
> HTC used a worker for each endpoint. This worked
> until a slow host machine was flooded with massive
> number of TX requests. HTT related worker would
> remain active while WMI worker was starved. This
> ended up with "could not send beacon" in AP mode.
> It was even possible to see userspace being
> starved.
>
> The patch switches from using workers to using
> tasklets for processing and submitting HTC frames
> to HIF.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I'd like drop this patch, at least for now. I'm having doubts this is
the right way to solve the problem.


Pozdrawiam / Best regards,
Michał Kazior.
