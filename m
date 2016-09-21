Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36330 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbcIUDnO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 23:43:14 -0400
Received: by mail-oi0-f46.google.com with SMTP id t83so45965226oie.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 20:43:13 -0700 (PDT)
MIME-Version: 1.0
From: bruce m beach <brucembeach@gmail.com>
Date: Tue, 20 Sep 2016 20:43:12 -0700
Message-ID: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com> (sfid-20160921_054334_588278_BBCD050E)
Subject: ath9k_htc kernel driver regression affecting throughput
To: linux-wireless@vger.kernel.org
Cc: linux@rempel-privat.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij

I looked at
https://unix.stackexchange.com/questions/122050/
      send-traffic-to-self-over-physical-network-on-ubuntu

It appearred to too complicated but

https://unix.stackexchange.com/questions/122050/
        send-traffic-to-self-over-physical-network-on-ubuntu
with:
    # Create a network namespace and move one of interfaces into it:
      ip netns add test2
      ip link set wlan0 netns test2
    # Start a shell in the new namespace:
       ip netns exec test2 bash
    # Then proceed as if you had two machines. When finished exit the shell and
    # delete the namespace:
       ip netns del test2
Certainly looks interesting but after I got a
 RTNETLINK answers: Invalid argument
I lost interest. My heart isn't in it. I'm still working on the firmware.  I
have started a new tree (tree #3) that consists of a userland firmware uploader
and until recently the following firmware:

app_start( void ) {}

i.e a lable that the code jumps to and nothing else. At this point I have
added VendorCommand(), and a debugger via ep0. ( ep0 is a good choice
since it is available a boot, no matter what) and over the next few
months I am going to move ->all<- the rom code into ram starting with
the USB subsystem.

Bruce
