Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36438 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751356AbdB0NYm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 08:24:42 -0500
Message-ID: <1488201862.28431.5.camel@sipsolutions.net> (sfid-20170227_142445_574059_E83A1207)
Subject: Re: [PATCH 1/2] mac80211_hwsim: Make sure NEW_RADIO contains final
 name
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 27 Feb 2017 14:24:22 +0100
In-Reply-To: <CAOq732LiwZ13wVuB+wvk6nOCpY+oq=KWhcY1Au2zpcGSWsZ3uA@mail.gmail.com> (sfid-20170224_010957_854416_31DD49EC)
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
         <CAOq732LiwZ13wVuB+wvk6nOCpY+oq=KWhcY1Au2zpcGSWsZ3uA@mail.gmail.com>
         (sfid-20170224_010957_854416_31DD49EC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-02-24 at 01:08 +0100, Andrew Zaborowski wrote:
> On 23 February 2017 at 13:02, Andrew Zaborowski
> <andrew.zaborowski@intel.com> wrote:
> > ieee80211_alloc_hw_nm will validate the requested name (if any)
> > before
> > creating the new device and may use a name different from the one
> > requested rather than fail.  Make sure the HWSIM_CMD_NEW_RADIO
> > event/response generated has the final name or userspace will
> > receive
> > the wrong name.  Note that mac80211_hwsim_new_radio may now modify
> > params.
> 
> Also related to this I find that the HWSIM_ATTR_RADIO_NAME attributes
> emitted contain the name string and are exactly of the right length
> while the HWSIM_ATTR_RADIO_NAME attributes received by the kernel are
> assumed to be NUL-terminated.  

I'll agree this is a bit strange - I guess it's too late to fix now
though since userspace might assume "length/data" is the string, rather
than "0-terminated" (especially if there's something like python
userspace where strings can trivially contain NUL bytes).

nla_put_string() would have added the NUL byte.

> Is there a guarantee that a 0-byte
> follows an attribute, or should this be changed for consistency?

        [HWSIM_ATTR_RADIO_NAME] = { .type = NLA_STRING },

enforces that a NUL byte *must* be present when userspace gives us the
information, so we're save - just asymmetric.

Anyway, patch applied.

johannes
