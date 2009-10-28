Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:34638 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbZJ1PCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 11:02:41 -0400
Received: by iwn10 with SMTP id 10so623952iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2009 08:02:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256741651.4237.112.camel@johannes.local>
References: <86201b3f0910271340t51aa6c0bgff43e6e7211a0dee@mail.gmail.com>
	 <1256676190.4237.27.camel@johannes.local>
	 <86201b3f0910280747q557a6153oec929e8235459c8f@mail.gmail.com>
	 <1256741651.4237.112.camel@johannes.local>
Date: Wed, 28 Oct 2009 11:02:44 -0400
Message-ID: <86201b3f0910280802r279bf0d8q3424245ddfb1f8a8@mail.gmail.com>
Subject: Re: iwlist wlan0 scan disrupts communications
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2009 at 10:54 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-10-28 at 10:47 -0400, Charles Gordon wrote:
>
>> Thanks for the information.  After doing some more testing I found
>> that the association to the AP is sometimes lost and that mac80211
>> does not recover automatically.  You have to type the command "wpa_cli
>> reassociate" to trigger the stack to reassociate with the AP.  Is this
>> one of the things that is, or will be, fixed in later releases?
>
> I don't know. Normally, wpa_supplicant should notice this and re-connect
> by itself.
>
> johannes
>
I think the way wpa_supplicant would notice this is that the AP would
send a deauthentication or dissassociation frame to the station, and
that would trigger wpa_supplicant to reassociate.  However, if we are
tuned to a different channel when the frame is sent, then we won't
receive it.  The AP won't send another notification unless we try to
send it another data frame, but if another station is trying to send
to us, we won't be notified.

I think that when the scan completes, mac80211 should either notify
wpa_supplicant that it should reassociate, or maybe send a null-data
frame to the AP which might cause it to send another
deauthentication/dissassociation frame (if we lost the connect).
