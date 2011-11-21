Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52340 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1KUNNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 08:13:24 -0500
Received: by iage36 with SMTP id e36so7257162iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 05:13:24 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 17:13:24 +0400
Message-ID: <CAG5dHkSLvG2mbsxGAzQ9SwFrFNwEhiCxTLjn9RvpRQwwsny5+g@mail.gmail.com> (sfid-20111121_141328_183782_F6BD333D)
Subject: [RFC v2 0/8] mesh power saving implementation: indication
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

We have updated our patches and also we would like to add some words
what our work is about.

Based on the latest IEEE 802.11s standard the power saving mechanism
can be divided into the following implementation phases:
* indication of mesh STAs' power modes in frames;
* a buffering and identification sending frames in mesh STA;
* Mesh Awake Window implementation;
* Peer service periods.

This patchset implements the phase of indication of mesh STAs'
power modes in frames. There are two types of mesh power modes:
* peer power mode: a mesh STA indicates its mesh power mode for each
mesh peering and obtains the mesh power modes of its peer mesh STAs;
* non-peer power mode: mesh station also indicates mesh power mode for
non-peer mesh stations. It determines when non-peer mesh STAs may send
Probe Request and Mesh Peering Open Request frames to the mesh STA.

Peer power mode should be indicated with Power Management field in the Frame
Control field and the Mesh Power Save Level field in all transmitted
individually addressed Mesh Data or QoS Null frames on this link.

Non-peer power mode should be indicated with the Power Management
field in the Frame Control field and the Mesh Power Save Level field
in the Mesh Capability field in Beacon and Probe Response frames. A
mesh STA shall also indicate its non-peer mesh power mode with the
Power Management field in the Frame Control field and the Mesh Power
Save Level field in the QoS Control field in group addressed Mesh Data
frames.

We would appreciate comments and advice.

Thanks,
Ivan
