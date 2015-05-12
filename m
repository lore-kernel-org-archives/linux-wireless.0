Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35257 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbbELKOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 06:14:06 -0400
Received: by wgnd10 with SMTP id d10so997522wgn.2
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2015 03:14:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJa-X945Xvn0jHQVcKn-pyYQVNpxXnqjOH_VHJv8pVwR4kFXcw@mail.gmail.com>
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com>
	<CA+BoTQkFSQe0di1vqqB5cAPKaizRkBT5cu4fA8dQ_uR_a2HdJw@mail.gmail.com>
	<CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com>
	<CA+BoTQ=Qpws=928TZe22Ds-UO_qQJ2Om+=DW=VUNUS59o1BQAA@mail.gmail.com>
	<CAJa-X96KPw6dY0pK1zc8UD4TdQcG0KuA3m6DSueVVyK-VPhn9g@mail.gmail.com>
	<CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com>
	<CAJa-X945Xvn0jHQVcKn-pyYQVNpxXnqjOH_VHJv8pVwR4kFXcw@mail.gmail.com>
Date: Tue, 12 May 2015 12:14:05 +0200
Message-ID: <CA+BoTQmLFGAn2z=E3J1C2qfNP34v57B7-rtALUQhNXrHqJeA6Q@mail.gmail.com> (sfid-20150512_121411_873584_423BF5F4)
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
From: Michal Kazior <michal.kazior@tieto.com>
To: s prasad <sprasad.kandregula@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 May 2015 at 11:31, s prasad <sprasad.kandregula@gmail.com> wrote:
> May I know, is this firmware or driver constraint?
> If somebody have patch for this, am ready to test it.

Short answer: There's nothing, yet.

Long answer:

>From what I know official firmware doesn't support injecting packets
via monitor vdev. This is a firmware limitation.

A way around this may be creating and using an additional vdev, e.g.
AP. This will be rather ugly but may work. There's no patch for it.

An alternative would be to ask Ben to modify his CT-firmware branch.

Also there's a problem with submitting raw 802.11 frames to firmware.
There's some work ongoing [1].

[1]: http://lists.infradead.org/pipermail/ath10k/2015-May/005144.html


Michał
