Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:3904 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYCEPth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 10:49:37 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1726053wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 07:49:32 -0800 (PST)
Message-ID: <1ba2fa240803050749j8bb291ajb8a0451504a0b905@mail.gmail.com> (sfid-20080305_154943_829715_CE1B9885)
Date: Wed, 5 Mar 2008 17:49:30 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: iwl3945 associated and _worked_ with a *wrong* essid!
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47CE8ED6.7030302@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47CE8ED6.7030302@aitel.hist.no>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 5, 2008 at 2:15 PM, Helge Hafting
<helge.hafting@aitel.hist.no> wrote:
> I recently wrote about my iwl3945 problems - I usually
>  have to try 20-50 times before I can use a wep-encrypted access point.
>  Once the link goes up - no more problems. But getting the first
>  connection takes time.
>
>  Yesterday something weird happened.
>  I run the same iwconfig command over and over. Then a wild guess:
>  Perhaps the driver or linux is clever enough to see that I
>  just set the same essid and key as last time, and optimize the
>  operation away completely? I have no idea if this actually happens,
>  but I changed the essid (added a few garbage characters)
>  in order to force a difference. I was about to run iwconfig again
>  with the correct essid, when I noticed that the link was up!
>
>  An "iwconfig" without parameters showed that the PC indeed
>  had associated to the usual access point, and the essid was wrong one
>  indeed.
>  I then ran "dhclient", got an IP address, and used my home network
>  for a few hours. No problems, but the essid was wrong all the time.
>
>  I thought this ought to be impossible - so I can only guess that
>  the essid is stored in several places - one place used by "iwconfig"
>  to display the current essid, and somewhere else used to program
>  the radio. And the latter place is not necessarily updated when
>  "iwconfig essid <something>" is run - and therefore the link
>  worked anyway. This could possibly explain why things fail
>  so much - perhaps the essid is set correctly only occationally?
>
>  Kernel: 2.6.25-rc3, SMP 64-bit. Other sw from debian testing.
>
>  Helge Hafting

I've seen some problems with avahi-daemon intercepting wrong SSID
during association
I didn't root caused the problem yet. I'm using Fedora 8 now.

When I've commented the auto selection out
(IEEE80211_STA_AUTO_SSID_SEL) it performed better

Yet I also didin't root caused the problem yet.


>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
