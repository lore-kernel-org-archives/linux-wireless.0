Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43226 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbdALOGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:06:22 -0500
Message-ID: <1484229979.5391.5.camel@sipsolutions.net> (sfid-20170112_150625_993860_04318F52)
Subject: Re: [PATCH 3/3] cfg80211: Specify the reason for connect timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Date: Thu, 12 Jan 2017 15:06:19 +0100
In-Reply-To: <20170112135843.GB17983@jouni.qca.qualcomm.com>
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
         <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
         <1484141491.29931.10.camel@sipsolutions.net>
         <20170112135843.GB17983@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-12 at 13:58 +0000, Malinen, Jouni wrote:
> 
> > I think this description is misleading - one could easily
> > understand
> > "for other cases" to indicate for the cases that the AP did
> > explicitly
> > reject it, but that's obviously not true.
> 
> Well, the expectation here really was that the reason for the timeout
> would be known if there was a timeout and the unspecified value would
> be used in all other cases, i.e., in cases where the AP did indeed
> explicitly reject the connection.

Hmm. It doesn't really make sense to include the attribute in that case
at all though, does it?

> I guess there might be a driver where the connect request goes into
> firmware implementation and the driver would not know whether the
> operation failed due to authentication frame or association frame
> timeout out.. Implementation itself would still be fine, but I agree
> that it might be a bit confusing the try to interpret the description
> here on what the driver should do.
> 
> > Perhaps that could be reworded, to say it's used when it's not
> > known,
> > or such? I'd not indicate the value (0) either, just specify the
> > name,
> > and put a % in front to get better formatting for it please.
> 
> Sure, I can say that NL80211_TIMEOUT_UNSPECIFIED is used when the
> reason for the timeout is not known or there was an explicit
> rejection instead of a timeout.

See above - why even think about this attribute in the successful case?

> That said, cfg80211_connect_bss() is really currently documented to
> be used only for the success case just like
> cfg80211_connect_result(). In other words, if a driver were to call
> cfg80211_connect_bss(), it should really always specify
> NL80211_TIMEOUT_UNSPECIFIED here based on the current documented us.

> All failure would then need to be reported with
> cfg80211_connect_timeout() for the timeout case or by not following
> the documentation and calling cfg80211_connect_result() or
> cfg80211_connect_bss() for rejection cases. That said, the
> documentation for the connect() callback function does describe the
> failure case behavior correctly. I think I cleaned up that at some
> point, but did not update the function documentation at the same
> time.

Ok.

> So it looks like some additional cleanup would be needed to make the
> documentation actually match what we expect the driver to do for
> rejection cases.. I'd like to leave it out from this specific patch
> and address the cleanup of existing failure case description in a
> separate patch.

Fair enough. I still think we should not include the
ATTR_TIMEOUT_REASON for the successful or explicit rejection case at
all though. We can really even distinguish that in the low-level
function, I think?

johannes
