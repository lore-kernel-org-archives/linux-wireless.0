Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33395 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbcAZVow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 16:44:52 -0500
Received: by mail-qk0-f196.google.com with SMTP id q184so6345903qkb.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 13:44:51 -0800 (PST)
Date: Tue, 26 Jan 2016 16:44:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Henning Rogge <hrogge@gmail.com>, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH 1/2] mac80211: Remove connected MPP table entries with
 MPath
Message-ID: <20160126214446.GB5710@localhost> (sfid-20160126_224455_386323_12664750)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-2-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453808485.2759.32.camel@sipsolutions.net>
 <20160126183628.GA30183@localhost>
 <1453841613.2759.77.camel@sipsolutions.net>
 <20160126212221.GA5710@localhost>
 <1453843889.2759.78.camel@sipsolutions.net>
 <1453843943.2759.79.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1453843943.2759.79.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2016 at 10:32:23PM +0100, Johannes Berg wrote:
> On Tue, 2016-01-26 at 22:31 +0100, Johannes Berg wrote:
> > On Tue, 2016-01-26 at 16:22 -0500, Bob Copeland wrote:
> > >  
> > > void mesh_path_flush_by_nexthop(struct sta_info *sta)
> > > {
> > >     [...]
> > > 	rhashtable_walk_start(&iter);
> > 
> > It seems you need to check the return value here?
> > 
> 
> Actually, maybe not. Not sure I understand the return to beginning
> though.

I'll RFC that patch, it doesn't work right now anyway as
rhashtable_walk_init() does a GFP_KERNEL allocation and we want to call
it from the RX path (maybe not a good idea, but that's what the code
currently does).

-- 
Bob Copeland %% http://bobcopeland.com/
