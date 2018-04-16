Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:39584 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbeDPSpS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 14:45:18 -0400
Received: by mail-wr0-f171.google.com with SMTP id q6so16720570wrd.6
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 11:45:17 -0700 (PDT)
Subject: Re: [PATCH 2/2] mt7601u: run calibration works after finishing
 scanning
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Jakub Kicinski <kubakici@wp.pl>
References: <1523630678-8100-1-git-send-email-sgruszka@redhat.com>
 <1523630678-8100-2-git-send-email-sgruszka@redhat.com>
 <20180413110613.0c13f64f@cakuba.netronome.com>
 <20180414105606.GA9245@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AD4EF3B.30508@broadcom.com> (sfid-20180416_204522_203106_60213E28)
Date: Mon, 16 Apr 2018 20:45:15 +0200
MIME-Version: 1.0
In-Reply-To: <20180414105606.GA9245@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/14/2018 12:56 PM, Stanislaw Gruszka wrote:
> On Fri, Apr 13, 2018 at 11:06:13AM -0700, Jakub Kicinski wrote:
>> >On Fri, 13 Apr 2018 16:44:38 +0200, Stanislaw Gruszka wrote:
>>> > >When finishing scanning we switch to operational channel sill with
>>> > >SCANNING flag. This mean that we never perform calibration works after
>>> > >scanning. To fix the problem cancel and queue calibration works on
>>> > >.sw_scan_start() and .sw_scan_complete() routines.
>>> > >
>>> > >Signed-off-by: Stanislaw Gruszka<sgruszka@redhat.com>
>> >
>> >IOW the stack will potentially ask us to return to the original channel
>> >before calling .sw_scan_complete()?  Hm.  That's unpleasant.
> I think the stack need to assure we start and end scanning on
> operational channel, otherwise we would have possibility to be on
> undefined channel during normal work.

Returning to the operating channels during scanning is mostly important 
when connected so you can receive the beacon of your AP and mc/bc 
traffic and also to handle regular unicast traffic so you are not 
screwing up your TCP window too much for instance.

Regards,
Arend
