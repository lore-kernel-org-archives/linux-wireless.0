Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45600 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbdINLo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 07:44:26 -0400
Message-ID: <1505389462.31630.6.camel@sipsolutions.net> (sfid-20170914_134503_600043_DC6E7C70)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Denis Kenzior <denkenz@gmail.com>
Date: Thu, 14 Sep 2017 13:44:22 +0200
In-Reply-To: <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com> (sfid-20170914_132146_263452_CA82BA42)
References: <1505378361.31630.2.camel@sipsolutions.net>
         <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com>
         (sfid-20170914_132146_263452_CA82BA42)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-14 at 13:21 +0200, Arend van Spriel wrote:

> Yep. Toggling the OPER_STATE seems to go against what roaming is
> about. 

Agree.

> Come to think of it, is it a good idea to tightly couple
> PORT_AUTHORIZED to OPER_STATE. Aren't these separate concepts in
> different layers of the network stack.

Well, I think that coupling would make the most sense, since once you
have oper state UP you'll try to get IPv6 etc., no? And before being
authorized there's no point.

Note that we *can't* do this right now, otherwise we can't transfer the
EAPOL frames; but once we do that over nl80211 we'd be able to.

> In earlier discussions the proposal for a separate event was made by 
> Jithu (colleague). In brcmfmac it would become a bit less
> complicated with a separate event so it has my vote as well. So the
> AUTHORIZED event will have no attributes, right? So if the event
> occurs it is AUTHORIZED.

I think so, yes. I pondered having the attribute in there so you could
explicitly have a "not authorized" event, but do we really need that?
If you get disconnected that's pretty much implied, so ... I don't
think we need it.


> > (*) is anyone working on that? I'll throw it on my list if not.

["that" being EAPOL-over-nl80211]

> The last I saw on this was Denis Kenzior volunteering for it, but
> that was about it.

Oh, thanks for the reminder, I'd forgotten entirely...
Denis?

> By the way, I still have wpa_supplicant patches for 4way-hs
> offloading. I need to dust it off a little and obviously did not
> foresee the change above ;-) Let me know if you (Intel) plan to
> submit patches for it.

We also have some patches, we can go either way.

Thanks!

johannes
