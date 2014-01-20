Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40092 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaATSsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 13:48:45 -0500
Received: by mail-lb0-f173.google.com with SMTP id y6so5175239lbh.4
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 10:48:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8738kilhbx.fsf@kamboji.qca.qualcomm.com>
References: <1390234821-4405-1-git-send-email-janusz.dziedzic@tieto.com>
	<8738kilhbx.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 20 Jan 2014 19:48:44 +0100
Message-ID: <CALhHN=pTEBd5P-weZSxSou3gQmb=wE4fAHTECU6oJ1PSMvfWoQ@mail.gmail.com> (sfid-20140120_194848_664578_A3E5C0B0)
Subject: Re: [PATCH] ath10k: AP mode, set UAPSD params correctly
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 January 2014 17:59, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Move UAPSD params settings after peer assoc
>> command. This is required to setup UAPSD
>> params correctly.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> This is a pretty vague description. What is correct today can be totally
> wrong tomorrow :)
>
> So I would prefer that you describe a bit more about this change. At
> least describe the bug you are fixing (or mention the motivation behind
> the change).

ath10k handles UAPSD completly in the firmware.
When works in AP mode we have to configure
UAPSD params for each station. Without this
patch we configure UAPSD params before we
send peer assoc command to the FW, which was
wrong. Next FW didn't know what should be trigger
frame, couse UAPSD didn't work correctly in AP mode.
To configure UAPSD params correctly we have to
send them after peer assoc command.


BR
Janusz
