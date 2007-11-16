Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:47589 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750982AbXKPOw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 09:52:29 -0500
Date: Fri, 16 Nov 2007 15:49:02 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Li YanBo <dreamfly281@gmail.com>, Ben Gamari <ben@mw0.ath.cx>,
	linux-wireless@vger.kernel.org,
	Jose Ignacio Naranjo Hernandez
	<joseignacio.naranjo@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
Subject: Re: Suspend/Resume support
Message-ID: <20071116154902.16b7866c@morte> (sfid-20071116_145231_953493_447BD3C9)
In-Reply-To: <87ir42z5kq.fsf@nokia.com>
References: <1195087905.3814.11.camel@mercury>
	<1197ff4c0711141937gc7bb1f8w499cd9d8634fa232@mail.gmail.com>
	<1195171869.8147.79.camel@johannes.berg>
	<87ir42z5kq.fsf@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Nov 2007 15:24:21 +0200
Kalle Valo <Kalle.Valo@nokia.com> wrote:

> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > If it is, we need to determine whether we were suspended long enough
> > for it to kick us off. It might be possible to do this by sending a
> > null function frame to the AP and see if it replies with a deauth
> > notification, I think it should if we're not associated [3].
> 
> I think that at least most (if not all) of the APs do send a deauth
> frame in that case. I have seen this happening when debugging some
> bugs. But I don't know if the standard specifies that.

Yes, it does - implicitly. Please see 802.11, 7.3.1.7, Table 18, reason
codes of deauthentication frames are 6 for "Class 2 [1] frame received from
nonauthenticated station" and 7 for "Class 3 [1] frame received from
nonassociated station". But IIRC hostapd doesn't do that, some APs in my
neighborhood and mine don't either - I'd say this isn't strongly required
by the standard. I'd suggest that, in case we don't get a reply for some
time, we should retry association. The problem here is that some userspace
tools like wpa_supplicant retry association by themselves, and there could
be issues with roaming. On the other side, if we don't want to break
wireless extensions compatibility, we should ensure that, once we set an
ESSID with - say - iwconfig, we stay associated and - in case - reassociate.


[1] 802.11, 5.5


-- 
Ciao
Stefano
