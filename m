Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40126 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2KWF6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 00:58:43 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3203127eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 21:58:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50AF0E91.30709@posedge.com>
References: <50AF0E91.30709@posedge.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 23 Nov 2012 16:58:21 +1100
Message-ID: <CAGRGNgW1x0O26SxytoDQLYXFqWcmfaCGE=Q_pxGg31mW0HyRtw@mail.gmail.com> (sfid-20121123_065846_658191_DB2B531E)
Subject: Re: RFC[1/2]mac80211: Add Statistic to debugfs
To: Saravana <saravanad@posedge.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Saravana,

On Fri, Nov 23, 2012 at 4:50 PM, Saravana <saravanad@posedge.com> wrote:
> Provide additional statistic support to the debugfs.
>
> The statistic that are added are the
>
> 1. Number of rx packets dropped due to mic failure
>         - Currently the debugfs has support for number of rx packets
> dropped. But it doesn't classify the reason for the drop. This statistic
> will count the number of rx packet dropped due to mic failure.
>
>  2. Rssi of the Last Ack Frame.
>         - This information is available as part of ieee80211_tx_info status
> structure. Thought this information may be useful(in future).
>
> Signed-off-by: Saravana <saravanad@posedge.com>

Firstly, these two changes should be in separate patches.

Also, as you're adding new statistics which are only used when debugfs
is enabled, you might want to wrap them in #ifdefs so that they're
only compiled when debugfs support is compiled.

>  ---
> The diff file is generated from wireless-testing git tree.
>
> net/mac80211/debugfs_sta.c |    3 +++
>  net/mac80211/sta_info.h    |    4 ++++
>  net/mac80211/status.c      |    2 ++
>  net/mac80211/wpa.c         |    1 +
>  4 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index ab63237..19baafc 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -539,6 +539,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
> struct sk_buff *skb)
>                                 sta->lost_packets = 0;
>                         }
>                 }
> +               if(acked)
> +               sta->last_ack_signal=info->status.ack_signal;

Either the indentation here is wrong or your mailer mangled the patch.
Either way it should get fixed up when you resubmit.

>         }
>
>         rcu_read_unlock();

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
