Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365Ab3DPOML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 10:12:11 -0400
Message-ID: <1366121523.8244.23.camel@jlt4.sipsolutions.net> (sfid-20130416_161215_669983_9248B422)
Subject: Re: [PATCH V6] cfg80211: introduce critical protocol indication
 from user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 16 Apr 2013 16:12:03 +0200
In-Reply-To: <1365676794-24717-1-git-send-email-arend@broadcom.com>
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
	 <1365676794-24717-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> I reworked the patch based on your comment in this V6. It
> applies to the master branch on top of commit:
> 
> 5253ffb mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates

Yep, applies, thanks. I think you missed something, I can fix it but
wanted to ask:


> + * @crit_proto_started: true if crit_proto_start() has been done.
>   */
>  struct wireless_dev {

> +	bool crit_proto_started;

This is no longer needed, right?

> +	NL80211_CMD_CRIT_PROTOCOL_START,
> +	NL80211_CMD_CRIT_PROTOCOL_STOP,
> +	NL80211_CMD_CRIT_PROTOCOL_STOPPED_EVENT,

Why use a separate command ID? Usually we use the same _STOP for the
event as well, I think? Except maybe scan which you can't stop? Not
sure ... Anyway I don't mind, just wondering if there was a special
reason to do this.

> + nla_put_failure:
> +	if (hdr)
> +		genlmsg_cancel(msg, hdr);

There's not really a reason to cancel, but we still do most of the time.
I guess we can keep it, but it doesn't matter :)


> --- a/net/wireless/rdev-ops.h
> +++ b/net/wireless/rdev-ops.h
> @@ -875,7 +875,7 @@ static inline void rdev_stop_p2p_device(struct cfg80211_registered_device *rdev,
>  	trace_rdev_stop_p2p_device(&rdev->wiphy, wdev);
>  	rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
>  	trace_rdev_return_void(&rdev->wiphy);
> -}					
> +}

Heh, thanks.
 
johannes

