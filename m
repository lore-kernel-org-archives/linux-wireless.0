Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47020 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbbGBNbm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 09:31:42 -0400
Message-ID: <1435843898.2285.24.camel@sipsolutions.net> (sfid-20150702_153145_992712_25C8385F)
Subject: Re: [PATCH 3/3] mac80211: select an AID when creating new mesh STAs
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Thu, 02 Jul 2015 15:31:38 +0200
In-Reply-To: <1435843690-2856-4-git-send-email-me@bobcopeland.com> (sfid-20150702_152857_136763_8D3993F6)
References: <1435843690-2856-1-git-send-email-me@bobcopeland.com>
	 <1435843690-2856-4-git-send-email-me@bobcopeland.com>
	 (sfid-20150702_152857_136763_8D3993F6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-02 at 09:28 -0400, Bob Copeland wrote:
> 
> +	DECLARE_BITMAP(aid_map, IEEE80211_MAX_AID + 1);
> 
Is there really much point in keeping a long-lived bitmap rather than
iterating the existing stations when adding a new one? It's not such a
frequent operation after all.

johannes
