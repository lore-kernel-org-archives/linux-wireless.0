Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:64527 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab3FCPEM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:04:12 -0400
Message-ID: <51ACB068.8070006@lri.fr> (sfid-20130603_170414_595385_4FA3EC7A)
Date: Mon, 03 Jun 2013 17:04:08 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Antonio Quartulli <ordex@autistici.org>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH 1/2] nl80211: allow sending CMD_FRAME without specifying
 any frequency
References: <1370241587-2609-1-git-send-email-ordex@autistici.org> <1370271547.8227.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1370271547.8227.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2013 16:59, Johannes Berg wrote:
> On Mon, 2013-06-03 at 08:39 +0200, Antonio Quartulli wrote:
>> From: Antonio Quartulli <antonio@open-mesh.com>
>>
>> Users may want to send a frame on the current channel
>> without specifying it.
>>
>> Make mgmt_tx pass a NULL channel to mac80211 if none has
>> been specified by the user.
> 
> cfg80211 isn't just a mac80211 frontend ... ;-)
> 
> Also, as Nicolas said, ath6kl_mgmt_tx() will crash after this patch if
> it's called in AP mode w/o a channel, so you need to think about that.

It will crash unconditionally. All ath6kl_mgmt_tx()'s code paths access
chan->center_freq at some point.
