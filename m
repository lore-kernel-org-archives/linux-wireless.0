Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:41181 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752622AbeDLREd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 13:04:33 -0400
Received: by mail-lf0-f48.google.com with SMTP id o102-v6so8726919lfg.8
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 10:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20180411184156.167978-1-rkir@google.com> <87bmepjbna.fsf@purkki.adurom.net>
In-Reply-To: <87bmepjbna.fsf@purkki.adurom.net>
From: Roman Kiryanov <rkir@google.com>
Date: Thu, 12 Apr 2018 17:04:21 +0000
Message-ID: <CAOGAQeqSha9ZS6fMNJjd8iY+=up+sQgTKN8FmffCpuWZih2Q=A@mail.gmail.com> (sfid-20180412_190437_174616_29042D22)
Subject: Re: [PATCH] ANDROID: mac80211_hwsim: support/ignore power state changes
To: kvalo@codeaurora.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Bjoern Johansson <bjoernj@google.com>,
        Lingfeng Yang <lfy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

thank you for reviewing our patch. I am ok with applying this patch without
"ANDROID:" prefix. Do you want me to send an updated patch?

Regards,
Roman.

On Wed, Apr 11, 2018 at 9:23 PM Kalle Valo <kvalo@codeaurora.org> wrote:

> rkir@google.com writes:

> > From: Bjoern Johansson <bjoernj@google.com>
> >
> > Indicate support for power state changes and handle them by calling an
> > empty function.
> > The important part is "ieee80211_hw_set(hw, SUPPORTS_PS);" at the
> > bottom of the diff. Without this upper layers in the kernel will return
an
> > error code when trying to set the power state because the driver doesn't
> > indicate power state support. This in turn causes VTS
> > (Android Vendor Test Suite) failures because the WiFi HAL can't enable
> > power saving mode. The remaining code is just there to deal with the
> > incoming state change request.
> >
> > Signed-off-by: Bjoern Johansson <bjoernj@google.com>
> > Signed-off-by: Lingfeng Yang <lfy@google.com>
> > Signed-off-by: Roman Kiryanov <rkir@google.com>

> Why the odd "ANDROID:" prefix?

> --
> Kalle Valo
