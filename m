Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45438 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2DCMWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 08:22:23 -0400
Received: by obbtb18 with SMTP id tb18so3489289obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2012 05:22:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333441758.3574.3.camel@jlt3.sipsolutions.net>
References: <20120403082416.559209159@sipsolutions.net>
	<1333441758.3574.3.camel@jlt3.sipsolutions.net>
Date: Tue, 3 Apr 2012 15:22:22 +0300
Message-ID: <CAB3XZEfmBT724sP_3=pmBQixy1eW_x7V9_jsJi0cmWHJvogfVg@mail.gmail.com> (sfid-20120403_142226_954008_A9064CE2)
Subject: Re: [PATCH 1/2] mac80211: add explicit monitor interface if needed
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 3, 2012 at 11:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The queue mapping redesign that I'm planning to do
> will break pure injection unless we handle monitor
> interfaces explicitly. One possible option would
> be to have the driver tell mac80211 about monitor
> mode queues etc., but that would duplicate the API
> since we already need to have queue assignments
> handled per virtual interface.
>
> So in order to solve this, have a virtual monitor
> interface that is added whenever all active vifs
> are monitors. We could also use the state of one
> of the monitor interfaces, but managing that would
> be complicated, so allocate separate state.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> @@ -266,6 +319,12 @@ static int ieee80211_do_open(struct net_
>                        break;
>                }
>
> +               if (local->monitors == 0 && local->open_count == 0) {
> +                       res = ieee80211_add_virtual_monitor(local);
> +                       if (res)
> +                               return res;

you probably have to goto instead (to clean up properly - drv_stop etc.).

Eliad.
