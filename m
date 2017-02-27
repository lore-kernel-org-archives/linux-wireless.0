Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37904 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751700AbdB0QIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 11:08:43 -0500
Message-ID: <1488211719.28431.22.camel@sipsolutions.net> (sfid-20170227_170944_679179_5DB55A43)
Subject: Re: [PATCH 1/2] mac80211_hwsim: Make sure NEW_RADIO contains final
 name
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Feb 2017 17:08:39 +0100
In-Reply-To: <CAOq732L0wT+HMouihfSYu4hwxy=fh6pieMY3r2DOO1tVXxqw1A@mail.gmail.com> (sfid-20170227_161634_708693_90859E55)
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
         <CAOq732LiwZ13wVuB+wvk6nOCpY+oq=KWhcY1Au2zpcGSWsZ3uA@mail.gmail.com>
         <1488201862.28431.5.camel@sipsolutions.net>
         <CAOq732L0wT+HMouihfSYu4hwxy=fh6pieMY3r2DOO1tVXxqw1A@mail.gmail.com>
         (sfid-20170227_161634_708693_90859E55)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >         [HWSIM_ATTR_RADIO_NAME] = { .type = NLA_STRING },
> > 
> > enforces that a NUL byte *must* be present when userspace gives us
> > the
> > information, so we're save - just asymmetric.
> 
> It seems that would be NLA_NUL_STRING, whlie for NLA_STRING it's
> optional, 

Oops. I indeed misread the code there.

> I know because I didn't add the NUL in my userspace and
> things still worked.

:)
Then you probably had some 0 padding or so.

> We can copy the received nla_data into a buffer
> and add the 0-byte there to support this as an option.

I'll do that.

johannes
