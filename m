Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailbigip.dreamhost.com ([208.97.132.5]:44629 "EHLO
	homiemail-a84.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754664Ab3JCQIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 12:08:42 -0400
Received: from homiemail-a84.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a84.g.dreamhost.com (Postfix) with ESMTP id 2F5C31DE070
	for <linux-wireless@vger.kernel.org>; Thu,  3 Oct 2013 09:08:42 -0700 (PDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com [209.85.220.43])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: erik@erikelmore.com)
	by homiemail-a84.g.dreamhost.com (Postfix) with ESMTPSA id 0E9351DE058
	for <linux-wireless@vger.kernel.org>; Thu,  3 Oct 2013 09:08:41 -0700 (PDT)
Received: by mail-pa0-f43.google.com with SMTP id hz1so2796141pad.30
        for <linux-wireless@vger.kernel.org>; Thu, 03 Oct 2013 09:08:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+=D8wnh59iQfmk8nDjnEZUBHpiZBXFBWwtGu_y_Ldy1b06Jnw@mail.gmail.com>
References: <CA+=D8wmgsBimQhSYDqWbuzwM544YrX1Gj9gsmftQUHoD+QYeZw@mail.gmail.com>
	<CAGRGNgXy37rXWou4sWDfUe+UhpXqxLanhSaH0MPNw_oV+mYbOA@mail.gmail.com>
	<CA+=D8wnh59iQfmk8nDjnEZUBHpiZBXFBWwtGu_y_Ldy1b06Jnw@mail.gmail.com>
Date: Thu, 3 Oct 2013 12:08:41 -0400
Message-ID: <CA+=D8wnkCvHsRiWQ3tfH-ek_MKqOkJTVt8Xv7+CHq1SD4Q5LoQ@mail.gmail.com> (sfid-20131003_180846_462275_66C0F71E)
Subject: Re: Idea: wifi-over-ethernet (bear with me)
From: Erik Elmore <erik@erikelmore.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It occurs to me now that latency in the repeated frames may be causing
problems for me, but I'm not really certain.  I'm not exactly sure how
best to test this idea, yet (needs more thought).  Perhaps I could
have two linux-based devices at either end with debug-level logging
on.

I wonder how these so-called "wifi range extenders" work.  I might
guess they're little more than repeater devices.  I'll need to do some
research to find out whether or not they do any sort of processing of
the frames.  If they do, then they will also need to know the
encryption keys or maybe they'll need to associate with an AP to
function.  If that's the case, then it might not work for my needs.

In the end, my goal is to make it possible for Nintendo 3DS game
consoles to be able to "street pass" over the internet (I know this is
silly, but I have some spare time on my hands right now).  I believe
that process works like ad-hoc networks, except it doesn't use beacons
to advertise and instead uses probe requests to a certain known value.
 I'm guessing that is so the consoles don't appear on lists of
available networks for PC users.  I also believe the session is
encrypted, but I have no insight yet as to how to guess the key.  I
was hoping that a real-time repeater system would be adequate, so I
didn't have to process the frames.

+=
Erik Elmore


On Mon, Sep 30, 2013 at 11:39 PM, Erik Elmore <erik@erikelmore.com> wrote:
> There are a few big ideas, but the one big idea that got me started on
> this line of thought was to make it possible for devices that only
> support ad-hoc networks to function over great distances.
>
> On Mon, Sep 30, 2013 at 8:42 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Erik,
>>
>> On Tue, Oct 1, 2013 at 5:40 AM, Erik Elmore <erik@erikelmore.com> wrote:
>>> Hello, linux-wireless.  I have an idea that I'd like to get some
>>> feedback from you all.  I admit this idea is weird/flawed/broken and
>>> seemingly useless, but I do have a practical application in mind, so
>>> please hear me out.
>>>
>>> Imagine two physical locations, site 1 and 2, that are well outside of
>>> normal wifi range of each other.  Each site has a device that listens
>>> for a subset of wifi frames and then sends them over a distribution
>>> network to its counterpart at the other site.  Each device will also
>>> re-transmit frames received via the distribution network.  Let's call
>>> these devices listener1 and listener2.
>>>
>>> Each site also contains one client device that wants to form an ad-hoc
>>> network with the one in the other site.  Assuming that listener1 and
>>> listener2 are configured to forward frames having a TA belonging to
>>> the client device in their site, is it feasible for these devices to
>>> form an ad-hoc network with the help of the listener devices?
>>
>> Firstly, what's the big plan? - I can't see any useful reason to
>> "tunnel" ad-hoc networks between two points, assuming that you did
>> have all the hardware and software working properly, what is the end
>> goal here, why do you need to have two devices at remote locations
>> form an ad-hoc network with each other? What goal do you have in mind
>> that wouldn't work with a normal managed network?
>>
>> Just so you know, this sort of setup is almost painfully easy to
>> achieve if you use managed networks. - You could simply have a VPN or
>> tunnelling setup of some type between the two access points and have
>> that bridged into the wireless network. This would be 100% transparent
>> as far as clients on the network would be concerned. My previous job
>> had a network that worked somewhat like that with VPNs connecting
>> three offices with WiFi, two data centres and several remote clients
>> into a "single" big network.
>>
>> Thanks,
>>
>> --
>> Julian Calaby
>>
>> Email: julian.calaby@gmail.com
>> Profile: http://www.google.com/profiles/julian.calaby/
>> .Plan: http://sites.google.com/site/juliancalaby/
