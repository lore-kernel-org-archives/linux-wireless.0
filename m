Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:33169 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdFNJOs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 05:14:48 -0400
Received: by mail-wr0-f180.google.com with SMTP id v104so169309537wrb.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2017 02:14:48 -0700 (PDT)
Subject: Re: [PATCH V3 3/9] nl80211: add authorized flag to CONNECT event
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
 <1497010130-16186-4-git-send-email-arend.vanspriel@broadcom.com>
 <1497344524.6068.5.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6e0ab1a9-04c3-6840-bab2-119624087e21@broadcom.com> (sfid-20170614_111455_093482_9E9680A8)
Date: Wed, 14 Jun 2017 11:14:44 +0200
MIME-Version: 1.0
In-Reply-To: <1497344524.6068.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 6/13/2017 11:02 AM, Johannes Berg wrote:
> On Fri, 2017-06-09 at 13:08 +0100, Arend van Spriel wrote:
>> When the driver supports offloading of the PTK/GTK handshakes
>> completion of that during connect changes the layer 2 control
>> port state to authorized. This patch allows the driver to pass
>> that state in cfg80211_connect_done() resulting in adding the
>> new flag NL80211_ATTR_PORT_AUTHORIZED in the NL80211_CMD_CONNECT
>> notification. For 802.1X the driver is expected to issue the
>> NL80211_CMD_CONNECT notification twice. First without the new
>> attribute to inform user-space that 802.1X authentication can
>> start and a second one with the new attribute to indicate the
>> completion of the handshakes.
> 
> So I was going to apply this, but now I'm no longer sure.

Not sure if this means you can be convinced, but let me try anyway ;-)

> First of all, I'm concerned it could confuse older tools that don't
> expect to see the notification twice. OTOH, they'd get the connected
> notification now and not really know whether or not data can be passed,
> so it seems unlikely they'd rely on it - but are we really sure about
> that?

Not sure what should be considered under the term "older tools". For 
what it is worth, in wpa_supplicant both nl80211 CONNECT and ROAMED 
event result in wpa_supplicant ASSOC event handled in 
wpa_supplicant/events.c. This event already deals with authorized flag 
to support QCA vendor stuff which typed it as u8 attribute iso flag.

> Additionally, I just discussed this with Avi, and it's not clear to us
> what the second notification is actually useful for? If you were going
> to say maybe it makes sense for when you can't send ROAMED, but still
> connected again to the same network so you've already done the 4-way-HS
> at the time of the first notification - that I think makes sense.
> 
> But it seems that wpa_s moves all state machines to COMPLETE when it
> sends the PMK to the device for offload, so it won't really care about
> when that finished?
> 
> However, I think this might actually be a BAD thing, because it would
> leave higher layers trying to do DHCP when the link isn't actually
> ready yet.

Indeed. It introduces a window where the link is not ready. When I 
stumbled on that in wpa_s it made sense to me to have the second 
notification.

> (This, btw, is another problem we can solve with the EAPOL-over-nl80211
> since then we can set the carrier later when the port is authorized.)

Agree. I did see that thread. However I kinda missed the whole 
EAPOL-over-nl80211 idea. Was that result of summit discussion?

> So - I have no objections to this patch, but I think the double
> notification needs to be revised, and if needed a separate notification
> for "4-way-HS is done now" can be added.

The separate notification was suggested, but as you guys already added a 
flag in the ROAMED event we decided to do the same for CONNECT event. If 
you still have concerns about the double CONNECT we can revisit that or 
leave it for now and deal with it through carrier state with 
EAPOL-over-nl80211.

Regards,
Arend
