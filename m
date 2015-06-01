Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33656 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbbFASae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 14:30:34 -0400
Received: by igbpi8 with SMTP id pi8so68108179igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 11:30:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKPhgW6-ugi8kaO8sDvTKm-ScAOOXWavuTNo4w4+WS+6g@mail.gmail.com>
References: <CABPxzYKPhgW6-ugi8kaO8sDvTKm-ScAOOXWavuTNo4w4+WS+6g@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 2 Jun 2015 00:00:13 +0530
Message-ID: <CABPxzY+QEQNA7T+bNqeamM4B8YEwCJx+_kivGQ+3w_UnRNb--Q@mail.gmail.com> (sfid-20150601_203038_778446_F2F96621)
Subject: Re: cfg80211: Beacon hints for DFS channels
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2015 at 1:37 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> Hi,
>
> In the Regulatory and DFS wiki it is mentioned that
> beacon hints are not processed for DFS channels.
> But i could not find the related piece of code which
> does this.
>
> So in DFS channels can we process beacon hints?
> Assuming that if AP is beaconing then there is no
> RADAR in that channel. But how do we handle
> channel switch (if we dont disconnect) then that
> channel is enabled for active scan?
>       (or)
> should be we have something like this:
>
> ---
>
>  net/wireless/reg.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 8c6cf52..25b3173 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1384,7 +1384,8 @@ static void handle_reg_beacon(struct wiphy
> *wiphy, unsigned int chan_idx,
>         chan_before.center_freq = chan->center_freq;
>         chan_before.flags = chan->flags;
>
> -       if (chan->flags & IEEE80211_CHAN_NO_IR) {
> +       if (!(chan->flags & IEEE80211_CHAN_RADAR) &&
> +             (chan->flags & IEEE80211_CHAN_NO_IR)) {
>                 chan->flags &= ~IEEE80211_CHAN_NO_IR;
>                 channel_changed = true;
>         }
>
Luis,

Any comments on this? We are seeing the below behavior:

Channel 60 in US:
     Initially marked as NO_IR
     found a beacon: channel changed to ~NO_IR.
     AP found a radar, issued CSA and move to other channel.
     STA disconnected and does active scan in channel 60..
Now,

a) we can disable beacons hints for DFS channels as per wiki,
so all DFS channels will be marked as NO_IR.

b) up on receiving the ECSA/CSA mark the channel as NO_IR.

Let me know your thoughts.

Regards,
Chaitanya T K.




-- 
Thanks,
Regards,
Chaitanya T K.
