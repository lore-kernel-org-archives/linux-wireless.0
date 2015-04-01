Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36790 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbbDAMiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 08:38:14 -0400
Received: by wgra20 with SMTP id a20so51786075wgr.3
        for <linux-wireless@vger.kernel.org>; Wed, 01 Apr 2015 05:38:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427798961-7334-3-git-send-email-michal.kazior@tieto.com>
References: <1427798961-7334-1-git-send-email-michal.kazior@tieto.com>
	<1427798961-7334-3-git-send-email-michal.kazior@tieto.com>
Date: Wed, 1 Apr 2015 14:38:13 +0200
Message-ID: <CA+BoTQmhEf3fZSo2FPFbXa=Uc4ia0Sg2SD89gceyc8O+jVJeUg@mail.gmail.com> (sfid-20150401_143817_721611_ACAB83DE)
Subject: Re: [PATCH v2 2/2] ath10k: implement more versatile set_bitrate_mask
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2015 at 12:49, Michal Kazior <michal.kazior@tieto.com> wrote:
> Until now only a single fixed tx rate or nss was
> allowed to be set.
>
> The patch attempts to improve this by allowing
> most bitrate masks. The limitation is VHT MCS
> rates cannot be expressed separately and only the
> following VHT MCS ranges are supported: none, 0-7,
> 0-8, and 0-9.
>
> This keeps the old behaviour when requesting
> single tx rate or single nss. The new bitrate mask
> logic is only applied to other cases that would
> return -EINVAL until now.
>
> Depending on firmware revisions some combinations
> may crash firmware so use with care, please.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Hi Kalle,

Drop this patch ([2/2]) for now, please. It looks like it doesn't work
well with crypto networks. I'll need to rework this. The [1/2] is fine
as it is though.


Michał
