Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:61054 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab3J1SAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 14:00:19 -0400
Received: by mail-la0-f53.google.com with SMTP id eo20so5448936lab.26
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 11:00:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526E20EA.9090203@rempel-privat.de>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
Date: Mon, 28 Oct 2013 12:00:17 -0600
Message-ID: <CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com> (sfid-20131028_190032_423389_E4848D8D)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 2:31 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:

> Take wireshark and capture working and not working associational request.

All right, so what I did is take a working and non-working on the same
Linux machine. I have never done that, and didn't find much
information about how to do that so I used kismet.

I don't know exactly how I should export these logs for you to browse
them but I gave a shot at interpreting them.

What I can see is that in both cases the authentication request is
exactly the same, except for the sequence number. Yet in good case
there's an acknowledgement, and in the bad case there isn't.

The authentication response does come back in both cases though, it's
just the acknowledgement that is missing. Unfortunately I cannot
figure out for which message it's the ack.

Also, I notice the sequence number received from the router doesn't
seem to change. All the authentication requests received have the same
number (256). Another peculiar thing is that in the failed case the SN
we send starts with 0.

I suppose since the authentication ack never arrives, the next steps
are never completed.

Does that help?

-- 
Felipe Contreras
