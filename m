Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:44329 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaCXKQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 06:16:56 -0400
Received: by mail-lb0-f180.google.com with SMTP id 10so3431916lbg.39
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 03:16:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ior37vx1.fsf@kamboji.qca.qualcomm.com>
References: <1395394437-4048-1-git-send-email-janusz.dziedzic@tieto.com>
	<87ior37vx1.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 24 Mar 2014 11:16:54 +0100
Message-ID: <CALhHN=peGOBr3_9zpiE73HMnOd3_WZqo00B+RtvaXSS0OH2MEQ@mail.gmail.com> (sfid-20140324_111659_890469_718C4663)
Subject: Re: [PATCH 1/2] ath10k: introduce rx_status htt template
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 March 2014 11:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Introduce rx_status htt template instead of
>> stack version.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> Why? What's the benefit from doing this?
>
This is the must in case we would like to report rssi + rates correctly.
I describe this in 2/2 - maybe squash them?
Currently during heavy traffic we could have:
> 10 packets with START_VALID - correct RSSI + rates
> 10 packets with END_VALID
> 10 packets with START_VALID - correct RSSI + rates
> 10 packets with END_VALID -
...

Because of that we have to store rssi + rates for case when END_VALID only.
In other case when using monitor we will see:
- 10 packets with correct rssi/rates
- 10 packets with rssi=-95/rate=6Mbps

BR
Janusz
