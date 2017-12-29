Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:41728 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbdL2J3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 04:29:40 -0500
Received: by mail-wm0-f50.google.com with SMTP id g75so47693111wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 29 Dec 2017 01:29:39 -0800 (PST)
Subject: Re: [RFC 0/4] EAPoL over NL80211
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
References: <20171228175832.3253-1-denkenz@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A460B01.7060603@broadcom.com> (sfid-20171229_102950_356814_E07B6E29)
Date: Fri, 29 Dec 2017 10:29:37 +0100
MIME-Version: 1.0
In-Reply-To: <20171228175832.3253-1-denkenz@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/28/2017 6:58 PM, Denis Kenzior wrote:
> This patchset adds support for running 802.11 authentication mechanisms (e.g.
> 802.1X, 4-Way Handshake, etc) over NL80211 instead of putting them onto the
> network device.  This has the advantage of fixing several long-standing race
> conditions that result from userspace operating on multiple transports in order
> to manage a 802.11 connection (e.g. NL80211 and wireless netdev, wlan0, etc)
>
> For example, userspace would sometimes see 4-Way handshake packets before
> NL80211 signaled that the connection has been established.  Leading to ugly
> hacks or having the STA wait for retransmissions from the AP.
>
> To make this possible this patchset introduces a new NL80211 command and several
> new attributes.  A userspace that is capable of processing EAPoL packets over
> NL80211 includes a new NL80211_ATTR_CONTROL_PORT_OVER_NL80211 attribute in its
> NL80211_CMD_ASSOCIATE or NL80211_CMD_CONNECT requests being sent to the kernel.
> The previously added NL80211_ATTR_SOCKET_OWNER attribute must also be included.

Does it make sense to require a combination of attributes. It is always 
a bit awkward so prefer to avoid it. Could we implicitly make the 
netlink unicast for notifications when 
NL80211_ATTR_CONTROL_PORT_OVER_NL80211 is provided by user-space.

> The latter is used by the kernel to send NL80211_CMD_CONTROL_PORT_FRAME
> notifications back to userspace via a netlink unicast.  If the
> NL80211_ATTR_CONTROL_PORT_OVER_NL80211 attribute is not specified, then legacy
> behavior is kept and control port packets continue to flow over the network
> interface.

[...]

> Open Questions
> ==============
>
> 1. It is not clear whether all drivers provide information as to whether the
> control port frame was sent encrypted or not.  Do they?

You mean in some tx status info. I think brcmfmac does not have that 
info available in the driver, but would need to verify.

> 2. It has been previously suggested that CMD_FRAME infrastructure is used to
> accomplish control port over nl80211 transport.  However, it did not seem to be
> a good fit as the relevant code paths assume that only management frames are
> to be sent via this mechanism.  Thoughts?

What are the issues coming from that assumption? Does it assume 802.11 
header is present? What else?

Regards,
Arend
