Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:58281 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbbGGPAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 11:00:44 -0400
Date: Tue, 7 Jul 2015 18:00:40 +0300
From: Jouni Malinen <j@w1.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: Association race when acting as AP?
Message-ID: <20150707150040.GA1374@w1.fi> (sfid-20150707_170047_704188_0741880A)
References: <CA+BoTQm==AM3F2Fxq6T_+uY+jq0yXc9JHFT0iwpe2XJrmxkSsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+BoTQm==AM3F2Fxq6T_+uY+jq0yXc9JHFT0iwpe2XJrmxkSsg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 02, 2015 at 10:24:33AM +0200, Michal Kazior wrote:
> After looking into hostapd code I noticed something strange and I wonder if
> anyone else is already aware of this problem:
> 
>  1. AP starts
>  2. STA->AP auth OTA
>  3. AP->STA auth OTA
>  4. STA->AP assoc req OTA
>  5. AP->STA assoc resp OTA
>  6. STA sends NullFunc with "STA will go to sleep" bit set
>  7. AP driver/device sees a frame from with unknown TA/SA and issues Deauth
> w/ Reason 7
>    (this Deauth doesn't originate from hostapd; it comes from the device FW
> in my case)

If there is a driver or firmware design that sends these
Deauthentication frames on their own, they better be able to handle race
conditions and enable this functionality at the correct time.. Sure,
cfg80211 and hostapd may need modifications to make this work better,
but this needs to be done for things to work properly. There's a good
reason for hostapd having code to check the internal STA associated
flag before triggering deauthentication based on EVENT_RX_FROM_UNKNOWN
events..

> To me this looks like a race in hostapd. The station should be installed to
> driver _before_ sending Assoc Resp frame, not after. My quick-n-dirty hack
> seems to help:

Adding a STA entry before sending Association Response frame would be
fine, but this change would do more: it would claim that STA entry to be
in associated state. That is not correct from the IEEE 802.11 standard
view point. On the AP side, a STA becomes associated when an ACK frame
to the (Re)Association Response frame is received by the AP.

-- 
Jouni Malinen                                            PGP id EFC895FA
