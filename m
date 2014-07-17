Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36153 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaGQFPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 01:15:09 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so2388608wiw.6
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 22:15:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53C69A32.3090305@candelatech.com>
References: <1405516873-26411-1-git-send-email-michal.kazior@tieto.com>
	<1405516873-26411-2-git-send-email-michal.kazior@tieto.com>
	<53C69A32.3090305@candelatech.com>
Date: Thu, 17 Jul 2014 07:15:07 +0200
Message-ID: <CA+BoTQ=X6GZLYmztehWp=gi6JHWZAJrOnvtB-HjbTqGfwUR4eA@mail.gmail.com> (sfid-20140717_071524_226531_F23FF3F2)
Subject: Re: [RFC/RFT 2/2] ath10k: don't start monitor vdev for promisc
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Vu Hai NGUYEN <vh.nguyen@actiasodielec.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 July 2014 17:28, Ben Greear <greearb@candelatech.com> wrote:
> On 07/16/2014 06:21 AM, Michal Kazior wrote:
>>
>> ath10k doesn't apply any extra rx filters so
>> there's no need to start monitor vdev for
>> promiscuous mode.
>>
>> This fixes crashes with 4addr station interface
>> bridging and some very rare crashes of AP
>> interfaces with bridging as well.
>
>
> Ahh, I was just working on some related hack-arounds to make sure
> I left a vdev slot open for the monitor interface in case some poor
> person started a sniffer on an interface and made it go promisc...
>
> With this patch, I can be sure monitor interfaces will not
> be automatically created without explicit user request?

I'm not sure if I understand you correctly, but:

With this patch monitor vdev will be created and started only if there
is at least one monitor interface up and running or CAC is in
progress. Promiscuous mode does not change driver state at all. IOW if
you start tcpdump on a wlan0 (station iftype) or add wlan0 (ap iftype,
sta iftype) to a bridge then monitor vdev will not be created. You
have to iw wlan0 interface add mon type monitor && ip link set mon up
to start monitor vdev. From then on you can tcpdump or tcpdump -p on
mon to sniff everything that the card sees on the air.


> Any idea if it will be a problem to apply this to what is
> effectively a 3.15 kernel?

Hmm.. I guess it should apply. This depends on some earlier monitor
clean up patches but I can't remember when those were merged.


Michał
