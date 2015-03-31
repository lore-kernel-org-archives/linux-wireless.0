Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37884 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbbCaSo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 14:44:58 -0400
Received: by wiaa2 with SMTP id a2so37523509wia.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 11:44:57 -0700 (PDT)
Received: from [192.168.254.106] ([147.83.206.82])
        by mx.google.com with ESMTPSA id ei8sm22086838wib.10.2015.03.31.11.44.55
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2015 11:44:56 -0700 (PDT)
Message-ID: <551AEB27.1020003@gmail.com> (sfid-20150331_204501_869239_54A5A434)
Date: Tue, 31 Mar 2015 20:44:55 +0200
From: ferran <ranker72@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Fwd: Unable to operate a rt2770 device at 5GHz in mesh mode
References: <551AE9AD.4050102@gmail.com>
In-Reply-To: <551AE9AD.4050102@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello everyone,

I want to build a mesh network at 5GHz with raspberry-pi's connected
each to one rt2770 device.
Following this tutorial [1] I succeed to create a virtual mesh
interface(1), set the channel(2) (let's say 11 by now) and then join a
mesh network(3). I can see the probes with Wireshark, and when more than
one has joined the mesh, I can also see the stats of the peers(4), and
then leave the network (5).

    # 1
    iw dev wlan0 interface add mesh0 type mp

    # 2
    iw dev mesh0 set channel 11

    # 3
    iw dev mesh0 mesh join my_mesh_id

    # 4
    iw dev mesh0 station dump

    # 5
    iw dev mesh0 mesh leave

As I say, everything works at 2.4 channels. However, when setting the
channel to one of the 5GHz band, I receive an error when trying to join
a mesh network. I tested all the channels that the driver claims to
support, and indeed, no 5GHz channel works.

The results of executing the commands above as set(2), join(3), leave(5)
were these:
Channels 1,2,3,…,11 --> regular 2.4 GHz channels

    ## Testing channel 11 ##
       setting channel...
       joining mesh...
       leaving mesh...

Channels 12,13,14 and 36,38,40,44,…,165 --> rare 2.4GHz channels and
regular 5GHz's

    ## Testing channel 165 ##
       setting channel...
       joining mesh...
    command failed: Invalid argument (-22)
       leaving mesh...
    command failed: Transport endpoint is not connected (-107)

Channels 167, 169, 171, 208, 212, 216 --> disabled 5GHz channels or
inexistent channel number

    ## Testing channel 212 ##
       setting channel...
    command failed: Invalid argument (-22)
       joining mesh...
    command failed: Invalid argument (-22)
       leaving mesh...
    command failed: Transport endpoint is not connected (-107)

The output of "iw list" outputs something equivalent to:

  * Channels from 1 to 11

    24ff MHz [c] (20.0 dBm)
    # where "24ff" is the frequency and "c" is the channel

  * Channels 12,13,14 and 36 to 48 and 149 to 165

    ffff MHz [cc] (20.0 dBm) (passive scanning, no IBSS)
    # where "ffff" is the frequency and "cc" is the channel

  * Channels 52 to 165

    5fff MHz [ccc] (20.0 dBm) (passive scanning, no IBSS, radar detection)
    # where "5fff" is the frequency and "ccc" is the channel

  * Channels from 167 to 216

    ffff MHz [ccc] (disabled)
    # where "5fff" is the frequency and "ccc" is the channel

Which matches the three groups of the output of testing the channels
(same results from 12 to 165, radar detection does not affect the output).

Now, my target is to operate this WiFi devices in the 5 GHz band, so I
want to know why I can set the channel to 38, but not join a mesh on
this channel, that is, start to probing and listening the channel. Does
it have anything to do with regulation restrictions? I have succeeded at
connecting to an AP at 5 GHz in managed mode.

I will thank any light you can shed to this.
Thank you very much,

Ferran



