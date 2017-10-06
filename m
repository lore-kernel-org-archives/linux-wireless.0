Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53122 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdJFJtH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 05:49:07 -0400
Message-ID: <1507283341.19300.7.camel@sipsolutions.net> (sfid-20171006_114929_383923_913A41D6)
Subject: Re: [PATCH v2] net/mac80211/mesh_plink: Convert timers to use
 timer_setup()
From: Johannes Berg <johannes@sipsolutions.net>
To: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Date: Fri, 06 Oct 2017 11:49:01 +0200
In-Reply-To: <20171005173910.GA72335@beast> (sfid-20171005_193914_221837_94F6B621)
References: <20171005173910.GA72335@beast>
         (sfid-20171005_193914_221837_94F6B621)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-10-05 at 10:39 -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list
> pointer to
> all timer callbacks, switch to using the new timer_setup() and
> from_timer()
> to pass the timer pointer explicitly. This requires adding a pointer
> back
> to the sta_info since container_of() can't resolve the sta_info.
> 
Applied, thanks. (The change did land in net-next, and I merged that in
to merge this)

johannes
