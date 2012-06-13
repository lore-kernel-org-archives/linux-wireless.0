Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59654 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2FMKFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 06:05:09 -0400
Received: by mail-pz0-f52.google.com with SMTP id o14so846449dan.11
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 03:05:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339521048.8774.YahooMailNeo@web192304.mail.sg3.yahoo.com>
References: <1339521048.8774.YahooMailNeo@web192304.mail.sg3.yahoo.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 13 Jun 2012 13:04:53 +0300
Message-ID: <CA+XVXfc06i8woWkwzZvF3yoJyJVSzEJRHRspfv5G4W8tfcay4Q@mail.gmail.com> (sfid-20120613_120514_667968_9E2A85DD)
Subject: Re: TDLS implementation clarifications
To: Dino Joseph Mycle <dinomycle@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 12, 2012 at 8:10 PM, Dino Joseph Mycle <dinomycle@yahoo.com> wrote:
> hello all,
>
>    I want to know more about the TDLS implementation. According to IEEE
> 802.11z(http://standards.ieee.org/news/2011/80211z.html) which is
> incorporated to IEEE 802.11-2012 document. It says that "A TDLS direct link is set up automatically, without need for user
> intervention, while the connection with the AP is maintained". But in the mac80211 we need to configure the peer mac to make it work(using
> wpa_supplicant), so as said by IEEE, without the need for user
> intervention spec is not met right ?

I don't think it necessarily contradicts the spec. The TDLS connection
can be made by a higher layer that gives commands to wpa_supplicant.

I think part of this is because HW limitations. Some devices can only
support a limited number of TDLS peers. So decisions have to be made
about who we want to connect to.

Channel switch is not always supported as well, so if we connect to a
TDLS peer, it might congest the network.

What I'm saying is - policy is not clear cut for TDLS.

Arik
