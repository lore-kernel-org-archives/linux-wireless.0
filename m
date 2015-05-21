Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:34777 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbbEURcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 13:32:50 -0400
Received: by laat2 with SMTP id t2so107831058laa.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 10:32:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555E14D1.30008@rempel-privat.de>
References: <CANvVAoyhGCLL7ajGFH91xgNBMZd2kd5P-9v3_PaE+xdmEYYkpQ@mail.gmail.com>
	<555E14D1.30008@rempel-privat.de>
Date: Thu, 21 May 2015 10:32:48 -0700
Message-ID: <CAAnMG+Maom0VOkj0YgQp_u-z8+YM7YUr7uOjZTPHAf_kpjC_Rw@mail.gmail.com> (sfid-20150521_193253_401200_C41A5857)
Subject: Re: Issues with mesh networking path detection
From: Alexis Green <agreen@cococorp.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Jason Scatena <jscatena88@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep in mind that mpath table is going to empty unless you try to
reach another node. Assuming your routing is correct, pinging from one
node to another should initiate ARP request, which will cause path
requests to go out and, ultimately, add entries to mpath table. I
didn't see any mention of attempting to send data packets across the
mesh, so that might be the only problem.

On Thu, May 21, 2015 at 10:24 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 21.05.2015 um 19:11 schrieb Jason Scatena:
>> Hello all,
>>
>> I am attempting to set up a mesh network between 4 computers with
>> Atheros 9271 based usb wifi dongles using the ath9k driver.
>>
>> I followed the guide at: https://github.com/o11s/open80211s/wiki/HOWTO
>>
>> to set up the network.
>>
>> When I get all of the computers up and configured they all see each other.
>> The command "iw dev mesh station dump" shows all the nodes in the
>> area. However the path selection doesn't seem to work at all. For
>> instance the command "iw dev mesh mpath dump" returns nothing. However
>> if I manually add arp entries using the arp command they show up in
>> the mpath dump.
>>
>> I am willing to do whatever to troubleshoot however there is very
>> little documentation that I have been able to find on trouble shooting
>> these issues. I would also be able to provide a pcap file of the nodes
>> coming online.
>>
>> I'm new to the wireless world but have C coding experience and would
>> be willing to put in the time to learn.
>
>
> Hi,
>
> i don't think there are people who will know the answer without research
> and reading the code.
>
> Since you are willing to learn any way, fallow the codepath and find out
> what is happening. We would be happy to have more wifi experts :)
>
> Find out what executed in kernel if you start this command: "iw dev mesh
> mpath dump". I assume it is starting somewhere in linux/net/wireless/mesh.c
>
> Use printk() placed in code or use gdb+openocd+jtag if you use some arm
> or mips system.
>
>
>> Best,
>> Jason Scatena
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Regards,
> Oleksij
>
