Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:11364 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZAKPsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 10:48:39 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3760467fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2009 07:48:37 -0800 (PST)
Message-ID: <3ace41890901110748k474e99a9n7ceddf6bb263de99@mail.gmail.com> (sfid-20090111_164843_717893_CAF62474)
Date: Sun, 11 Jan 2009 15:48:37 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Ari Entlich" <lmage11@twcny.rr.com>
Subject: Re: Help debugging unexpected disassociations?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1231649926.21931.5.camel@g4mdd.entnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20090110021351.MHLV4.64591.root@hrndva-web24-z02>
	 <3ace41890901100516mc2e1ee1h42c4f67b552f7d73@mail.gmail.com>
	 <1231649926.21931.5.camel@g4mdd.entnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 11, 2009 at 4:58 AM, Ari Entlich <lmage11@twcny.rr.com> wrote:
<snipped>
> Given that the version I'm using *CAN* authenticate, it doesn't
> immediately make sense to me why wpa_supplicant would be causing this
> problem, unless wpa_supplicant is intentionally trying to screw me up by
> deauthenticating me. I will try updating, but would you please try a
> little harder to hide the fact that you consider me a retard for no
> reason next time? Thanks.

You have been told by my first reply to look at wpa_supplicant, and
again to upgrade.
Why do you insist that you *know it better*, when you are asking for help?

1) there is a newer version of wpa_supplicant in the same series, (and
even a newer series), there is a reason for it. Look it up, upgrade,
and look at the logs, and come back with the logs, *before* you write
again.

2) if I have to spell it out for you, yes, I think you are exactly
right, wpa_supplicant (or the older version of it) is screwing with
you. wpa_supplicant monitors the state of your connectivity
continuously, and it is responsible for authentication *and
reauthentication*. If it detects, or *mis-detects* that your access
point is not working right, it will drop your connection,
deauthenticate and reauthenticate, and f*ck your wireless connectivity

You do not understand that how wpa_supplicant works, and refuse to
listen. wpa_supplicant does not just do one-off authenticate, it also
*reauthenticate* from time to time when necessary, and continuously
monitors and changes the states of communication between your wireless
client and the access point.
