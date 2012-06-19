Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43729 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2FSFsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 01:48:12 -0400
Received: by pbbrp8 with SMTP id rp8so9185548pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 22:48:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340076802.66478.YahooMailNeo@web192503.mail.sg3.yahoo.com>
References: <1339521048.8774.YahooMailNeo@web192304.mail.sg3.yahoo.com>
 <CA+XVXfc06i8woWkwzZvF3yoJyJVSzEJRHRspfv5G4W8tfcay4Q@mail.gmail.com> <1340076802.66478.YahooMailNeo@web192503.mail.sg3.yahoo.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 19 Jun 2012 08:47:56 +0300
Message-ID: <CA+XVXffKkYy1THphz9jnLvW4p4M1J_BUxVEABy0oXsZcMwX8=w@mail.gmail.com> (sfid-20120619_074816_067261_492A8E13)
Subject: Re: TDLS implementation clarifications
To: Dino Joseph Mycle <dinomycle@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 19, 2012 at 6:33 AM, Dino Joseph Mycle <dinomycle@yahoo.com> wrote:
> Hello Arik
>
>   Thanks for the reply.
>
> For the TDLS, what you are saying is the IEEE standard does not talk how it
> can work without user intervention. For using security the user has to
> select the password (key) and it has to be entered, Also the system should
> ask the user whether or not the data has to be transferred through TDLS
> mode.

I'm not sure everything has to reach the user. I'm just saying not
every policy decision has to be made in kernel or wpa_supplicant.

As for the security key - I think it is derived from the key for the
AP network, so no separate key is needed. But you'll have to consult
the spec, my memory is a bit vague about this point.

>
> For the channel switch, if we do , the connection to the AP will get lost
> temporarily right, so if we are sending some data to the AP(say i am
> browsing and want to transfer some huge data to my peer laptop) it will be
> an issue right ?

Well we can get into power-save mode (PSM) vs. the AP, so it can't
send us more data while we are on the other channel. TDLS also has the
concept of PSM, to prevent the other peer from sending data.

Some cards should be able to support multi-channel operation soon, so
these kind of issues will be dealt with.

Arik
