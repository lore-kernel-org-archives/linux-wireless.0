Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53206 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbaESNSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 09:18:42 -0400
Received: by mail-ie0-f177.google.com with SMTP id y20so2439608ier.8
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 06:18:41 -0700 (PDT)
Date: Mon, 19 May 2014 09:18:32 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 802.11s mode without HWMP
Message-ID: <20140519131832.GA6198@localhost> (sfid-20140519_151847_627819_46EBA0B3)
References: <CAGnRvurDvRqeNZYHZQG63=6FQv2XnFOR+J9K4-Dk=F77c6SdKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGnRvurDvRqeNZYHZQG63=6FQv2XnFOR+J9K4-Dk=F77c6SdKQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 11:00:53AM +0200, Henning Rogge wrote:
> Is there an easy way to stop HWMP in the 802.11s implementation?

If I understand your use case, you want to basically remove the
resolving part of mesh_nexthop_resolve()?  I don't believe the
current implementation has a way to turn that off.  In principle,
you can specify a vendor-specific path selection protocol when
joining, but glancing at the existing code, we don't really do
anything with that field except use it for peering fitness checks.

If all you want to do is force the paths, you can do so with the
NL80211_CMD_SET_MESH_PATH API; such paths would override any selected
by HWMP.  But you'd still generate PREQ/PREPs and get multihop
communication in that case, it just wouldn't be subject to the
airtime link metric.

Perhaps we should skip resolve in case ifmsh->mesh_pp_id != 1
and assume paths are somehow set up out of band or something?

-- 
Bob Copeland %% www.bobcopeland.com
