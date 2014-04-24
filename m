Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:39870 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaDXIxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:25 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so1907119wes.20
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 01:53:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj986fsmUD2kvEN=vjHK32cunyFO+8bH-y7ZoWZAMkcunJ2w@mail.gmail.com>
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQkBCGyKYDaOMgdCi4Yw+SXeuRS+t0rGE8o=8+x2q5N74w@mail.gmail.com>
	<CAEFj986fsmUD2kvEN=vjHK32cunyFO+8bH-y7ZoWZAMkcunJ2w@mail.gmail.com>
Date: Thu, 24 Apr 2014 10:53:24 +0200
Message-ID: <CA+BoTQ=uvkjK-BYJL3gympEiraZupLdh67XzMjuGviQ4iaVuiw@mail.gmail.com> (sfid-20140424_131004_086842_E180125F)
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
From: Michal Kazior <michal.kazior@tieto.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 April 2014 10:50, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> I think Monitor operation should be performed on a best effort basis.
>> This means monitor_start/stop should be attempted once number of
>> non-monitor vdevs changes.
>
> I am too clear about this. Do you mean that actually we can have
> monitor mode on non-monitor vdevs in firmware 636?

No. What I mean is we should attempt to start monitor vdev once at
least 1 non-monitor vdev is present and stop monitor vdev is last
non-monitor vdev is about to be stopped on 636.


Michał
