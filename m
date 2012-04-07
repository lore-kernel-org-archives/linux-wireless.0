Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48024 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2DGCYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 22:24:22 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so3783788iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 19:24:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333746081.5577.11.camel@jlt3.sipsolutions.net>
References: <1333746081.5577.11.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Apr 2012 19:24:02 -0700
Message-ID: <CAB=NE6UOGLB8tGM4Z3CN4io3y3UcP0CedPnrDErNvHEO_YTX0g@mail.gmail.com> (sfid-20120407_042434_091072_94CF308F)
Subject: Re: [PATCH] compat-wireless: simplify mac80211 queue backport
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 6, 2012 at 2:01 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> With compat now having a define for netif_wake_subqueue
> for kernels 2.6.23 and higher we can remove most of the
> backport patch for multiqueue. This does give up on
> kernels 2.6.22 and older though.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Tested with ckmake, applied and pushed, thanks!


    mcgrof@flash ~/devel/compat-wireless (git::master)$ time ckmake
    Trying kernel                     3.2.2-030202-generic  [OK]
    Trying kernel                    3.1.10-030110-generic  [OK]
    Trying kernel                    3.0.18-030018-generic  [OK]
    Trying kernel                  2.6.39-02063904-generic  [OK]
    Trying kernel                  2.6.38-02063808-generic  [OK]
    Trying kernel                  2.6.37-02063706-generic  [OK]
    Trying kernel                  2.6.36-02063604-generic  [OK]
    Trying kernel                  2.6.35-02063512-generic  [OK]
    Trying kernel                  2.6.34-02063410-generic  [OK]
    Trying kernel                  2.6.33-02063305-generic  [OK]
    Trying kernel                  2.6.32-02063255-generic  [OK]
    Trying kernel                  2.6.31-02063113-generic  [OK]
    Trying kernel                  2.6.30-02063010-generic  [OK]
    Trying kernel                  2.6.29-02062906-generic  [OK]
    Trying kernel                  2.6.28-02062810-generic  [OK]
    Trying kernel                    2.6.27-020627-generic  [OK]
    Trying kernel                    2.6.26-020626-generic  [OK]
    Trying kernel                    2.6.25-020625-generic  [OK]
    Trying kernel                    2.6.24-020624-generic  [OK]

    real    27m43.716s
    user    69m9.115s
    sys     13m8.241s

  Luis
