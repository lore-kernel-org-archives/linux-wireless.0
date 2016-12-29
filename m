Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34913 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752694AbcL2PHJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 10:07:09 -0500
Received: by mail-io0-f180.google.com with SMTP id n85so120493108ioi.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2016 07:07:08 -0800 (PST)
MIME-Version: 1.0
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 29 Dec 2016 07:07:07 -0800
Message-ID: <CAJ+vNU33Z05DaQGER8KJoPX5g1w=HWjKFDbNs0S0gxKDcFV7bg@mail.gmail.com> (sfid-20161229_160911_547687_7AB8BEF3)
Subject: gpio outputs that disable wireless to PCI Express Mini Card and RFKILL
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

The PCI Express Mini Card (aka Mini PCIe) spec calls out pin 20 as
W_DISABLE# to allow a PCIe host to disable the add-in card's radio
operation and we have run this to a GPIO on our boards for some time.
The M.2 specs also provide such signals. Is there any support in the
Linux RFKILL subsystem to define this?

Looking over the RFKILL subsystem I see support for wireless drivers
to register with rfkill to support on/off/state hooks and support for
gpio based rfkill 'input' switches but I haven't seen anything that
deals with GPIO 'outputs' to add-in card slots. Perhaps support for
this hasn't been deemed necessary because instead software
controllable methods are always used to control rfkill states for the
wireless devices on add-in cards?

Best regards,

Tim

Tim Harvey - Principal Software Engineer
Gateworks Corporation - http://www.gateworks.com/
3026 S. Higuera St. San Luis Obispo CA 93401
805-781-2000
