Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59597 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1ITRtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 13:49:04 -0400
Received: by qyk30 with SMTP id 30so4151334qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 10:49:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316533251.3953.46.camel@jlt3.sipsolutions.net>
References: <1316533251.3953.46.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 20 Sep 2011 10:48:42 -0700
Message-ID: <CAB=NE6UEo5C-+KrS+Bvqb2wj5NDcZu5ODqm_a4eSXW9ANU0xxw@mail.gmail.com> (sfid-20110920_194908_608761_376CCA7C)
Subject: Re: [PATCH] mac80211: fix AP/VLAN PS buffer race
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 8:40 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When an AP interface is removed without the
> AP/VLAN interfaces having been removed before
> already, the AP-VLAN interface might still
> have sleeping stations and buffer multicast
> frames which will happen on the AP interface.
> Thus, we need to remove AP/VLAN interfaces
> before purging buffered broadcast frames.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Curious, what was happening with the inverse?

  Luis
