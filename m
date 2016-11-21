Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33046 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752891AbcKUIuf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 03:50:35 -0500
Message-ID: <1479718228.8662.9.camel@sipsolutions.net> (sfid-20161121_095054_509515_4EAC96AA)
Subject: form factor subsystem (Re: [PATCH] cfg80211/nl80211: add wifi tx
 power mode switching support)
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei-Ning Huang <wnhuang@chromium.org>,
        Linux-Wireless <linux-wireless@vger.kernel.org>,
        Luca Coelho <luca@coelho.fi>, haim.dreyfuss@intel.com
Cc: Sameer Nanda <snanda@chromium.org>,
        Todd Broch <tbroch@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 21 Nov 2016 09:50:28 +0100
In-Reply-To: <1462430663-9448-1-git-send-email-wnhuang@chromium.org> (sfid-20160505_084509_232618_BB2A36EB)
References: <1462430663-9448-1-git-send-email-wnhuang@chromium.org>
         (sfid-20160505_084509_232618_BB2A36EB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm revisiting this since we're asked to do the same for iwlwifi.

On Thu, 2016-05-05 at 14:44 +0800, Wei-Ning Huang wrote:
> Recent new hardware has the ability to switch between tablet mode and
> clamshell mode. To optimize WiFi performance, we want to be able to
> use different power table between modes. This patch adds a new
> netlink message type and cfg80211_ops function to allow userspace to
> trigger a power mode switch for a given wireless interface.

I've thought about this a bit more, and also heard this in different
contexts now, and I'm actually not convinced that the wifi subsystem
exposing this *in any way* is the right thing to do.

Why don't we add a minimal "form factor" subsystem to the kernel?
Something that allows

 1) sensor/BIOS/... drivers to call a function to switch form factor
 2) consumers to register and get callbacks when switching happens

If the sensor driver is in the kernel (some kind of driver probably has
to be anyway), or form factor switch ends up being a BIOS notification,
then this gets rid of a lot of complexity - no more need to bump this
through userspace etc.

If, for some reason, the sensor driver really has to be in userspace,
then some kind of API *to this subsystem* can be implemented to set the
form factor mode from userspace, and all the other stuff can be left as
is.

This would also allow other clients to know about this information,
let's say, for the sake of an argument that doesn't seem *too* far-
fetched, that the compass driver needs to adjust the direction if you
switch modes.

It seems to me that this would be more robust, which can only be a good
thing if we start using it for things that might be regulatory
relevant.

Additionally, the subsystem could allow userspace to also get an event
if it wants to know about this, e.g. to switch to a more touch-friendly 
UI on switching to tablet mode, or something.

Thoughts?

johannes
