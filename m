Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51930 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2993056AbdD1MCG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 08:02:06 -0400
Message-ID: <1493380923.2431.13.camel@sipsolutions.net> (sfid-20170428_140435_442993_8E5000B6)
Subject: Re: [RFC] cfg80211: add control port state to struct
 cfg80211_connect_resp_params
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 28 Apr 2017 14:02:03 +0200
In-Reply-To: <c0b5817a-c4fa-8f7c-2632-cf22aa09d71b@broadcom.com> (sfid-20170426_204655_775269_D5AEED53)
References: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
         <1493131210.2609.2.camel@sipsolutions.net>
         <b4dc7a6d-7865-1fb5-849a-0ead03a080c3@broadcom.com>
         <1493145418.2609.5.camel@sipsolutions.net>
         <af48efa4-3774-8d8b-ff45-760e558aa681@broadcom.com>
         <1493191249.2464.6.camel@sipsolutions.net>
         <c0b5817a-c4fa-8f7c-2632-cf22aa09d71b@broadcom.com>
         (sfid-20170426_204655_775269_D5AEED53)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I tested the 4-way-hs (both Personal and 802.1X) with boolean
> parameter similar to what is proposed in the patch for roaming
> "cfg80211/nl80211: add authorized flag to roaming event" and it works
> fine. So I can extend it for use in connect result. Just had one
> issue regarding the type, ie. flag vs. u8 because of how things are
> done in wpa_supplicant supporting QCA roam+auth vendor-specific
> event.

Ok.

We have lots of related but somewhat conflicting things in flight right
now, and we need somebody to go collect them all into a consistent
patchset, preferably even with the 4-way-HS offload [1] thrown in. That
needs rebasing anyway because it introduces the _PMK attribute that
Jouni already added for FILS now.

Do you want to pick that up? I probably can't do it soon - I'm likely
busy with other things the next week or two, then travel again, ...

johannes

[1] https://patchwork.kernel.org/patch/9584201/
