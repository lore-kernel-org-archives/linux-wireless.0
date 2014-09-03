Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44604 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbaICNYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:24:45 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so9800089wid.7
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 06:24:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOHJ0jSoSd97vFEMgxC3cC8AnaEGdwbUiBBoeM7UfLJcha0Ujg@mail.gmail.com>
References: <CAOHJ0jTHtVvJ43y7m-=UqHeMJfNiMYU2Peg9buxXU+wBigwu5g@mail.gmail.com>
	<CA+BoTQm+x0kD9m3vVv98MwYOXjfgO1noXOnzdbk5o41S+DLewQ@mail.gmail.com>
	<CAOHJ0jSoSd97vFEMgxC3cC8AnaEGdwbUiBBoeM7UfLJcha0Ujg@mail.gmail.com>
Date: Wed, 3 Sep 2014 15:24:44 +0200
Message-ID: <CA+BoTQnCoZL=GzUh4vJqOQ=-PZ1BwZcUO21spUPB5KF1fUSiRw@mail.gmail.com> (sfid-20140903_152449_358906_701720D9)
Subject: Re: Cannot get ACS to work with hostapd-2.2 "Unknown event 49"
From: Michal Kazior <michal.kazior@tieto.com>
To: Robb <rbarr138@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 September 2014 15:10, Robb <rbarr138@gmail.com> wrote:
>> The problem is ath9k_htc driver doesn't support dumping survey data.
>> It doesn't implement .get_survey which implies current ACS
>> implementation in hostapd will not work.
>
> I see, driver support != chipset support.  According to
> http://wireless.kernel.org/en/users/Documentation/acs#Hostapd_setup
> the driver does support it, but it is correct that it does not say all
> chipsets supported by that driver support ACS.

You are making an assumption ath9k == ath9k_htc. This is not correct.

I would actually suspect the ath9k_htc *chips* actually are capable of
providing the necessary information to create survey dump but the
firmware/driver do not support it. Can anyone more familiar with
ath9k_htc correct me if I'm wrong?


> If the 9271 doesn't support it then I guess it can only be the
> AR7010+AR9280 or AR7010+AR9287 right? Any way to know which works?

Neither will work as either is handled by the ath9k_htc driver which
in turn does not support survey data.


Michał
