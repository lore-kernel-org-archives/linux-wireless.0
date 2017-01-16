Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:32959 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdAPL1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 06:27:03 -0500
Received: by mail-ot0-f171.google.com with SMTP id 73so42926384otj.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 03:27:02 -0800 (PST)
MIME-Version: 1.0
From: Matteo Grandi <iu5bdp@gmail.com>
Date: Mon, 16 Jan 2017 12:26:21 +0100
Message-ID: <CAHdg3xY4C1-fzARxfrtjCjz+x+U+fT=wa0FSMNGzwWywqZwV5A@mail.gmail.com> (sfid-20170116_122707_090050_5852FCEF)
Subject: wpa_supplicant mesh mode issue
To: LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm trying to set-up a mesh network using wpa-supplicant (already did
using iw and works fine) because I would like to implement security.
I followed the guide
https://wireless.wiki.kernel.org/en/users/drivers/ath10k/mesh?s[]=mesh&s[]=point
but I bump into some issues:

- when I set the parameter user_mpm=1 in the wpa_supplicant.conf file,
I have the llid and plid both set to 0 and the mesh points aren't able
to ping each other.
- Setting the parameter user_mpm=0 the peers can ping each other.
- If I implement the security I fall back to the same llid/plid=0 issue.

So it seems thet have user_mpm=1 and/or security implementation allows
to build the mesh, but it's impossible to ping and transmit on it.
Using user_mpm=0 allows the proper work of the mesh but only id
security is NOT used.

Is it ok to have llid/plid=0 when security is implemented or user_mpm=1?
Is someone already had this issue?

I'll be grateful for every hint!
Here my configuration file and the station dump:

With secure MP and user_mpm=0 or 1:

# Basic Mesh Point configuration on channel 36
ctrl_interface=/var/run/wpa_supplicant
user_mpm=0
network={
        ssid="ath10k36"
        mode=5
        frequency= 5180

        #SECURITY MANAGEMENT
        #key_mgmt=NONE
        key_mgmt=SAE
        psk="i2cati2cati2cat"
        ieee80211w=1
}


Station 04:f0:21:22:91:81 (on m36p)
    inactive time:    160 ms
    rx bytes:    354494
    rx packets:    4146
    tx bytes:    1074
    tx packets:    8
    tx retries:    0
    tx failed:    0
    rx drop misc:    1
    signal:      -40 dBm
    signal avg:    -40 dBm
    tx bitrate:    6.0 MBit/s
    rx bitrate:    6.0 MBit/s
    mesh llid:    0
    mesh plid:    0
    mesh plink:    ESTAB
    mesh local PS mode:    ACTIVE
    mesh peer PS mode:    UNKNOWN
    mesh non-peer PS mode:    ACTIVE
    authorized:    no
    authenticated:    yes
    associated:    no
    preamble:    long
    WMM/WME:    yes
    MFP:        yes
    TDLS peer:    no
    DTIM period:    2
    beacon interval:1000
    connected time:    2146 seconds

Station 04:f0:21:22:91:88 (on m36h)
    inactive time:    600 ms
    rx bytes:    434903
    rx packets:    5080
    tx bytes:    754
    tx packets:    5
    tx retries:    0
    tx failed:    0
    rx drop misc:    8
    signal:      -41 dBm
    signal avg:    -41 dBm
    Toffset:    2666496059 us
    tx bitrate:    6.0 MBit/s
    rx bitrate:    6.0 MBit/s
    mesh llid:    0
    mesh plid:    0
    mesh plink:    ESTAB
    mesh local PS mode:    ACTIVE
    mesh peer PS mode:    UNKNOWN
    mesh non-peer PS mode:    ACTIVE
    authorized:    no
    authenticated:    yes
    associated:    no
    preamble:    long
    WMM/WME:    yes
    MFP:        yes
    TDLS peer:    no
    DTIM period:    2
    beacon interval:1000
    connected time:    2620 seconds

Without secure MP and user_mpm=0

# Basic Mesh Point configuration on channel 36
ctrl_interface=/var/run/wpa_supplicant
user_mpm=0
network={
        ssid="ath10k36"
        mode=5
        frequency= 5180

        #SECURITY MANAGEMENT
        key_mgmt=NONE
        #key_mgmt=SAE
        #psk="i2cati2cati2cat"
        #ieee80211w=1
}

Station 04:f0:21:22:91:81 (on m36)
    inactive time:    940 ms
    rx bytes:    1882
    rx packets:    24
    tx bytes:    308
    tx packets:    3
    tx retries:    0
    tx failed:    0
    rx drop misc:    2
    signal:      -39 dBm
    signal avg:    -39 dBm
    tx bitrate:    6.0 MBit/s
    rx bitrate:    6.0 MBit/s
    mesh llid:    36778
    mesh plid:    44382
    mesh plink:    ESTAB
    mesh local PS mode:    ACTIVE
    mesh peer PS mode:    UNKNOWN
    mesh non-peer PS mode:    ACTIVE
    authorized:    yes
    authenticated:    yes
    associated:    yes
    preamble:    long
    WMM/WME:    yes
    MFP:        no
    TDLS peer:    no
    DTIM period:    2
    beacon interval:1000
    short slot time:yes
    connected time:    11 seconds

Thanks a lot

Best Regards

Matteo
