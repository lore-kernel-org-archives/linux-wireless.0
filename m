Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44729 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0JZRPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 13:15:05 -0400
Received: by yxn35 with SMTP id 35so3050708yxn.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 10:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Qs8tQyNQQik8unFd5NUf2LW2UFowMJ0yjTr0b@mail.gmail.com>
References: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com>
 <1287995967.3587.9.camel@jlt3.sipsolutions.net> <AANLkTik-SaE2ShV7H6Lv1qFQ-FM5fPuWGws6pWM+b6Go@mail.gmail.com>
 <AANLkTik12g6kmynbgyhPuu+B5jZ9Swv+1PhAg9EKMByw@mail.gmail.com> <AANLkTi=Qs8tQyNQQik8unFd5NUf2LW2UFowMJ0yjTr0b@mail.gmail.com>
From: "Cassiano Tartari, Eng." <falecom@cassianotartari.eng.br>
Date: Tue, 26 Oct 2010 15:14:43 -0200
Message-ID: <AANLkTimt8yX6NTsLdwaWuOZifhN5hDnQkH+FBsPr50+Z@mail.gmail.com>
Subject: Re: Modifying the driver iwlwifi
To: Blaise Gassend <blaise@willowgarage.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 25, 2010 at 5:31 PM, Blaise Gassend <blaise@willowgarage.com> wrote:
>
> > How can I know if a AP is "compliant/certified" ? I'm such a newbie.
>
> I suspect that most of them are. If they have a WiFi logo on the box
> they should be:
> http://www.wi-fiplanet.com/tutorials/article.php/2203361/Wi-Fi-Interoperability-Compliance-Steps.htm
>
> >> I had a look at the paper, and the original poster seems to have
> >> exaggerated the paper's claims. They do indeed do the authentication
> >> and association request before getting responses. For everything else,
> >> they wait to get the response for the previous stage. The main
> >> difference is that they greatly reduce the timeouts before retrying at
> >> each stage. The paper is also limited to non-encrypted networks.
> >
> > My objetive in my current job is just that, reduce the time of authentication.
> >
> > Someone has a better idea or solution to reduce the association time?
> > I need to use DHCP and could be a open network.
>
> How short does it need to be for you? In my experience sub-second is
> pretty if you know the frequency, have low packet loss, and have an
> aggressive DHCP client. The methods in the paper should make it work
> even with higher packet loss.

what is a "agressive DHCP client" ? I saw in the manual, there a lot
of telnet commans for DHCP

I tryed:
sudo iwconfig wlan0 mode managed freq 2.437G rate 1M frag 256 key open
essid 'cassiano-PC_AP'

But when I try to run:
sudo dhclient wlan0

return: "No DHCPOFFERS received"

And I need to do this because my code will connect automatic. Using
the networkManager (ubuntu) the connection appears to occur fast.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
