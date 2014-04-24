Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:51250 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaDXJJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 05:09:26 -0400
Received: by mail-yh0-f42.google.com with SMTP id v1so1955140yhn.29
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 02:09:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=uvkjK-BYJL3gympEiraZupLdh67XzMjuGviQ4iaVuiw@mail.gmail.com>
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQkBCGyKYDaOMgdCi4Yw+SXeuRS+t0rGE8o=8+x2q5N74w@mail.gmail.com>
	<CAEFj986fsmUD2kvEN=vjHK32cunyFO+8bH-y7ZoWZAMkcunJ2w@mail.gmail.com>
	<CA+BoTQ=uvkjK-BYJL3gympEiraZupLdh67XzMjuGviQ4iaVuiw@mail.gmail.com>
Date: Thu, 24 Apr 2014 17:09:25 +0800
Message-ID: <CAEFj987CE+RLxLXFhKyvKEWB6PK-Dd7Rnq98th+w1hBJoy48Pg@mail.gmail.com> (sfid-20140424_110944_913951_05BC0784)
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 24, 2014 at 4:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 24 April 2014 10:50, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>>> I think Monitor operation should be performed on a best effort basis.
>>> This means monitor_start/stop should be attempted once number of
>>> non-monitor vdevs changes.
>>
>> I am too clear about this. Do you mean that actually we can have
>> monitor mode on non-monitor vdevs in firmware 636?
>
> No. What I mean is we should attempt to start monitor vdev once at
> least 1 non-monitor vdev is present and stop monitor vdev is last
> non-monitor vdev is about to be stopped on 636.
>

Got it. But my investigation on firmware 636 shows that the firmware
crashes even though 1 non-monitor vdev is present. So can we conclude
actually monitor mode is not allowed in firmware 636.

---
Chun-Yeow
