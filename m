Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36938 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751329AbdESKVF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 06:21:05 -0400
Message-ID: <1495189263.3274.4.camel@sipsolutions.net> (sfid-20170519_122108_903718_68DB65A1)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Date: Fri, 19 May 2017 12:21:03 +0200
In-Reply-To: <adcf52eb-cc8f-82de-3820-3f96a0d1f8d3@broadcom.com> (sfid-20170518_144810_571489_47A41759)
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
         <1495030794.2442.21.camel@sipsolutions.net>
         <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
         <1495099355.2553.1.camel@sipsolutions.net>
         <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com>
         <1495104012.2553.3.camel@sipsolutions.net>
         <adcf52eb-cc8f-82de-3820-3f96a0d1f8d3@broadcom.com>
         (sfid-20170518_144810_571489_47A41759)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-05-18 at 14:48 +0200, Arend Van Spriel wrote:

> True. However, we touched this topic a while ago in generic context,
> ie. preference for ext_features over supported_commands. Right now
> wpa_supplicant does not check NEW_KEY support so we can go either
> way.

Right. That's a separate discussion though - whether we add two flags
here or check NEW_KEY support doesn't really matter, except that we
need to decide

 * if we want to support such an override at all, and
 * if it should be tested at all
   (perhaps we can just live with that failing entirely?)

> I have cleaned up the wpa_supplicant patches for the offloads, but
> waited with submitting them until the kernel side got applied. So
> depending on what is decided here I can rework it.

I don't really know. I personally don't think that we need to allow
both ways, but then I'm coming with a driver that doesn't even support
the old way.

So you should probably decide yourself if you want to keep this
fallback option, and how well it should work (be rejected if used on a
driver that doesn't support it, or just fail later?)

johannes
