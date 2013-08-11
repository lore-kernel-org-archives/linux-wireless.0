Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:56548 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3HKUTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Aug 2013 16:19:50 -0400
Received: by mail-lb0-f175.google.com with SMTP id 13so4311131lba.20
        for <linux-wireless@vger.kernel.org>; Sun, 11 Aug 2013 13:19:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJWpbEg74C7DYbDkWCpNJRte7X7+40UHgNAL7uWLFHJ64CApKw@mail.gmail.com>
References: <1375968116-24331-1-git-send-email-ja@anyfi.net>
	<1376053671.8355.4.camel@jlt4.sipsolutions.net>
	<CAJWpbEg74C7DYbDkWCpNJRte7X7+40UHgNAL7uWLFHJ64CApKw@mail.gmail.com>
Date: Sun, 11 Aug 2013 22:19:48 +0200
Message-ID: <CAJWpbEjdHR0HJjPBwSPN0m4kabLWbfV5pWec+9cwbvyWD+AOgg@mail.gmail.com> (sfid-20130811_222016_502283_16A6E466)
Subject: Re: [RFC] mac80211: add support for split-MAC implementations
From: Johan Almbladh <ja@anyfi.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would prefer my original solution that puts the decryption handler
after the sta_process handler. The code is cleaner since we avoid the
extra flag and the coupling between decrypt and sta_process. My
conclusion is that the change is correct, see below.

ieee80211_rx_h_check_more_data, ieee80211_rx_h_uapsd_and_pspoll:
The MOREDATA and PM bits are not protected by the encryption MIC. It
should be valid to process those bits regardless of the decryption
outcome.

ieee80211_rx_h_sta_process:
The updating of last_rx for an IBSS STA is conditional on the STA
being AUTHORIZED. That state is the same regardless of whether the
updating is done before or after decryption.

The main argument that the MOREDATA and PM bits are not protected by
the encryption and are therefore independent. You can always send a
spoofed NULLFUNC frame to an RSN AP or STA and have the PM and
MOREDATA bits processed accordingly. My change allows data frames that
could not be decrypted to be processed similar to NULLFUNC frames.

I have run mac80211 in STA and AP mode with this change for quite some
time now without any problems. I will run it in IBSS mode also as you
suggest.

Provided that my IBSS tests pass, should I send you a final patch that
changes the RX handler order and their locations in the file?

Johan

On Sat, Aug 10, 2013 at 1:31 PM, Johan Almbladh <ja@anyfi.net> wrote:
> On Fri, Aug 9, 2013 at 3:07 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>
>> On Thu, 2013-08-08 at 15:21 +0200, Johan Almbladh wrote:
>> > This patch enables power save processing for encrypted frames even if the
>> > encryption key is not set. This is a requirement when implementing split-MAC
>> > systems like Anyfi.net [1] and CAPWAP [2] on mac80211 using monitor frame
>> > injection and reception.
>>
>> I have no idea what these are, nor do I actually want to care much...
>
> Anyfi.net is a dynamic split-mac system where the security part of the
> 802.11 stack is located in your home router and the realtime part is
> handled by any router or AP that happens to be near your current
> location. The two parts are connected dynamically via a UDP tunnel
> that carries raw encrypted 802.11 frames, forming a complete 802.11
> stack that provides your home Wi-Fi wherever you are. In a community
> Wi-Fi deployment, the users get secure Wi-Fi access with automatic
> sign-on via their home Wi-Fi network which is simply available
> everywhere.
>
> Should you find the concept interesting there is quite extensive
> technical documentation at http://anyfi.net/documentation#architecture
> :-)
>
>
>> You presumably use Felix's active monitor mode?
>
> I use a monitor socket in a userspace daemon. The daemon receives
> encrypted 802.11 frames with radiotap encapsulation on this monitor
> socket. It also injects encrypted 802.11 frames with radiotap
> encapsulation by transmitting them on the same socket. I believe this
> is the way hostapd used to handle transmission of management and EAPOL
> frames before they switched to nl80211.
>
>
>> > The mac80211 RX handlers are reordered slightly so
>> > that the power save handler is invoked before the decryption handler.
>> >
>> > The patch is minimal in the sense that it provides the required functionality
>> > with a minimal change, but I am open to suggestions if this change is too
>> > intrusive. Please let me know what you think.
>>
>> I think you should ask yourself if this makes sense in the normal wifi
>> context... :-)
>
> You are right about that, but I think this little feature can be added
> without affecting the normal operation :-) To be honest, mac80211 has
> all the interfaces required for any split-mac implementation, thanks
> to the mac80211/hostapd partitioning. The *only* thing missing is the
> ability to handle AP power save processing without handling the
> encryption...
>
>
>> It actually seems like it *does* make sense, so it should have an
>> appropriate description for that, but I'm a bit worried about IBSS in
>> sta_process.
>
> The patch enables power save processing even if there is no unicast
> key set, but *also* if key is set but the decryption failed. This is
> what I meant with "intrusive". The IBSS updating in sta_process will
> also run in this case, but the STA is still required to be authorized.
>
> It's possible to narrow it down to only affect the case where no
> encryption key is set:
>
> * Keep the RX handlers in their original order
> * Don't drop frames where rx->key is NULL in ieee80211_rx_h_decrypt.
> Instead, mark the frame with a flag
> * Drop any marked frames at the end of ieee80211_rx_h_sta_process with
> RX_DROP_MONITOR
>
> I can prepare a new patch if you prefer this solution.
>
>> Also I've tried to keep the code in the file sequential, so this patch
>> should be moving ieee80211_rx_h_decrypt() itself as well.
>
> I'll make sure to put them in the right order.
>
> Johan
