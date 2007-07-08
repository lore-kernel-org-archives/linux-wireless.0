Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:5766 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbXGHSml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 14:42:41 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1099551wah
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2007 11:42:41 -0700 (PDT)
Message-ID: <9e4733910707081142t43a85fb1y383ee8e1835c2842@mail.gmail.com>
Date: Sun, 8 Jul 2007 14:42:41 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Andy Green" <andy@warmcat.com>
Subject: Re: Arrested Development
Cc: "Ulrich Kunitz" <kune@deine-taler.de>,
	"Daniel Drake" <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <46910F3F.8010201@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org>
	 <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de>
	 <46910F3F.8010201@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/8/07, Andy Green <andy@warmcat.com> wrote:
> I rebooted into the new kernel and did this only
>
> # iwconfig wlan0 mode monitor
> # ifconfig wlan0 up
> # iwconfig wlan0 channel 6
> # tcpdump -i wlan0
>
> But all I could see were beacons, this is despite I am ssh-d into that
> box over the same channel 6 network with WPA and should surely be seeing
> the encrypted packets?

I have been down the same path, tcpdump shows the encrypted packets,
but they aren't visible in Wireshark. I could only see directed
packets and broadcast ones. What fixed for me was rm -rf .wireshark in
/root.

-- 
Jon Smirl
jonsmirl@gmail.com
