Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.natecarlson.com ([74.117.236.15]:53647 "EHLO
	plesk.technicality.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750803AbaIDPDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 11:03:07 -0400
Date: Thu, 4 Sep 2014 10:02:53 -0500 (CDT)
From: Nate Carlson <linux-wireless@natecarlson.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANN] new experimental firmware for 7260 / 3160 / 7265 - Core7
In-Reply-To: <CANUX_P2ZqEo4pcVxcB1GHzaG8Fc3NqgBdr3Se8aGq+DXZPMLqQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1409040956540.25615@admin.chi.technicality.org> (sfid-20140904_170327_632847_CE234FCB)
References: <CANUX_P1udm36NoF-dbOARa671VthuYfrEEz2ODSmkCgDzcRe8g@mail.gmail.com> <alpine.DEB.2.02.1409031720280.17274@admin.chi.technicality.org> <CANUX_P2ZqEo4pcVxcB1GHzaG8Fc3NqgBdr3Se8aGq+DXZPMLqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[responding to both messages at once here]

On Thu, 4 Sep 2014, Emmanuel Grumbach wrote:
> If you want, you can apply this:
<..>
> You'll need the firmware attached, and load the driver with 
> fw_monitor=1. Then, when the error you mentioned will occur, it will 
> crash the firmware on purpose so that we can get the logs. You'll see 
> lots of junk in dmesg.
>
> Once this happened, you can take the data from 
> /sys/kernel/debug/iwlwifi/0000\:01\:00.0/iwlmvm/fw_error_dump. This will 
> weigh around 4MB depending on the available memory in your system, this 
> is the data I need to give to the firmware team.

I will give this a try later on -- I'm testing this on my real laptop, and 
am in the middle of a project, so can't reboot at the moment (I love Linux 
- if a driver pukes, just reload it and reconnect, no need to reboot!)

> I just saw something weird...
>
> The Q 16 is still working while we flush:
<...>
> can you please re-run with trace-cmd -e iwlwifi -iwlwifi_msg -e
> mac80211 and send the trace.dat output.

Sure! I'm new to this; did a bit of RTFM'ing, and I'm guessing that the 
command should actually be:

trace-cmd record -e iwlwifi -e iwlwifi_msg -e mac80211

..and that I should wait until the issue occurs again with this running, 
and then hit ctrl-c, gpg-encrypt the trace.dat and send it to you?  (Or 
should I open a bugzilla and attach the encrypted file there?)

If any of that's incorrect, let me know.

The issue did already happen again today - unfortunately I hadn't gotten 
to firing up the trace-cmd yet.. so hopefully it'll happen again.  :)

Thanks!

-Nate
