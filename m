Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51264 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1IPQsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 12:48:52 -0400
Received: by eya28 with SMTP id 28so925480eya.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 09:48:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316177890.4130.27.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com> <1316177890.4130.27.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 16 Sep 2011 19:48:34 +0300
Message-ID: <CA+XVXfeSMANH7Eoq+3XKY57y64szbGrMP6Y5iUgZmn7R11tQ0g@mail.gmail.com> (sfid-20110916_184855_481070_C6461A0E)
Subject: Re: [RFC 0/5] TDLS support for nl80211/mac80211 drivers
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 16, 2011 at 15:58, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
>> This series adds basic kernel-mode TDLS support for nl80211 based drivers.
>> It is based in part on patches by Kalyan C. Gaddam, cc-ed here.
>
> I'm not convinced of the design. I don't see anything in the setup
> frames that will require creating them in the kernel. If they are data
> frames, the supplicant can create them and send them as such, if they
> are public action frames we have nl80211 API for that.

We had some qualms about the design ourselves. This is a question
Kalyan sent to the hostap list a while back -
http://lists.shmoo.com/pipermail/hostap/2011-June/023311.html

The locking requirement (elaborated at the end of the email) was also
part of the decision to make mac80211 more aware of the connection
state. Also, eventually mac80211 will have to add some IEs of it's own
to the setup packets.

>
>> Support is added for peer discovery and data path setup/teardown. More
>> advanced features are not implemented. These include QoS/HT, peer PSM,
>> peer U-APSD and channel switching.
>
> That will certainly require kernel help, but I don't think it requires
> that the setup frames be created in mac80211.

wpa_supplicant needs to add some IEs to the packet (RSN, FTIE, ..).
mac80211 will also have to add some IEs (U-APSD, HT, ...)
Does it really matter if the packet's headers are created by usermode
or by kernel? Even if we change the "owner" of the packet, the API
would still remain about the same. tdls_mgmt would simply get the
frame instead of extra IEs.

Jouni's original wpa_s TDLS code was written for a full-mac driver
where the kernel/firmware side created the packet. wpa_supplicant only
provided auth IEs. Keeping it this way also avoids refactoring the
code and introducing bugs.

>
>> Notably, this patch-set does not include locking in the data path,
>> to switch between AP-based and direct Tx during link setup/tear-down.
>> This will be added by a later patch-set, if/when this series is
>> accepted. In practice it seems to work quite well without additional
>> locking.
>
> That ought to work without locks if you create/destroy the station
> entries appropriately?

I should elaborate on the locking requirement. The TDLS link setup is
made up 3 frames - a setup request, followed by a response from the
peer, and finally a confirm.
This is an excerpt from the spec:

"To avoid possible reordering of MSDUs, a TDLS initiator STA shall
cease transmitting MSDUs to the
TDLS responder STA through the AP after sending a TDLS Setup Request
frame, and a TDLS responder
STA shall cease transmitting MSDUs to the TDLS initiator STA through
the AP after sending a TDLS
Setup Response frame indicating status code 0 (Success)."

This requires a locking mechanism similar to AP-mode buffering for
stations in PS (since we probably don't want to stop all queues).

Arik
