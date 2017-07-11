Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:36320 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932580AbdGKI6M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 04:58:12 -0400
Received: by mail-wr0-f172.google.com with SMTP id c11so173870033wrc.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 01:58:12 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: added LED triggers for transmit/receive
To: Russell Joyce <russell.joyce@york.ac.uk>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Alan Millard <alan.millard@york.ac.uk>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        James Hughes <james.hughes@raspberrypi.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com,
        Network Development <netdev@vger.kernel.org>
References: <20170707140941.122115-1-russell.joyce@york.ac.uk>
 <CACna6rzY84oWNMBfP8N4A=Sxst_8b-S+rTbZFQV0yFcOR5MceQ@mail.gmail.com>
 <B8983FA2-39CE-478B-80C9-F32E01856FE9@york.ac.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <60de1301-b4a3-95a7-117f-a953576655d9@broadcom.com> (sfid-20170711_105828_317408_359B97EE)
Date: Tue, 11 Jul 2017 10:58:03 +0200
MIME-Version: 1.0
In-Reply-To: <B8983FA2-39CE-478B-80C9-F32E01856FE9@york.ac.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-07-17 19:02, Russell Joyce wrote:
>> 1) I think most of it should be some cfg80211 shareable code.
> 
> I’m not sure exactly what you mean by this, could you please clarify?

What I think Rafał is saying is that it would be better to have this
code in cfg80211 so other drivers including mac80211 could use it.

>> 2) This "rxtx" while surely present in other places sounds like a
>> workaround for LED subsystem limitation. Maybe it's time to finally
>> rework LED triggers.
> 
> I agree that it’s not an ideal way to do things, but I couldn’t think of a
> better alternative. I think that having a combined trigger is useful though, for
> situations like using the single LED on a Raspberry Pi to show Wi-Fi activity.

Indeed. However, the LED subsystem could/should(?) take care of mapping
"rx" and "tx" triggers to the same LED.

I am happy to comment on your patch, but maybe you can first take a look
at the suggestion Rafał made above.

Regards,
Arend
