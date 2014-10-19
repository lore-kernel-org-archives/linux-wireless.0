Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54520 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJSNVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2014 09:21:17 -0400
Received: by mail-ie0-f178.google.com with SMTP id rl12so3256136iec.37
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2014 06:21:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJXPbmrfrgyoE5X9UO-3LQQVnXYtpz3x1Sd-fhts-Ns-g@mail.gmail.com>
References: <CABPxzYJXPbmrfrgyoE5X9UO-3LQQVnXYtpz3x1Sd-fhts-Ns-g@mail.gmail.com>
Date: Sun, 19 Oct 2014 16:21:16 +0300
Message-ID: <CAB3XZEf19C5DjK-Dod5HKKv2d6bNXgNAvjz+txZO1RQL8jzFDg@mail.gmail.com> (sfid-20141019_152128_952743_E40F700A)
Subject: Re: SMPS for AP mode confoguration
From: Eliad Peller <eliad@wizery.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

On Sun, Oct 19, 2014 at 2:50 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> We are testing SMPS functionality for AP mode. The driver conveys its
> capabilities through setting the HT capability which can be set to 0-3.
>
> I wanted to convey support for both Dynamic and Static Powersave
> and then control the config through hostapd.conf file. Currently this is
> not possible.From driver i can only advertize support for static (or) dynamic
> not both (HW_SUPPORTS_* is a different thing which is used in
> doing checks at debugfs level).
>
> So if i wanted to configure different modes from hostapd.conf, i
> have to change the driver settings as well.
>
> Shouldn't it be the other way around, based on driver's _HW_ flags
> we should convey the capabilities to user-space  (currently we use
> ht_cap for this) and it will configure the mode from the configuration
> file.  I think the design of SMPS configuration should be changed.
>
this was recently changed. take a look at this patchset:
http://www.spinics.net/lists/linux-wireless/msg126749.html

we also have a matching supplicant patchset that will probably be
upstreamed soon.

Eliad.
