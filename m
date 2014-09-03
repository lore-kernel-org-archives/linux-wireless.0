Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52972 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaICF5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 01:57:39 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so195678wiv.11
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 22:57:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOHJ0jTHtVvJ43y7m-=UqHeMJfNiMYU2Peg9buxXU+wBigwu5g@mail.gmail.com>
References: <CAOHJ0jTHtVvJ43y7m-=UqHeMJfNiMYU2Peg9buxXU+wBigwu5g@mail.gmail.com>
Date: Wed, 3 Sep 2014 07:57:38 +0200
Message-ID: <CA+BoTQm+x0kD9m3vVv98MwYOXjfgO1noXOnzdbk5o41S+DLewQ@mail.gmail.com> (sfid-20140903_075743_143104_843C4491)
Subject: Re: Cannot get ACS to work with hostapd-2.2 "Unknown event 49"
From: Michal Kazior <michal.kazior@tieto.com>
To: Robb <rbarr138@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 September 2014 20:24, Robb <rbarr138@gmail.com> wrote:
> I am trying to get ACS to work for me but so far have not had
> any luck.  I have tried on both the following kernels:
> 2.6.32-431.20.3.el6.x86_64
> 3.16.1-1.el6.elrepo.x86_64
> on a CentOS 6.5 installation using htc_9271.fw v1.3.
> I would prefer to get it working on the former.
>

> Where should I be looking to determine the source of the
> "Unknown event 49" errors?

This isn't the problem.


> Any suggestions or troubleshooting advice would be greatly
> appreciated.
>
> Thanks.  Info about problem follows:
>
>
> $ lsusb | grep Atheros
> Bus 002 Device 007: ID 0cf3:9271 Atheros Communications, Inc. AR9271 802.11n

The problem is ath9k_htc driver doesn't support dumping survey data.
It doesn't implement .get_survey which implies current ACS
implementation in hostapd will not work.

It is possible to extend hostapd's ACS to support BSS scan only based
backend. This would obviously be less effective than the survey based
one but on the other hand it would work with virtually any driver.
Unfortunately no one has done work on that yet.


Michał
