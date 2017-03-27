Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35746 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752109AbdC0Mhr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 08:37:47 -0400
Received: by mail-qt0-f194.google.com with SMTP id r5so7315410qtb.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Mar 2017 05:37:36 -0700 (PDT)
MIME-Version: 1.0
From: Ronald Linders <r.f.a.linders@gmail.com>
Date: Mon, 27 Mar 2017 14:37:30 +0200
Message-ID: <CADGSyv6f=16a+-VE++b5XdKUbm525Cb_4HoG0RMub_ZzL4HCDw@mail.gmail.com> (sfid-20170327_143838_731809_CED4C3C1)
Subject: New type of action frame is not passed on to user space
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Currently I'm working on an implementation of a new draft Wi-Fi
standard, which offers a solution for device authentication. In this
new protocol action frames are specified, similar to those for
peer-to-peer, but with a different OUI type (0x1a). In user space
(nl80211 driver) I have registered this new type of action frame
similar as has been done for peer-to-peer action frames (
nl80211_register_action_frame(bss, (u8 *) "\x04\x09\x50\x6f\x9a\x1a",
6) ).
To let a device sending this new action frame is no problem (seen on a
wifi-sniffer), but on the receiving device no event is generated that
the action frame has arrived.
However, if I only change the OUI type into 0x9, making it a P2P
action frame, the receving device IS generating an event on reception,
Somehow it seems that the kernel driver is discarding my newly defined
action frame (and any other unknown frame for that matter) and
therefore is not passing it to wpa_supplicant although I have
registered the new frame there.
My set-up consists of 2 Nexus 5x smartphones (Android 7.1.1 AOSP)
interacting with eachother via Wi-Fi. These smartphones have a
Qualcomm QAC6174 Wi-Fi chip.

Is someone able to give me a clue how I can instruct the kernel driver
to pass me the new action frame type to user space on arrival?
Any help is highly appreciated.

With kind regards,
Ronald Linders
